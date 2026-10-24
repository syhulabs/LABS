import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, {bool error = false}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Row(children: [
        Icon(error ? Icons.error_outline : Icons.check_circle_outline, size: 18, color: error ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(message)),
      ]),
      duration: Duration(seconds: error ? 5 : 3),
      width: 420,
    ));
}

/// Runs [action], shows an error toast on failure. Returns true on success.
Future<bool> guard(BuildContext context, Future<void> Function() action, {String? success}) async {
  try {
    await action();
    if (success != null && context.mounted) showToast(context, success);
    return true;
  } catch (e) {
    if (context.mounted) showToast(context, friendlyError(e), error: true);
    return false;
  }
}

String friendlyError(Object e) {
  final s = e.toString();
  if (s.startsWith('Bad state: ')) return s.substring(11);
  if (s.startsWith('Invalid argument(s): ')) return s.substring(21);
  if (s.startsWith('FormatException: ')) return s.substring(17);
  return s;
}
