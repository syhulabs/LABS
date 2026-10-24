import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'organization_form.dart';
import 'project_form.dart';
import 'studio_providers.dart';

/// Studio & Projects: creative projects, studios/businesses and documents.
class StudioScreen extends ConsumerStatefulWidget {
  const StudioScreen({super.key});
  @override
  ConsumerState<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends ConsumerState<StudioScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  String _q = '';
  ProjectKind? _kind;
  ProjectStatus? _status;
  Classification? _classification;
  bool _showArchived = false;

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final projects = (_showArchived ? ref.watch(allProjectsProvider) : ref.watch(projectsProvider)).value ?? const <Project>[];
    final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
    final docs = ref.watch(documentsProvider).value ?? const <DocumentReference>[];
    final live = projects.where((p) => p.archivedAt == null).toList();
    return PageScaffold(
      title: 'Studio & Projects',
      subtitle: 'Apps, games, songs, releases, stories and IP, linked to the accounts, emails and subscriptions behind them.',
      actions: [
        OutlinedButton.icon(onPressed: () => showOrganizationForm(context, ref, presetKind: OrganizationKind.studio), icon: const Icon(Icons.business_outlined, size: 18), label: const Text('Add studio / business')),
        FilledButton.icon(onPressed: () => showProjectForm(context, ref), icon: const Icon(Icons.add, size: 18), label: const Text('Add project')),
      ],
      children: [
        ResponsiveGrid(minTileWidth: 170, children: [
          StatCard(label: 'In progress', value: '${live.where((p) => p.status == ProjectStatus.inProgress.name).length}', icon: Icons.construction_outlined, color: c.accentBlue),
          StatCard(label: 'Released', value: '${live.where((p) => p.status == ProjectStatus.released.name).length}', icon: Icons.rocket_launch_outlined, color: c.success),
          StatCard(label: 'Studios & businesses', value: '${orgs.where((o) => o.kind != OrganizationKind.recordLabel.name).length}', icon: Icons.business_outlined, color: c.warning),
          StatCard(label: 'Documents', value: '${docs.length}', icon: Icons.description_outlined, color: c.accent),
        ]),
        const SizedBox(height: 18),
        TabBar(controller: _tabs, isScrollable: true, tabAlignment: TabAlignment.start, tabs: const [Tab(text: 'Projects'), Tab(text: 'Studios & Businesses'), Tab(text: 'Documents')]),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _tabs,
          builder: (_, _) => switch (_tabs.index) {
            0 => _projectsTab(projects, orgs),
            1 => _organizationsTab(orgs),
            _ => _documentsTab(docs),
          },
        ),
      ],
    );
  }

  Widget _projectsTab(List<Project> projects, List<Organization> orgs) {
    final c = context.colors;
    final artists = ref.watch(artistsProvider).value ?? const <Artist>[];
    final q = _q.trim().toLowerCase();
    final filtered = projects.where((p) {
      if (_kind != null && p.kind != _kind!.name) return false;
      if (_status != null && p.status != _status!.name) return false;
      if (_classification != null && p.classification != _classification!.name) return false;
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) || (p.description ?? '').toLowerCase().contains(q);
    }).toList();
    if (projects.isEmpty) {
      return AppCard(
        child: EmptyState(
          icon: Icons.folder_open,
          title: 'No projects yet',
          message: 'Create a project for each app, game, song, release, comic or story. Then link the GitHub repo, engine account, Steamworks page, email and subscriptions that belong to it.',
          actionLabel: 'Add project',
          onAction: () => showProjectForm(context, ref),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
        SizedBox(width: 240, child: TextField(decoration: const InputDecoration(hintText: 'Search projects…', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v))),
        FilterChip(label: const Text('Show archived'), selected: _showArchived, onSelected: (v) => setState(() => _showArchived = v)),
      ]),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          ChoiceChip(label: const Text('All kinds'), selected: _kind == null, onSelected: (_) => setState(() => _kind = null)),
          const SizedBox(width: 6),
          for (final k in ProjectKind.values) ...[ChoiceChip(label: Text(k.label), selected: _kind == k, onSelected: (_) => setState(() => _kind = _kind == k ? null : k)), const SizedBox(width: 6)],
        ]),
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 6, runSpacing: 6, children: [
        for (final s in ProjectStatus.values) FilterChip(label: Text(s.label), selected: _status == s, onSelected: (_) => setState(() => _status = _status == s ? null : s)),
        const SizedBox(width: 10),
        for (final cl in Classification.values) FilterChip(avatar: Icon(cl == Classification.business ? Icons.business_center_outlined : Icons.person_outline, size: 14), label: Text(cl.label), selected: _classification == cl, onSelected: (_) => setState(() => _classification = _classification == cl ? null : cl)),
      ]),
      const SizedBox(height: 16),
      if (filtered.isEmpty)
        const EmptyState(compact: true, icon: Icons.filter_alt_off, title: 'No projects match', message: 'Try another search or clear the filters.')
      else
        ResponsiveGrid(minTileWidth: 280, children: [
          for (final p in filtered)
            _ProjectCard(project: p, orgName: orgs.where((o) => o.id == p.organizationId).firstOrNull?.name, artistName: artists.where((a) => a.id == p.artistId).firstOrNull?.name),
        ]),
      const SizedBox(height: 12),
      Text('Open a project to link accounts, emails, subscriptions, channels and documents to it.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
    ]);
  }

  Widget _organizationsTab(List<Organization> orgs) {
    final studios = orgs.where((o) => o.kind == OrganizationKind.studio.name).toList();
    final businesses = orgs.where((o) => o.kind == OrganizationKind.business.name).toList();
    if (studios.isEmpty && businesses.isEmpty) {
      return AppCard(
        child: EmptyState(
          icon: Icons.business_outlined,
          title: 'No studios or businesses yet',
          message: 'Add the studio identities and businesses behind your work. Projects, channels, bank accounts and artists can then be attached to them.',
          actionLabel: 'Add studio',
          onAction: () => showOrganizationForm(context, ref, presetKind: OrganizationKind.studio),
          secondaryLabel: 'Add business',
          onSecondary: () => showOrganizationForm(context, ref, presetKind: OrganizationKind.business),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(title: 'Studios', subtitle: '${studios.length}', actions: [TextButton.icon(onPressed: () => showOrganizationForm(context, ref, presetKind: OrganizationKind.studio), icon: const Icon(Icons.add, size: 16), label: const Text('Studio'))]),
      if (studios.isEmpty) Padding(padding: const EdgeInsets.only(bottom: 16), child: Text('No studios yet.', style: context.text.bodySmall?.copyWith(color: context.colors.textMuted))),
      for (final o in studios) Padding(padding: const EdgeInsets.only(bottom: 8), child: OrganizationTile(organization: o)),
      const SizedBox(height: 12),
      SectionHeader(title: 'Businesses', subtitle: '${businesses.length}', actions: [TextButton.icon(onPressed: () => showOrganizationForm(context, ref, presetKind: OrganizationKind.business), icon: const Icon(Icons.add, size: 16), label: const Text('Business'))]),
      if (businesses.isEmpty) Text('No businesses yet.', style: context.text.bodySmall?.copyWith(color: context.colors.textMuted)),
      for (final o in businesses) Padding(padding: const EdgeInsets.only(bottom: 8), child: OrganizationTile(organization: o)),
    ]);
  }

  Widget _documentsTab(List<DocumentReference> docs) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(title: 'Documents', subtitle: 'References to contracts, invoices, scripts and brand assets (links or local paths; the files stay where they are).', actions: [
        TextButton.icon(onPressed: () => showDocumentForm(context, ref), icon: const Icon(Icons.add, size: 16), label: const Text('Document')),
      ]),
      if (docs.isEmpty)
        AppCard(child: EmptyState(compact: true, icon: Icons.description_outlined, title: 'No documents yet', message: 'Add a link or file path and attach it to projects and accounts.', actionLabel: 'Add document', onAction: () => showDocumentForm(context, ref)))
      else
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: [
            for (final d in docs)
              ListTile(
                leading: Icon(_isWeb(d.locator) ? Icons.link : Icons.insert_drive_file_outlined, color: c.accent),
                title: Text(d.title),
                subtitle: Text([if (d.kind != null) d.kind!, d.locator].join(' · '), maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    tooltip: _isWeb(d.locator) ? 'Open link' : 'Copy path',
                    icon: Icon(_isWeb(d.locator) ? Icons.open_in_new : Icons.copy, size: 18),
                    onPressed: () async {
                      if (_isWeb(d.locator)) {
                        await openUrl(context, d.locator);
                      } else {
                        await Clipboard.setData(ClipboardData(text: d.locator));
                        if (mounted) showToast(context, 'Path copied');
                      }
                    },
                  ),
                  IconButton(tooltip: 'Edit', icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => showDocumentForm(context, ref, existing: d)),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: () async {
                      if (await confirmDestructive(context, title: 'Delete document reference?', message: 'Only the reference is removed; the file or page itself is untouched.')) {
                        await ref.read(projectRepositoryProvider).deleteDocument(d.id);
                      }
                    },
                  ),
                ]),
              ),
          ]),
        ),
    ]);
  }

  static bool _isWeb(String s) => s.startsWith('http://') || s.startsWith('https://');
}

