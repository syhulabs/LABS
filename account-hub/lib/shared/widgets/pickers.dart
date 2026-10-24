import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../core/json_list.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/platform_repository.dart';
import '../../domain/enums.dart';
import 'form_sheet.dart';
import 'platform_logo.dart';
import 'toast.dart';

/// Email identity selector: pick an existing identity or add a new one inline
/// (which creates a reusable identity, never a per-account copy).
class EmailPicker extends ConsumerWidget {
  const EmailPicker({super.key, required this.value, required this.onChanged, this.label = 'Email identity'});
  final String? value;
  final ValueChanged<String?> onChanged;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emails = ref.watch(emailsProvider).value ?? const <EmailIdentity>[];
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: AppDropdown<String>(
          label: label,
          value: value,
          allowNull: true,
          nullLabel: 'No email linked',
          items: [for (final e in emails) (e.id, e.displayName == null ? e.address : '${e.address} · ${e.displayName}')],
          onChanged: onChanged,
        ),
      ),
      const SizedBox(width: 8),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: IconButton.outlined(
          tooltip: 'Add a new email identity',
          icon: const Icon(Icons.add),
          onPressed: () async {
            final id = await showQuickEmailDialog(context, ref);
            if (id != null) onChanged(id);
          },
        ),
      ),
    ]);
  }
}

Future<String?> showQuickEmailDialog(BuildContext context, WidgetRef ref) {
  final addr = TextEditingController();
  final name = TextEditingController();
  var classification = Classification.personal;
  return showFormSheet<String>(context, title: 'New email identity', maxWidth: 460, builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AppTextField(controller: addr, label: 'Email address', autofocus: true, keyboardType: TextInputType.emailAddress, prefixIcon: Icons.alternate_email),
        AppTextField(controller: name, label: 'Display name (optional)'),
        ClassificationToggle(value: classification, onChanged: (v) => setState(() => classification = v)),
        FormActions(
          onCancel: close,
          onSave: () async {
            try {
              final e = await ref.read(emailRepositoryProvider).upsert(address: addr.text, displayName: name.text.trim().isEmpty ? null : name.text.trim(), classification: classification);
              close(e.id);
            } catch (e) {
              if (ctx.mounted) showToast(ctx, friendlyError(e), error: true);
            }
          },
        ),
      ]);
    });
  });
}

/// Searchable platform picker over the whole catalog (+ custom platforms).
Future<Platform?> showPlatformPicker(BuildContext context, WidgetRef ref, {String? category, String? title}) {
  return showFormSheet<Platform>(context, title: title ?? 'Choose a platform', maxWidth: 520, builder: (ctx, close) {
    return _PlatformPickerBody(category: category, onPick: (p) => close(p));
  });
}

class _PlatformPickerBody extends ConsumerStatefulWidget {
  const _PlatformPickerBody({this.category, required this.onPick});
  final String? category;
  final ValueChanged<Platform> onPick;
  @override
  ConsumerState<_PlatformPickerBody> createState() => _PlatformPickerBodyState();
}

class _PlatformPickerBodyState extends ConsumerState<_PlatformPickerBody> {
  String _q = '';
  @override
  Widget build(BuildContext context) {
    final all = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
    var list = PlatformRepository.filter(all, query: _q, category: _q.isEmpty ? widget.category : null);
    list.sort((a, b) {
      if (a.inMyWorld != b.inMyWorld) return a.inMyWorld ? -1 : 1;
      return a.name.compareTo(b.name);
    });
    list = list.take(60).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(autofocus: true, decoration: const InputDecoration(hintText: 'Search platforms…', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v)),
      const SizedBox(height: 10),
      SizedBox(
        height: 380,
        child: list.isEmpty
            ? Center(child: Text('No platform matches. You can add a custom platform from Explore.', style: TextStyle(color: context.colors.textMuted)))
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final p = list[i];
                  return ListTile(
                    leading: PlatformLogo(platform: p, size: 36),
                    title: Text(p.name),
                    subtitle: Text(decodeStringList(p.categories).take(2).join(' · '), maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: p.inMyWorld ? Icon(Icons.public, size: 16, color: context.colors.accent) : null,
                    onTap: () => widget.onPick(p),
                  );
                },
              ),
      ),
    ]);
  }
}

