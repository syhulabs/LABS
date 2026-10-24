import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
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
import '../studio/project_form.dart';
import '../youtube/channel_form.dart';
import 'artist_form.dart';
import 'music_providers.dart';

class ArtistDetailScreen extends ConsumerWidget {
  const ArtistDetailScreen({super.key, required this.artistId});
  final String artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final a = ref.watch(artistByIdProvider(artistId)).value;
    if (a == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.music))),
        body: const Center(child: Text('Artist not found')),
      );
    }
    final label = (ref.watch(organizationsProvider).value ?? const <Organization>[]).where((o) => o.id == a.labelId).firstOrNull;
    final email = (ref.watch(emailsProvider).value ?? const <EmailIdentity>[]).where((e) => e.id == a.primaryEmailId).firstOrNull;
    final channels = (ref.watch(channelsProvider).value ?? const []).where((v) => v.channel.artistId == a.id).toList();
    final projects = (ref.watch(projectsProvider).value ?? const <Project>[]).where((p) => p.artistId == a.id).toList();
    final repo = ref.read(projectRepositoryProvider);
    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(a.name), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.music))),
      body: PageScaffold(
        title: a.name,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          MonogramAvatar(text: a.name, seed: a.id, size: 72, icon: Icons.mic_none),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.name, style: context.text.headlineMedium),
            Text([if (a.genre != null) a.genre!, label?.name ?? 'Independent'].join(' · '), style: context.text.bodyMedium?.copyWith(color: c.textMuted)),
            if (a.bio != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(a.bio!, style: context.text.bodyMedium)),
            if (a.archivedAt != null) const Padding(padding: EdgeInsets.only(top: 8), child: StatusChip('Archived', dense: false)),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            OutlinedButton.icon(onPressed: () => showArtistForm(context, ref, existing: a), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            OutlinedButton.icon(onPressed: () => showProjectForm(context, ref, presetArtistId: a.id), icon: const Icon(Icons.album_outlined, size: 18), label: const Text('New release / project')),
            OutlinedButton.icon(onPressed: () => showChannelForm(context, ref, presetOwnerEmailId: a.primaryEmailId), icon: const Icon(Icons.play_circle_outline, size: 18), label: const Text('New channel')),
            OutlinedButton.icon(
              onPressed: () async {
                await repo.setArtistArchived(a.id, a.archivedAt == null);
                if (context.mounted) showToast(context, a.archivedAt == null ? 'Artist archived' : 'Artist restored');
              },
              icon: Icon(a.archivedAt == null ? Icons.archive_outlined : Icons.unarchive_outlined, size: 18),
              label: Text(a.archivedAt == null ? 'Archive' : 'Restore'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete artist?', message: 'Removes "${a.name}". Projects and channels are kept but detached.')) return;
                await repo.deleteArtist(a.id);
                if (context.mounted) context.canPop() ? context.pop() : context.go(Routes.music);
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          const SizedBox(height: 20),
          if (label != null || email != null)
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(children: [
                if (label != null) ListTile(leading: const Icon(Icons.album_outlined), title: Text(label.name), subtitle: const Text('Record label'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(Routes.organization(label.id))),
                if (email != null) ListTile(leading: MonogramAvatar(text: email.address, seed: email.id, size: 36), title: Text(email.address), subtitle: const Text('Primary email'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(Routes.email(email.id))),
              ]),
            ),
          const SizedBox(height: 16),
          SectionHeader(title: 'Releases & projects', subtitle: '${projects.length}'),
          if (projects.isEmpty)
            Text('No projects attached yet.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
          else
            Wrap(spacing: 8, runSpacing: 8, children: [for (final p in projects) ActionChip(avatar: const Icon(Icons.folder_outlined, size: 16), label: Text('${p.name} · ${statusLabel(p.status)}'), onPressed: () => context.push(Routes.project(p.id)))]),
          const SizedBox(height: 18),
          SectionHeader(title: 'YouTube channels', subtitle: '${channels.length}'),
          if (channels.isEmpty)
            Text('No channels attached. Set the artist on a channel in YouTube → Edit.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
          else
            Wrap(spacing: 8, runSpacing: 8, children: [for (final v in channels) ActionChip(avatar: const Icon(Icons.play_circle_outline, size: 16), label: Text(v.channel.name), onPressed: () => context.push(Routes.channel(v.channel.id)))]),
          const SizedBox(height: 20),
          RelationsPanel(type: EntityType.artist, id: a.id),
          if (a.notes != null) ...[
            const SizedBox(height: 20),
            Text('Notes', style: context.text.titleMedium),
            const SizedBox(height: 6),
            SelectableText(a.notes!),
          ],
        ],
      ),
    );
  }
}
