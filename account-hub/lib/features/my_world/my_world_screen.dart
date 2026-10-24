import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/json_list.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/account_repository.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/toast.dart';
import '../accounts/account_form.dart';

/// Only platforms the user explicitly selected (or added accounts on).
/// Supports category filtering, drag-to-reorder and quick actions.
class MyWorldScreen extends ConsumerStatefulWidget {
  const MyWorldScreen({super.key});
  @override
  ConsumerState<MyWorldScreen> createState() => _MyWorldScreenState();
}

class _MyWorldScreenState extends ConsumerState<MyWorldScreen> {
  String? _category;
  bool _reorder = false;
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final platforms = ref.watch(myWorldProvider).value ?? const <Platform>[];
    final accounts = ref.watch(accountsProvider).value ?? const <AccountView>[];
    final catalog = ref.watch(catalogServiceProvider);
    final byPlatform = <String, List<AccountView>>{};
    for (final a in accounts) {
      byPlatform.putIfAbsent(a.platform.id, () => []).add(a);
    }
    final usedCategories = <String>{};
    for (final p in platforms) {
      usedCategories.addAll(decodeStringList(p.categories));
    }
    final catList = catalog.categories.where((cat) => usedCategories.contains(cat.id)).toList();
    final filtered = platforms.where((p) {
      if (_category != null && !decodeStringList(p.categories).contains(_category)) return false;
      if (_q.isEmpty) return true;
      return p.name.toLowerCase().contains(_q.toLowerCase());
    }).toList();

    return PageScaffold(
      title: 'My World',
      subtitle: platforms.isEmpty ? 'Your personally selected services will live here.' : '${platforms.length} platforms · ${accounts.length} accounts',
      actions: [
        if (platforms.length > 1)
          OutlinedButton.icon(onPressed: () => setState(() => _reorder = !_reorder), icon: Icon(_reorder ? Icons.check : Icons.swap_vert, size: 18), label: Text(_reorder ? 'Done' : 'Reorder')),
        OutlinedButton.icon(onPressed: () => context.go(Routes.explore), icon: const Icon(Icons.explore_outlined, size: 18), label: const Text('Explore catalog')),
        FilledButton.icon(
          onPressed: () async {
            final p = await showPlatformPicker(context, ref, title: 'Add a platform to My World');
            if (p == null) return;
            await ref.read(platformRepositoryProvider).setInMyWorld(p.id, true);
            if (context.mounted) showToast(context, '${p.name} added to My World');
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add platform'),
        ),
      ],
      children: [
        if (platforms.isEmpty)
          EmptyState(
            icon: Icons.public_rounded,
            title: 'Build your world',
            message: 'Pick the platforms you actually use from the catalog. Each one can hold several accounts, each with its own email identity.',
            actionLabel: 'Browse Explore',
            onAction: () => context.go(Routes.explore),
            secondaryLabel: 'Quick add',
            onSecondary: () async {
              final p = await showPlatformPicker(context, ref);
              if (p != null) await ref.read(platformRepositoryProvider).setInMyWorld(p.id, true);
            },
          )
        else ...[
          Row(children: [
            Expanded(child: TextField(decoration: const InputDecoration(hintText: 'Filter My World…', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v))),
          ]),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              ChoiceChip(label: const Text('All'), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
              const SizedBox(width: 6),
              for (final cat in catList) ...[
                ChoiceChip(label: Text(cat.label), selected: _category == cat.id, onSelected: (_) => setState(() => _category = _category == cat.id ? null : cat.id)),
                const SizedBox(width: 6),
              ],
            ]),
          ),
          const SizedBox(height: 16),
          if (_reorder)
            _ReorderList(platforms: platforms, onReorder: (ids) => ref.read(platformRepositoryProvider).saveOrder(ids))
          else if (filtered.isEmpty)
            EmptyState(icon: Icons.filter_alt_off, title: 'No platforms here', message: 'Nothing in My World matches this filter.', compact: true)
          else
            ResponsiveGrid(
              minTileWidth: 230,
              children: [for (final p in filtered) _MyWorldCard(platform: p, accounts: byPlatform[p.id] ?? const [])],
            ),
          const SizedBox(height: 24),
          Text('Tip: drag cards in Reorder mode to arrange your favorites first. Right-click (or long-press) a card for quick actions.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
        ],
      ],
    );
  }
}

