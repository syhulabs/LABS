import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Confirmation for destructive actions. Returns true when confirmed.
Future<bool> confirmDestructive(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
  bool danger = true,
}) async {
  final c = context.colors;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: Text(message)),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: c.danger) : null,
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Asks the user to type a word (e.g. RESTORE) before a very destructive action.
Future<bool> confirmTyped(BuildContext context, {required String title, required String message, required String word}) async {
  final ctrl = TextEditingController();
  final c = context.colors;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
      return AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(message),
            const SizedBox(height: 14),
            TextField(controller: ctrl, autofocus: true, decoration: InputDecoration(hintText: 'Type $word to confirm'), onChanged: (_) => setState(() {})),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: c.danger),
            onPressed: ctrl.text.trim() == word ? () => Navigator.of(ctx).pop(true) : null,
            child: const Text('Continue'),
          ),
        ],
      );
    }),
  );
  return ok ?? false;
}
