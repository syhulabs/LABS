import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.actionLabel, this.onAction, this.secondaryLabel, this.onSecondary, this.compact = false});
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: compact ? 20 : 48, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: compact ? 56 : 84, height: compact ? 56 : 84,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [c.accent.withValues(alpha: 0.35), c.accentPink.withValues(alpha: 0.25)])),
                child: Icon(icon, size: compact ? 26 : 38, color: c.text),
              ),
              SizedBox(height: compact ? 12 : 20),
              Text(title, style: compact ? context.text.titleMedium : context.text.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(message, style: context.text.bodyMedium?.copyWith(color: c.textMuted), textAlign: TextAlign.center),
              if (actionLabel != null || secondaryLabel != null) ...[
                const SizedBox(height: 20),
                Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
                  if (actionLabel != null) FilledButton.icon(onPressed: onAction, icon: const Icon(Icons.add, size: 18), label: Text(actionLabel!)),
                  if (secondaryLabel != null) OutlinedButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
