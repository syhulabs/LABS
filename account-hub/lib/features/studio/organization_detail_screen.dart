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
import 'organization_form.dart';
import 'project_form.dart';
import 'studio_providers.dart';

class OrganizationDetailScreen extends ConsumerWidget {
  const OrganizationDetailScreen({super.key, required this.organizationId});
  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final o = ref.watch(organizationByIdProvider(organizationId)).value;
    if (o == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.studio))),
        body: const Center(child: Text('Organization not found')),
      );
    }
    final kind = enumFromName(OrganizationKind.values, o.kind, OrganizationKind.business);
    final email = (ref.watch(emailsProvider).value ?? const <EmailIdentity>[]).where((e) => e.id == o.primaryEmailId).firstOrNull;
    final projects = (ref.watch(projectsProvider).value ?? const <Project>[]).where((p) => p.organizationId == o.id).toList();
    final artists = (ref.watch(artistsProvider).value ?? const <Artist>[]).where((a) => a.labelId == o.id).toList();
    final channels = (ref.watch(channelsProvider).value ?? const []).where((v) => v.channel.organizationId == o.id).toList();
    final banks = (ref.watch(bankAccountsProvider).value ?? const <BankAccount>[]).where((b) => b.organizationId == o.id).toList();
    final repo = ref.read(projectRepositoryProvider);
    final fallback = kind == OrganizationKind.recordLabel ? Routes.music : Routes.studio;

    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(o.name), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(fallback))),
      body: PageScaffold(
        title: o.name,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          MonogramAvatar(text: o.name, seed: o.id, size: 72, icon: kind == OrganizationKind.recordLabel ? Icons.album_outlined : kind == OrganizationKind.studio ? Icons.movie_creation_outlined : Icons.business_outlined),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.name, style: context.text.headlineMedium),
            if (o.description != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(o.description!, style: context.text.bodyMedium?.copyWith(color: c.textMuted))),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              StatusChip(kind.label, color: c.accent, dense: false),
              if (o.archivedAt != null) const StatusChip('Archived', dense: false),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            if (o.website != null) FilledButton.icon(onPressed: () => openUrl(context, o.website), icon: const Icon(Icons.open_in_new, size: 18), label: const Text('Open website')),
            OutlinedButton.icon(onPressed: () => showOrganizationForm(context, ref, existing: o), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            OutlinedButton.icon(onPressed: () => showProjectForm(context, ref, presetOrganizationId: o.id), icon: const Icon(Icons.add, size: 18), label: const Text('New project here')),
            OutlinedButton.icon(
              onPressed: () async {
                await repo.setOrganizationArchived(o.id, o.archivedAt == null);
                if (context.mounted) showToast(context, o.archivedAt == null ? 'Archived' : 'Restored');
              },
              icon: Icon(o.archivedAt == null ? Icons.archive_outlined : Icons.unarchive_outlined, size: 18),
              label: Text(o.archivedAt == null ? 'Archive' : 'Restore'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete ${kind.label.toLowerCase()}?', message: 'Removes "${o.name}". Projects, artists, channels and bank accounts are kept but detached.')) return;
                await repo.deleteOrganization(o.id);
                if (context.mounted) context.canPop() ? context.pop() : context.go(fallback);
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          const SizedBox(height: 20),
          if (email != null)
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ListTile(leading: MonogramAvatar(text: email.address, seed: email.id, size: 36), title: Text(email.address), subtitle: const Text('Primary email'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(Routes.email(email.id))),
            ),
          const SizedBox(height: 16),
          SectionHeader(title: 'Projects', subtitle: '${projects.length}'),
          if (projects.isEmpty)
            Text('No projects attached yet.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
          else
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final p in projects) ActionChip(avatar: const Icon(Icons.folder_outlined, size: 16), label: Text('${p.name} · ${statusLabel(p.status)}'), onPressed: () => context.push(Routes.project(p.id))),
            ]),
          if (kind == OrganizationKind.recordLabel || artists.isNotEmpty) ...[
            const SizedBox(height: 18),
            SectionHeader(title: 'Artists signed', subtitle: '${artists.length}'),
            if (artists.isEmpty)
              Text('No artists attached to this label yet.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
            else
              Wrap(spacing: 8, runSpacing: 8, children: [for (final a in artists) ActionChip(avatar: const Icon(Icons.mic_none, size: 16), label: Text(a.name), onPressed: () => context.push(Routes.artist(a.id)))]),
          ],
          if (channels.isNotEmpty) ...[
            const SizedBox(height: 18),
            SectionHeader(title: 'YouTube channels', subtitle: '${channels.length}'),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final v in channels) ActionChip(avatar: const Icon(Icons.play_circle_outline, size: 16), label: Text(v.channel.name), onPressed: () => context.push(Routes.channel(v.channel.id)))]),
          ],
          if (banks.isNotEmpty) ...[
            const SizedBox(height: 18),
            SectionHeader(title: 'Bank accounts', subtitle: 'Nicknames only; details live in Banking & Payments'),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final b in banks) ActionChip(avatar: const Icon(Icons.account_balance_outlined, size: 16), label: Text('${b.nickname} · ${b.bankName}'), onPressed: () => context.push(Routes.bank(b.id)))]),
          ],
          const SizedBox(height: 20),
          RelationsPanel(type: EntityType.organization, id: o.id),
          if (o.notes != null) ...[
            const SizedBox(height: 20),
            Text('Notes', style: context.text.titleMedium),
            const SizedBox(height: 6),
            SelectableText(o.notes!),
          ],
        ],
      ),
    );
  }
}
