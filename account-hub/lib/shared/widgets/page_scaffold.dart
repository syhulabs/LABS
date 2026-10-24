import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Standard section page: title row with actions, then scrollable content
/// constrained to a comfortable reading width.
class PageScaffold extends StatelessWidget {
  const PageScaffold({super.key, required this.title, this.subtitle, this.actions = const [], required this.children, this.maxWidth = 1280, this.header});
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> children;
  final double maxWidth;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompact;
    final pad = compact ? 16.0 : 28.0;
    return Scrollbar(
      child: CustomScrollView(
        primary: true,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, compact ? 12 : 24, pad, 0),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    header ??
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 10,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(title, style: compact ? context.text.headlineSmall : context.text.headlineMedium),
                              if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(subtitle!, style: context.text.bodyMedium?.copyWith(color: context.colors.textMuted))),
                            ]),
                            if (actions.isNotEmpty) Wrap(spacing: 8, runSpacing: 8, children: actions),
                          ],
                        ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, 0, pad, pad + 24),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive grid that picks a column count from the available width.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, required this.children, this.minTileWidth = 220, this.spacing = 12, this.childAspectRatio});
  final List<Widget> children;
  final double minTileWidth;
  final double spacing;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = (constraints.maxWidth / minTileWidth).floor().clamp(1, 8);
      final w = (constraints.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [for (final c in children) SizedBox(width: w, child: c)],
      );
    });
  }
}
