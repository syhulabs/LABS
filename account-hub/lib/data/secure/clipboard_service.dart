import 'dart:async';

import 'package:flutter/services.dart';

/// Copies sensitive values and clears them from the clipboard after a delay,
/// provided the clipboard still holds the same value.
class ClipboardService {
  Timer? _timer;
  Duration clearAfter = const Duration(seconds: 30);

  Future<void> copySensitive(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    _timer?.cancel();
    if (clearAfter.inSeconds <= 0) return;
    _timer = Timer(clearAfter, () async {
      final current = await Clipboard.getData(Clipboard.kTextPlain);
      if (current?.text == value) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    });
  }

  Future<void> copyPlain(String value) => Clipboard.setData(ClipboardData(text: value));
}
