import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle, this.actions = const [], this.onViewAll, this.padding = const EdgeInsets.only(bottom: 12)});
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final VoidCallback? onViewAll;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: context.text.titleLarge),
              if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(subtitle!, style: context.text.bodySmall?.copyWith(color: context.colors.textMuted))),
            ]),
          ),
          ...actions,
          if (onViewAll != null) TextButton(onPressed: onViewAll, child: const Text('View all')),
        ],
      ),
    );
  }
}
