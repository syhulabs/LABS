import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/db/app_database.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/relations_panel.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'project_form.dart';
import 'studio_providers.dart';
import 'studio_screen.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final p = ref.watch(projectByIdProvider(projectId)).value;
    if (p == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.studio))),
        body: const Center(child: Text('Project not found')),
      );
    }
    final kind = enumFromName(ProjectKind.values, p.kind, ProjectKind.other);
    final org = (ref.watch(organizationsProvider).value ?? const <Organization>[]).where((o) => o.id == p.organizationId).firstOrNull;
    final artist = (ref.watch(artistsProvider).value ?? const <Artist>[]).where((a) => a.id == p.artistId).firstOrNull;
    final repo = ref.read(projectRepositoryProvider);

    Future<void> quickLink(EntityType type) async {
      final picked = await showEntityPicker(context, ref, allowed: [type]);
      if (picked == null || !context.mounted) return;
      await guard(context, () => repo.link(EntityType.project, p.id, picked.$1, picked.$2), success: 'Linked');
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(p.name), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.studio))),
      body: PageScaffold(
        title: p.name,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          MonogramAvatar(text: p.name, seed: p.id, size: 72, icon: iconForProjectKind(kind)),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: context.text.headlineMedium),
            if (p.description != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(p.description!, style: context.text.bodyMedium?.copyWith(color: c.textMuted))),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              StatusChip(kind.label, color: c.accent, dense: false, icon: iconForProjectKind(kind)),
              StatusChip(statusLabel(p.status), color: statusColor(context, p.status), dense: false),
              ClassificationChip(p.classification),
              if (p.archivedAt != null) const StatusChip('Archived', dense: false),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            if (p.url != null) FilledButton.icon(onPressed: () => openUrl(context, p.url), icon: const Icon(Icons.open_in_new, size: 18), label: const Text('Open link')),
            OutlinedButton.icon(onPressed: () => showProjectForm(context, ref, existing: p), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            OutlinedButton.icon(
              onPressed: () async {
                await repo.setProjectArchived(p.id, p.archivedAt == null);
                if (context.mounted) showToast(context, p.archivedAt == null ? 'Project archived' : 'Project restored');
              },
              icon: Icon(p.archivedAt == null ? Icons.archive_outlined : Icons.unarchive_outlined, size: 18),
              label: Text(p.archivedAt == null ? 'Archive' : 'Restore'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete project?', message: 'Removes "${p.name}" and its links. Linked records are kept.')) return;
                await repo.deleteProject(p.id);
                if (context.mounted) context.canPop() ? context.pop() : context.go(Routes.studio);
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          if (org != null || artist != null) ...[
            const SizedBox(height: 20),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (org != null) ActionChip(avatar: const Icon(Icons.business_outlined, size: 16), label: Text(org.name), onPressed: () => context.push(Routes.organization(org.id))),
              if (artist != null) ActionChip(avatar: const Icon(Icons.mic_none, size: 16), label: Text(artist.name), onPressed: () => context.push(Routes.artist(artist.id))),
            ]),
          ],
          const SizedBox(height: 20),
          Text('Connect everything behind this project', style: context.text.titleMedium),
          const SizedBox(height: 4),
          Text('Engine and store accounts, the repository, the email used to sign up, the subscriptions it costs, channels and documents.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton.icon(onPressed: () => quickLink(EntityType.serviceAccount), icon: const Icon(Icons.person_outline, size: 16), label: const Text('Link account')),
            OutlinedButton.icon(onPressed: () => quickLink(EntityType.emailIdentity), icon: const Icon(Icons.alternate_email, size: 16), label: const Text('Link email')),
            OutlinedButton.icon(onPressed: () => quickLink(EntityType.subscription), icon: const Icon(Icons.autorenew, size: 16), label: const Text('Link subscription')),
            OutlinedButton.icon(onPressed: () => quickLink(EntityType.youtubeChannel), icon: const Icon(Icons.play_circle_outline, size: 16), label: const Text('Link channel')),
            OutlinedButton.icon(onPressed: () => quickLink(EntityType.documentReference), icon: const Icon(Icons.description_outlined, size: 16), label: const Text('Link document')),
          ]),
          const SizedBox(height: 8),
          RelationsPanel(type: EntityType.project, id: p.id),
          if (p.notes != null) ...[
            const SizedBox(height: 20),
            Text('Notes', style: context.text.titleMedium),
            const SizedBox(height: 6),
            SelectableText(p.notes!),
          ],
        ],
      ),
    );
  }
}
