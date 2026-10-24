import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/db/app_database.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/relations_panel.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'channel_form.dart';
import 'youtube_providers.dart';

class ChannelDetailScreen extends ConsumerWidget {
  const ChannelDetailScreen({super.key, required this.channelId});
  final String channelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final view = ref.watch(channelByIdProvider(channelId)).value;
    if (view == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.youtube))),
        body: const Center(child: Text('Channel not found')),
      );
    }
    final ch = view.channel;
    final artist = (ref.watch(artistsProvider).value ?? const <Artist>[]).where((a) => a.id == ch.artistId).firstOrNull;
    final org = (ref.watch(organizationsProvider).value ?? const <Organization>[]).where((o) => o.id == ch.organizationId).firstOrNull;
    final repo = ref.read(youtubeRepositoryProvider);
    final fields = <(String, String?)>[
      ('Handle', ch.handle),
      ('Channel ID', ch.channelId),
      ('URL', ch.url),
      ('Type', ch.channelType),
      ('Purpose', ch.purpose),
      ('Branding notes', ch.brandingNotes),
      ('Notes', ch.notes),
    ].where((f) => f.$2 != null && f.$2!.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(ch.name), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.youtube))),
      body: PageScaffold(
        title: ch.name,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          MonogramAvatar(text: ch.name, seed: ch.id, size: 72, icon: Icons.play_arrow_rounded),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ch.name, style: context.text.headlineMedium),
            if (ch.handle != null) Text(ch.handle!, style: context.text.bodyMedium?.copyWith(color: c.textMuted)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              StatusChip(statusLabel(ch.status), color: statusColor(context, ch.status), dense: false),
              if (ch.channelType != null) StatusChip(ch.channelType!, color: const Color(0xFFFF0033), dense: false),
              if (ch.archivedAt != null) const StatusChip('Archived', dense: false),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(onPressed: () => openUrl(context, channelLink(ch)), icon: const Icon(Icons.open_in_new, size: 18), label: const Text('Open channel')),
            OutlinedButton.icon(onPressed: () => showChannelForm(context, ref, existing: view), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            OutlinedButton.icon(
              onPressed: () async {
                await repo.setArchived(ch.id, ch.archivedAt == null);
                if (context.mounted) showToast(context, ch.archivedAt == null ? 'Channel archived' : 'Channel restored');
              },
              icon: Icon(ch.archivedAt == null ? Icons.archive_outlined : Icons.unarchive_outlined, size: 18),
              label: Text(ch.archivedAt == null ? 'Archive' : 'Restore'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete channel?', message: 'Removes "${ch.name}" and its manager links from the hub.')) return;
                await repo.delete(ch.id);
                if (context.mounted) context.canPop() ? context.pop() : context.go(Routes.youtube);
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Ownership & access'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: [
              ListTile(
                leading: view.owner == null ? const Icon(Icons.help_outline) : MonogramAvatar(text: view.owner!.address, seed: view.owner!.id, size: 36),
                title: Text(view.owner?.address ?? 'No owner set'),
                subtitle: Text(view.owner == null ? 'Set the owning Google account in Edit' : 'Owner · ${view.owner!.displayName ?? view.owner!.provider ?? 'Google account'}'),
                trailing: view.owner == null ? null : const Icon(Icons.chevron_right),
                onTap: view.owner == null ? null : () => context.push(Routes.email(view.owner!.id)),
              ),
              for (final (e, role) in view.managers)
                ListTile(
                  leading: MonogramAvatar(text: e.address, seed: e.id, size: 36),
                  title: Text(e.address),
                  subtitle: Text(role.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.email(e.id)),
                ),
              if (view.managers.isEmpty) Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 12), child: Align(alignment: Alignment.centerLeft, child: Text('No additional managers.', style: context.text.bodySmall?.copyWith(color: c.textMuted)))),
            ]),
          ),
          if (artist != null || org != null) ...[
            const SizedBox(height: 20),
            const SectionHeader(title: 'Associated with'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (artist != null) ActionChip(avatar: const Icon(Icons.mic_none, size: 16), label: Text(artist.name), onPressed: () => context.push(Routes.artist(artist.id))),
              if (org != null) ActionChip(avatar: const Icon(Icons.business_outlined, size: 16), label: Text(org.name), onPressed: () => context.push(Routes.organization(org.id))),
            ]),
          ],
          if (fields.isNotEmpty) ...[
            const SizedBox(height: 20),
            const SectionHeader(title: 'Details'),
            AppCard(
              child: Column(children: [
                for (final f in fields)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 130, child: Text(f.$1, style: context.text.bodySmall?.copyWith(color: c.textMuted))),
                      Expanded(child: SelectableText(f.$2!)),
                    ]),
                  ),
              ]),
            ),
          ],
          const SizedBox(height: 20),
          RelationsPanel(type: EntityType.youtubeChannel, id: ch.id),
        ],
      ),
    );
  }
}