/// Picks an entity of a given type to link to (projects, accounts, emails...).
Future<(EntityType, String)?> showEntityPicker(BuildContext context, WidgetRef ref, {List<EntityType>? allowed}) {
  return showFormSheet<(EntityType, String)>(context, title: 'Link to…', maxWidth: 520, builder: (ctx, close) {
    return _EntityPickerBody(allowed: allowed ?? const [EntityType.project, EntityType.serviceAccount, EntityType.emailIdentity, EntityType.youtubeChannel, EntityType.subscription, EntityType.organization, EntityType.artist, EntityType.documentReference, EntityType.bankAccount], onPick: close);
  });
}

class _EntityPickerBody extends ConsumerStatefulWidget {
  const _EntityPickerBody({required this.allowed, required this.onPick});
  final List<EntityType> allowed;
  final void Function([(EntityType, String)?]) onPick;
  @override
  ConsumerState<_EntityPickerBody> createState() => _EntityPickerBodyState();
}

class _EntityPickerBodyState extends ConsumerState<_EntityPickerBody> {
  late EntityType _type = widget.allowed.first;
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, String?)>[];
    switch (_type) {
      case EntityType.project:
        items.addAll((ref.watch(projectsProvider).value ?? []).map((p) => (p.id, p.name, enumFromName(ProjectKind.values, p.kind, ProjectKind.other).label)));
      case EntityType.serviceAccount:
        items.addAll((ref.watch(accountsProvider).value ?? []).map((a) => (a.account.id, '${a.platform.name} · ${a.account.accountName}', a.email?.address)));
      case EntityType.emailIdentity:
        items.addAll((ref.watch(emailsProvider).value ?? []).map((e) => (e.id, e.address, e.displayName)));
      case EntityType.youtubeChannel:
        items.addAll((ref.watch(channelsProvider).value ?? []).map((c) => (c.channel.id, c.channel.name, c.channel.handle)));
      case EntityType.subscription:
        items.addAll((ref.watch(subscriptionsProvider).value ?? []).map((s) => (s.sub.id, s.sub.serviceName, s.sub.plan)));
      case EntityType.organization:
        items.addAll((ref.watch(organizationsProvider).value ?? []).map((o) => (o.id, o.name, enumFromName(OrganizationKind.values, o.kind, OrganizationKind.business).label)));
      case EntityType.artist:
        items.addAll((ref.watch(artistsProvider).value ?? []).map((a) => (a.id, a.name, a.genre)));
      case EntityType.documentReference:
        items.addAll((ref.watch(documentsProvider).value ?? []).map((d) => (d.id, d.title, d.kind)));
      case EntityType.bankAccount:
        items.addAll((ref.watch(bankAccountsProvider).value ?? []).map((b) => (b.id, b.nickname, b.bankName)));
      default:
        break;
    }
    final q = _q.toLowerCase();
    final filtered = items.where((i) => q.isEmpty || i.$2.toLowerCase().contains(q) || (i.$3 ?? '').toLowerCase().contains(q)).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (final t in widget.allowed) Padding(padding: const EdgeInsets.only(right: 6), child: ChoiceChip(label: Text(t.label), selected: _type == t, onSelected: (_) => setState(() => _type = t))),
        ]),
      ),
      const SizedBox(height: 10),
      TextField(decoration: const InputDecoration(hintText: 'Search…', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v)),
      const SizedBox(height: 8),
      SizedBox(
        height: 340,
        child: filtered.isEmpty
            ? Center(child: Text('Nothing to link yet in ${_type.label}.', style: TextStyle(color: context.colors.textMuted)))
            : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) => ListTile(
                  leading: MonogramAvatar(text: filtered[i].$2, seed: filtered[i].$1, size: 34),
                  title: Text(filtered[i].$2, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: filtered[i].$3 == null ? null : Text(filtered[i].$3!, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => widget.onPick((_type, filtered[i].$1)),
                ),
              ),
      ),
    ]);
  }
}