class _ProjectCard extends ConsumerWidget {
  const _ProjectCard({required this.project, this.orgName, this.artistName});
  final Project project;
  final String? orgName;
  final String? artistName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final p = project;
    final kind = enumFromName(ProjectKind.values, p.kind, ProjectKind.other);
    final repo = ref.read(projectRepositoryProvider);
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => context.push(Routes.project(p.id)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          MonogramAvatar(text: p.name, seed: p.id, size: 40, icon: _iconForKind(kind)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text([kind.label, ?orgName, ?artistName].join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          PopupMenuButton<String>(
            tooltip: 'Actions',
            iconSize: 18,
            onSelected: (v) async {
              switch (v) {
                case 'edit':
                  await showProjectForm(context, ref, existing: p);
                case 'archive':
                  await repo.setProjectArchived(p.id, true);
                case 'restore':
                  await repo.setProjectArchived(p.id, false);
                case 'delete':
                  if (await confirmDestructive(context, title: 'Delete project?', message: 'Removes "${p.name}" and its links. Linked accounts, emails and subscriptions are kept.')) {
                    await repo.deleteProject(p.id);
                  }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
              if (p.archivedAt == null)
                const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive')))
              else
                const PopupMenuItem(value: 'restore', child: ListTile(dense: true, leading: Icon(Icons.unarchive_outlined, size: 18), title: Text('Restore'))),
              const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
            ],
          ),
        ]),
        if (p.description != null) ...[const SizedBox(height: 10), Text(p.description!, style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis)],
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          StatusChip(statusLabel(p.status), color: statusColor(context, p.status)),
          ClassificationChip(p.classification),
          if (p.archivedAt != null) const StatusChip('Archived'),
        ]),
      ]),
    );
  }
}

