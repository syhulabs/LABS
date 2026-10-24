import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../data/repositories/settings_repository.dart';
import 'search_palette.dart';

/// Adaptive chrome: grouped collapsible sidebar on wide windows, bottom
/// navigation + drawer on phones. Hosts the ⌘K / Ctrl+K shortcut.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _railCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final compact = context.isCompact;
    final shortcuts = <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () => showSearchPalette(context),
      const SingleActivator(LogicalKeyboardKey.keyK, control: true): () => showSearchPalette(context),
      const SingleActivator(LogicalKeyboardKey.comma, meta: true): () => context.go(Routes.settings),
      const SingleActivator(LogicalKeyboardKey.digit1, meta: true): () => context.go(Routes.home),
      const SingleActivator(LogicalKeyboardKey.digit2, meta: true): () => context.go(Routes.myWorld),
      const SingleActivator(LogicalKeyboardKey.digit3, meta: true): () => context.go(Routes.explore),
    };
    final body = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => ref.read(appLockProvider).touch(),
      child: CallbackShortcuts(
        bindings: shortcuts,
        child: Focus(
          autofocus: true,
          onKeyEvent: (_, e) {
            if (e is KeyDownEvent) ref.read(appLockProvider).touch();
            return KeyEventResult.ignored;
          },
          child: compact ? _compactLayout(location) : _wideLayout(location),
        ),
      ),
    );
    return body;
  }

  Widget _wideLayout(String location) {
    final c = context.colors;
    return Scaffold(
      body: Row(children: [
        _Sidebar(location: location, collapsed: _railCollapsed, onToggle: () => setState(() => _railCollapsed = !_railCollapsed)),
        VerticalDivider(width: 1, color: c.border),
        Expanded(
          child: Column(children: [
            _TopBar(location: location),
            Expanded(child: widget.child),
          ]),
        ),
      ]),
    );
  }

  Widget _compactLayout(String location) {
    final current = navItemForPath(location);
    const tabs = [Routes.home, Routes.myWorld, Routes.explore, Routes.subscriptions];
    final idx = tabs.indexWhere((t) => location == t || location.startsWith('$t/'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.sidebar,
        title: Text(current?.label ?? 'SYHU Account Hub'),
        actions: [IconButton(tooltip: 'Search', icon: const Icon(Icons.search), onPressed: () => showSearchPalette(context))],
      ),
      drawer: Drawer(backgroundColor: context.colors.sidebar, child: SafeArea(child: _Sidebar(location: location, collapsed: false, onToggle: null, inDrawer: true))),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx < 0 ? 4 : idx,
        onDestinationSelected: (i) {
          if (i == 4) {
            Scaffold.of(context).openDrawer();
          } else {
            context.go(tabs[i]);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.public_outlined), selectedIcon: Icon(Icons.public_rounded), label: 'My World'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore_rounded), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.autorenew_outlined), selectedIcon: Icon(Icons.autorenew_rounded), label: 'Subs'),
          NavigationDestination(icon: Icon(Icons.menu_rounded), label: 'More'),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.location});
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final item = navItemForPath(location);
    final lock = ref.watch(appLockProvider);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: c.background, border: Border(bottom: BorderSide(color: c.border))),
      child: Row(children: [
        if (item != null) ...[Icon(item.icon, size: 18, color: item.color ?? c.textMuted), const SizedBox(width: 8), Text(item.label, style: context.text.titleMedium)],
        const Spacer(),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => showSearchPalette(context),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: BorderRadius.circular(10), border: Border.all(color: c.border)),
              child: Row(children: [
                Icon(Icons.search, size: 16, color: c.textMuted),
                const SizedBox(width: 8),
                Expanded(child: Text('Search platforms, accounts, or anything…', style: TextStyle(color: c.textMuted, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 12),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(5), border: Border.all(color: c.border)), child: Text('⌘K', style: TextStyle(color: c.textMuted, fontSize: 11))),
              ]),
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (lock.enabled) IconButton(tooltip: 'Lock now', icon: const Icon(Icons.lock_outline), onPressed: lock.lock),
        IconButton(tooltip: 'Settings', icon: const Icon(Icons.settings_outlined), onPressed: () => context.go(Routes.settings)),
      ]),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.location, required this.collapsed, required this.onToggle, this.inDrawer = false});
  final String location;
  final bool collapsed;
  final VoidCallback? onToggle;
  final bool inDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final collapsedGroups = settings.sidebarCollapsed;
    final name = settings.displayName;
    final width = collapsed ? 68.0 : 248.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: inDrawer ? null : width,
      color: c.sidebar,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: EdgeInsets.fromLTRB(collapsed ? 12 : 18, 18, 10, 10),
          child: Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), gradient: LinearGradient(colors: [c.accent, c.accentPink])),
              child: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
            ),
            if (!collapsed) ...[
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('SYHU', style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 1)),
                Text('Account Hub', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
              ])),
            ],
            if (onToggle != null && !collapsed) IconButton(tooltip: 'Collapse sidebar', iconSize: 18, icon: const Icon(Icons.keyboard_double_arrow_left), onPressed: onToggle),
          ]),
        ),
        if (onToggle != null && collapsed) IconButton(tooltip: 'Expand sidebar', iconSize: 18, icon: const Icon(Icons.keyboard_double_arrow_right), onPressed: onToggle),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            children: [
              for (final g in navGroups) ...[
                if (!collapsed && g.id != 'overview')
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      final next = {...collapsedGroups};
                      if (!next.remove(g.id)) next.add(g.id);
                      ref.read(settingsRepositoryProvider).set(SettingsRepository.kSidebarCollapsed, next.toList());
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 14, 6, 6),
                      child: Row(children: [
                        Expanded(child: Text(g.label.toUpperCase(), style: context.text.labelSmall?.copyWith(color: c.textMuted, letterSpacing: 1.2, fontWeight: FontWeight.w700))),
                        Icon(collapsedGroups.contains(g.id) ? Icons.chevron_right : Icons.expand_more, size: 14, color: c.textMuted),
                      ]),
                    ),
                  ),
                if (collapsed && g.id != 'overview') Divider(height: 12, indent: 12, endIndent: 12, color: c.border),
                if (collapsed || !collapsedGroups.contains(g.id) || g.id == 'overview')
                  for (final i in g.items) _NavTile(item: i, selected: location == i.path || location.startsWith('${i.path}/'), collapsed: collapsed, onTap: () {
                    context.go(i.path);
                    if (inDrawer) Navigator.of(context).maybePop();
                  }),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
        Divider(color: c.border),
        InkWell(
          onTap: () => context.go(Routes.settings),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 14 : 16, vertical: 12),
            child: Row(children: [
              CircleAvatar(radius: 16, backgroundColor: c.accent.withValues(alpha: 0.25), child: Text((name ?? 'S').trim().isEmpty ? 'S' : (name ?? 'S').trim()[0].toUpperCase(), style: TextStyle(color: c.text, fontWeight: FontWeight.w700))),
              if (!collapsed) ...[
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name?.trim().isNotEmpty == true ? name!.trim() : 'Your workspace', style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('Local · private', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
                ])),
              ],
            ]),
          ),
        ),
      ]),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.item, required this.selected, required this.collapsed, required this.onTap});
  final NavItem item;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tile = Material(
      color: selected ? c.accent.withValues(alpha: 0.2) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 10, vertical: 9),
          child: Row(mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
            Icon(item.icon, size: 18, color: selected ? c.text : (item.color ?? c.textMuted)),
            if (!collapsed) ...[const SizedBox(width: 10), Expanded(child: Text(item.label, style: TextStyle(color: selected ? c.text : c.text.withValues(alpha: 0.85), fontWeight: selected ? FontWeight.w600 : FontWeight.w500, fontSize: 13.5), maxLines: 1, overflow: TextOverflow.ellipsis))],
          ]),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Semantics(selected: selected, button: true, label: item.label, child: collapsed ? Tooltip(message: item.label, child: tile) : tile),
    );
  }
}
