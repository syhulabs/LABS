import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Rounded surface with border, optional hover/tap affordance.
class AppCard extends StatefulWidget {
  const AppCard({super.key, required this.child, this.onTap, this.onLongPress, this.padding = const EdgeInsets.all(16), this.color, this.borderColor, this.selected = false, this.gradient});
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final bool selected;
  final Gradient? gradient;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final interactive = widget.onTap != null || widget.onLongPress != null;
    final bg = widget.color ?? (_hover && interactive ? c.surfaceHover : c.surface);
    final border = widget.selected ? c.accent : (widget.borderColor ?? c.border);
    return MouseRegion(
      cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        decoration: BoxDecoration(
          color: widget.gradient == null ? bg : null,
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: border, width: widget.selected ? 1.5 : 1),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Padding(padding: widget.padding, child: widget.child),
          ),
        ),
      ),
    );
  }
}