class _MyWorldCard extends ConsumerWidget {
  const _MyWorldCard({required this.platform, required this.accounts});
  final Platform platform;
  final List<AccountView> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final repo = ref.read(platformRepositoryProvider);
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => context.push(Routes.platform(platform.id)),
      onLongPress: () => _menu(context, ref),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          PlatformLogo(platform: platform, size: 46),
          const Spacer(),
          if (platform.isFavorite) Icon(Icons.star_rounded, size: 16, color: c.warning),
          PopupMenuButton<String>(
            iconSize: 18,
            tooltip: 'Actions',
            onSelected: (v) async {
              switch (v) {
                case 'add':
                  await showAccountForm(context, ref, platform: platform);
                case 'fav':
                  await repo.setFavorite(platform.id, !platform.isFavorite);
                case 'remove':
                  await repo.setInMyWorld(platform.id, false);
                  if (context.mounted) showToast(context, '${platform.name} removed from My World (accounts kept)');
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'add', child: ListTile(dense: true, leading: Icon(Icons.person_add_alt, size: 18), title: Text('Add account'))),
              PopupMenuItem(value: 'fav', child: ListTile(dense: true, leading: Icon(platform.isFavorite ? Icons.star_outline : Icons.star, size: 18), title: Text(platform.isFavorite ? 'Remove favorite' : 'Favorite'))),
              const PopupMenuItem(value: 'remove', child: ListTile(dense: true, leading: Icon(Icons.remove_circle_outline, size: 18), title: Text('Remove from My World'))),
            ],
          ),
        ]),
        const SizedBox(height: 10),
        Text(platform.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(accounts.isEmpty ? 'No accounts yet' : '${accounts.length} account${accounts.length == 1 ? '' : 's'}', style: context.text.bodySmall?.copyWith(color: accounts.isEmpty ? c.textMuted : c.accent)),
        if (accounts.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(accounts.map((a) => a.account.accountName).join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ]),
    );
  }

  void _menu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.person_add_alt), title: const Text('Add account'), onTap: () { Navigator.pop(context); showAccountForm(context, ref, platform: platform); }),
          ListTile(leading: const Icon(Icons.remove_circle_outline), title: const Text('Remove from My World'), onTap: () { Navigator.pop(context); ref.read(platformRepositoryProvider).setInMyWorld(platform.id, false); }),
        ]),
      ),
    );
  }
}

class _ReorderList extends StatefulWidget {
  const _ReorderList({required this.platforms, required this.onReorder});
  final List<Platform> platforms;
  final ValueChanged<List<String>> onReorder;
  @override
  State<_ReorderList> createState() => _ReorderListState();
}

class _ReorderListState extends State<_ReorderList> {
  late List<Platform> _items = List.of(widget.platforms);

  @override
  void didUpdateWidget(covariant _ReorderList old) {
    super.didUpdateWidget(old);
    if (old.platforms.length != widget.platforms.length) _items = List.of(widget.platforms);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: true,
      itemCount: _items.length,
      onReorderItem: (o, n) {
        setState(() => _items.insert(n, _items.removeAt(o)));
        widget.onReorder(_items.map((p) => p.id).toList());
      },
      itemBuilder: (_, i) => ListTile(
        key: ValueKey(_items[i].id),
        leading: PlatformLogo(platform: _items[i], size: 34),
        title: Text(_items[i].name),
        trailing: const Icon(Icons.drag_handle),
      ),
    );
  }
}
