import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/json_list.dart';
import '../../data/catalog/catalog_service.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/platform_repository.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/toast.dart';

enum _Sort { name, category, recent }

/// Platform catalog. Browsing never changes My World; only "Add" does.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key, this.initialCategory});
  final String? initialCategory;
  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _search = TextEditingController();
  String? _category;
  bool _favoritesOnly = false;
  bool _inMyWorldOnly = false;
  _Sort _sort = _Sort.name;
  int _limit = 120;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final platformsAsync = ref.watch(allPlatformsProvider);
    final catalog = ref.watch(catalogServiceProvider);
    final categories = catalog.categories;
    return PageScaffold(
      title: 'Explore',
      subtitle: 'Discover ${platformsAsync.value?.length ?? 0} platforms. Nothing is added to My World until you choose Add.',
      actions: [
        OutlinedButton.icon(onPressed: () => _showCustomPlatformForm(context), icon: const Icon(Icons.add_box_outlined, size: 18), label: const Text('Custom platform')),
      ],
      children: [
        TextField(
          controller: _search,
          decoration: InputDecoration(
            hintText: 'Search platforms by name, category or website…',
            prefixIcon: const Icon(Icons.search, size: 18),
            suffixIcon: _search.text.isEmpty ? null : IconButton(icon: const Icon(Icons.clear, size: 16), onPressed: () => setState(() => _search.clear())),
          ),
          onChanged: (_) => setState(() => _limit = 120),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            ChoiceChip(label: const Text('All'), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
            const SizedBox(width: 6),
            for (final cat in categories) ...[
              ChoiceChip(label: Text(cat.label), selected: _category == cat.id, onSelected: (_) => setState(() => _category = _category == cat.id ? null : cat.id)),
              const SizedBox(width: 6),
            ],
          ]),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          FilterChip(label: const Text('Favorites'), avatar: const Icon(Icons.star_outline, size: 16), selected: _favoritesOnly, onSelected: (v) => setState(() => _favoritesOnly = v)),
          FilterChip(label: const Text('In My World'), avatar: const Icon(Icons.public, size: 16), selected: _inMyWorldOnly, onSelected: (v) => setState(() => _inMyWorldOnly = v)),
          const SizedBox(width: 6),
          Text('Sort', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
          SegmentedButton<_Sort>(
            segments: const [
              ButtonSegment(value: _Sort.name, label: Text('A–Z')),
              ButtonSegment(value: _Sort.category, label: Text('Category')),
              ButtonSegment(value: _Sort.recent, label: Text('Recently added')),
            ],
            selected: {_sort},
            onSelectionChanged: (s) => setState(() => _sort = s.first),
          ),
        ]),
        const SizedBox(height: 16),
        platformsAsync.when(
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
          error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Catalog unavailable', message: friendlyError(e)),
          data: (all) {
            var list = PlatformRepository.filter(all, query: _search.text, category: _category, onlyFavorites: _favoritesOnly, onlyMyWorld: _inMyWorldOnly);
            switch (_sort) {
              case _Sort.name:
                list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
              case _Sort.category:
                list.sort((a, b) {
                  final ca = decodeStringList(a.categories).firstOrNull ?? '';
                  final cb = decodeStringList(b.categories).firstOrNull ?? '';
                  final r = ca.compareTo(cb);
                  return r != 0 ? r : a.name.compareTo(b.name);
                });
              case _Sort.recent:
                list.sort((a, b) => (b.addedToMyWorldAt ?? DateTime(0)).compareTo(a.addedToMyWorldAt ?? DateTime(0)));
            }
            if (list.isEmpty) {
              return EmptyState(
                icon: Icons.search_off,
                title: 'No platforms match',
                message: 'Try another search or category, or add a custom platform that is not in the catalog.',
                actionLabel: 'Add custom platform',
                onAction: () => _showCustomPlatformForm(context),
              );
            }
            final visible = list.take(_limit).toList();
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('${list.length} platform${list.length == 1 ? '' : 's'}', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
              const SizedBox(height: 10),
              ResponsiveGrid(minTileWidth: 250, children: [for (final p in visible) _PlatformCard(platform: p, categoryLabel: catalog.categoryLabel)]),
              if (list.length > visible.length)
                Padding(padding: const EdgeInsets.only(top: 16), child: Center(child: OutlinedButton(onPressed: () => setState(() => _limit += 120), child: Text('Show more (${list.length - visible.length} remaining)')))),
            ]);
          },
        ),
      ],
    );
  }

  Future<void> _showCustomPlatformForm(BuildContext context, {Platform? existing}) async {
    final name = TextEditingController(text: existing?.name ?? '');
    final web = TextEditingController(text: existing?.website ?? '');
    final desc = TextEditingController(text: existing?.description ?? '');
    final cats = <String>{...?existing?.categoryIds};
    final all = ref.read(catalogServiceProvider).categories;
    final key = GlobalKey<FormState>();
    await showFormSheet<void>(context, title: existing == null ? 'Add custom platform' : 'Edit custom platform', builder: (ctx, close) {
      return StatefulBuilder(builder: (ctx, setState) {
        return Form(
          key: key,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('For services missing from the catalog. It appears in Explore and My World like any other platform.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)),
            const SizedBox(height: 12),
            AppTextField(controller: name, label: 'Name', autofocus: true, validator: (v) => requiredValidator(v, 'Name')),
            AppTextField(controller: web, label: 'Website', hint: 'https://…', validator: urlValidator, keyboardType: TextInputType.url),
            AppTextField(controller: desc, label: 'Description', maxLines: 2),
            FormSectionTitle('Categories'),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final c in all) FilterChip(label: Text(c.label), selected: cats.contains(c.id), onSelected: (v) => setState(() => v ? cats.add(c.id) : cats.remove(c.id))),
            ]),
            FormActions(onCancel: close, onSave: () async {
              if (!key.currentState!.validate()) return;
              if (cats.isEmpty) {
                showToast(ctx, 'Pick at least one category', error: true);
                return;
              }
              final repo = ref.read(platformRepositoryProvider);
              if (existing == null) {
                final p = await repo.createCustom(name: name.text, categories: cats.toList(), website: web.text, description: desc.text.trim());
                close();
                if (context.mounted) {
                  showToast(context, '${p.name} added to My World');
                  context.push(Routes.platform(p.id));
                }
              } else {
                await repo.updateCustom(existing.id, name: name.text, categories: cats.toList(), website: web.text, description: desc.text.trim());
                close();
              }
            }),
          ]),
        );
      });
    });
  }
}