IconData _iconForKind(ProjectKind k) => switch (k) {
      ProjectKind.app => Icons.phone_android_outlined,
      ProjectKind.game => Icons.sports_esports_outlined,
      ProjectKind.website => Icons.language,
      ProjectKind.song => Icons.music_note_outlined,
      ProjectKind.release => Icons.album_outlined,
      ProjectKind.story => Icons.auto_stories_outlined,
      ProjectKind.comic => Icons.brush_outlined,
      ProjectKind.video => Icons.movie_outlined,
      ProjectKind.intellectualProperty => Icons.copyright_outlined,
      ProjectKind.other => Icons.folder_outlined,
    };

IconData iconForProjectKind(ProjectKind k) => _iconForKind(k);

/// Row for a business / studio / label.
class OrganizationTile extends ConsumerWidget {
  const OrganizationTile({super.key, required this.organization});
  final Organization organization;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final o = organization;
    final kind = enumFromName(OrganizationKind.values, o.kind, OrganizationKind.business);
    final projects = (ref.watch(projectsProvider).value ?? const <Project>[]).where((p) => p.organizationId == o.id).length;
    final repo = ref.read(projectRepositoryProvider);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => context.push(Routes.organization(o.id)),
      child: Row(children: [
        MonogramAvatar(text: o.name, seed: o.id, size: 40, icon: kind == OrganizationKind.recordLabel ? Icons.album_outlined : kind == OrganizationKind.studio ? Icons.movie_creation_outlined : Icons.business_outlined),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(o.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text([kind.label, '$projects project${projects == 1 ? '' : 's'}', if (o.website != null) o.website!].join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        PopupMenuButton<String>(
          tooltip: 'Actions',
          onSelected: (v) async {
            switch (v) {
              case 'open':
                await openUrl(context, o.website);
              case 'edit':
                await showOrganizationForm(context, ref, existing: o);
              case 'archive':
                await repo.setOrganizationArchived(o.id, true);
              case 'delete':
                if (await confirmDestructive(context, title: 'Delete ${kind.label.toLowerCase()}?', message: 'Removes "${o.name}". Projects, artists and channels are kept but detached.')) {
                  await repo.deleteOrganization(o.id);
                }
            }
          },
          itemBuilder: (_) => [
            if (o.website != null) const PopupMenuItem(value: 'open', child: ListTile(dense: true, leading: Icon(Icons.open_in_new, size: 18), title: Text('Open website'))),
            const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
            const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive'))),
            const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
          ],
        ),
      ]),
    );
  }
}
