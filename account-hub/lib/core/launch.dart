import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/widgets/toast.dart';

/// Opens an external URL in the system browser; normalises missing schemes.
Future<void> openUrl(BuildContext context, String? raw) async {
  if (raw == null || raw.trim().isEmpty) return;
  var s = raw.trim();
  if (!s.startsWith('http://') && !s.startsWith('https://')) s = 'https://$s';
  final uri = Uri.tryParse(s);
  if (uri == null) {
    showToast(context, 'Invalid link', error: true);
    return;
  }
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showToast(context, 'Could not open $s', error: true);
}