class _PlatformCard extends ConsumerWidget {
  const _PlatformCard({required this.platform, required this.categoryLabel});
  final Platform platform;
  final String Function(String) categoryLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final repo = ref.read(platformRepositoryProvider);
    final cats = decodeStringList(platform.categories);
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => context.push(Routes.platform(platform.id)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PlatformLogo(platform: platform, size: 42),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(platform.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(cats.take(2).map(categoryLabel).join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          IconButton(
            tooltip: platform.isFavorite ? 'Remove favorite' : 'Favorite',
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            icon: Icon(platform.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded, color: platform.isFavorite ? c.warning : c.textMuted),
            onPressed: () => repo.setFavorite(platform.id, !platform.isFavorite),
          ),
        ]),
        const SizedBox(height: 10),
        Text(platform.description.isEmpty ? (platform.website ?? '') : platform.description, style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Row(children: [
          if (platform.isCustom) ...[Icon(Icons.edit_note, size: 14, color: c.textMuted), const SizedBox(width: 4), Text('Custom', style: context.text.labelSmall?.copyWith(color: c.textMuted)), const Spacer()] else const Spacer(),
          platform.inMyWorld
              ? OutlinedButton.icon(
                  onPressed: () => repo.setInMyWorld(platform.id, false),
                  icon: Icon(Icons.check, size: 16, color: c.success),
                  label: const Text('In My World'),
                  style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 10)),
                )
              : FilledButton.icon(
                  onPressed: () async {
                    await repo.setInMyWorld(platform.id, true);
                    if (context.mounted) showToast(context, '${platform.name} added to My World');
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 12)),
                ),
        ]),
      ]),
    );
  }
}
