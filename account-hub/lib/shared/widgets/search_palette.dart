import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../data/repositories/search_service.dart';
import '../../domain/enums.dart';
import 'relations_panel.dart';

/// Command-K style global search. Navigates to the selected record.
Future<void> showSearchPalette(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const _SearchPalette(),
  );
}

class _SearchPalette extends ConsumerStatefulWidget {
  const _SearchPalette();
  @override
  ConsumerState<_SearchPalette> createState() => _SearchPaletteState();
}

class _SearchPaletteState extends ConsumerState<_SearchPalette> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  List<SearchHit> _hits = const [];
  List<NavItem> _sections = const [];
  int _selected = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _sections = [for (final g in navGroups) ...g.items];
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () async {
      final hits = await ref.read(searchServiceProvider).search(q);
      final sections = [for (final g in navGroups) ...g.items].where((i) => q.trim().isEmpty || i.label.toLowerCase().contains(q.toLowerCase())).toList();
      if (!mounted) return;
      setState(() {
        _hits = hits;
        _sections = sections;
        _selected = 0;
      });
    });
  }

  int get _count => _sections.length + _hits.length;

  void _open(int index) {
    if (index < 0 || index >= _count) return;
    Navigator.of(context).pop();
    if (index < _sections.length) {
      context.go(_sections[index].path);
    } else {
      final h = _hits[index - _sections.length];
      if (h.type == EntityType.serviceAccount) {
        ref.read(accountRepositoryProvider).touchAccessed(h.id);
      }
      context.push(routeForEntity(h.type, h.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.fromLTRB(16, context.isCompact ? 24 : 80, 16, 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 520),
        child: Focus(
          onKeyEvent: (node, event) {
            if (event is! KeyDownEvent) return KeyEventResult.ignored;
            final k = event.logicalKey;
            if (k == LogicalKeyboardKey.arrowDown) { setState(() => _selected = (_selected + 1).clamp(0, _count - 1)); return KeyEventResult.handled; }
            if (k == LogicalKeyboardKey.arrowUp) { setState(() => _selected = (_selected - 1).clamp(0, _count - 1)); return KeyEventResult.handled; }
            if (k == LogicalKeyboardKey.enter) { _open(_selected); return KeyEventResult.handled; }
            if (k == LogicalKeyboardKey.escape) { Navigator.of(context).pop(); return KeyEventResult.handled; }
            return KeyEventResult.ignored;
          },
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: TextField(
                controller: _ctrl,
                focusNode: _focus,
                autofocus: true,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: 'Search platforms, accounts, emails, channels, projects, subscriptions, tags…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Padding(padding: const EdgeInsets.only(right: 10), child: Align(widthFactor: 1, child: Text('esc', style: TextStyle(color: c.textMuted, fontSize: 11)))),
                ),
              ),
            ),
            const Divider(),
            Flexible(
              child: _count == 0
                  ? Padding(padding: const EdgeInsets.all(28), child: Text('No matches. Secrets in the Vault are never searchable.', style: TextStyle(color: c.textMuted)))
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      itemCount: _count,
                      itemBuilder: (_, i) {
                        final selected = i == _selected;
                        if (i < _sections.length) {
                          final s = _sections[i];
                          return _row(selected, Icon(s.icon, size: 18, color: s.color ?? c.textMuted), s.label, 'Section', () => _open(i), showHeader: i == 0 ? 'Sections' : null);
                        }
                        final h = _hits[i - _sections.length];
                        return _row(selected, Icon(iconForEntity(h.type), size: 18, color: c.accent), h.title, h.subtitle ?? h.type.label, () => _open(i), showHeader: i == _sections.length ? 'Records' : null);
                      },
                    ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _row(bool selected, Widget icon, String title, String subtitle, VoidCallback onTap, {String? showHeader}) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (showHeader != null) Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 4), child: Text(showHeader.toUpperCase(), style: context.text.labelSmall?.copyWith(color: c.textMuted, letterSpacing: 1))),
      Material(
        color: selected ? c.accent.withValues(alpha: 0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          dense: true,
          leading: icon,
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: c.textMuted)),
          trailing: selected ? Icon(Icons.keyboard_return, size: 16, color: c.textMuted) : null,
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ]);
  }
}
