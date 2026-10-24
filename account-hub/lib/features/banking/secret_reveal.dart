import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/toast.dart';

/// Reveals a vault secret on demand, masks it again after 30 seconds, and
/// copies it with clipboard auto-clear. The value never reaches a toast.
class SecretReveal extends ConsumerStatefulWidget {
  const SecretReveal({super.key, required this.vaultItemId, required this.label});
  final String vaultItemId;
  final String label;
  @override
  ConsumerState<SecretReveal> createState() => _SecretRevealState();
}

class _SecretRevealState extends ConsumerState<SecretReveal> {
  String? _value;
  bool _visible = false;
  bool _busy = false;
  Timer? _hide;

  @override
  void dispose() {
    _hide?.cancel();
    super.dispose();
  }

  Future<void> _reveal() async {
    setState(() => _busy = true);
    try {
      final s = await ref.read(vaultRepositoryProvider).reveal(widget.vaultItemId);
      if (!mounted) return;
      setState(() {
        _value = s.value;
        _visible = true;
      });
      _hide?.cancel();
      _hide = Timer(const Duration(seconds: 30), () {
        if (mounted) setState(() { _visible = false; _value = null; });
      });
    } catch (e) {
      if (mounted) showToast(context, 'Could not decrypt: ${friendlyError(e)}', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shown = _value == null ? '••••••••••••' : (_visible ? _value! : '•' * _value!.length.clamp(8, 24));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: BorderRadius.circular(10), border: Border.all(color: c.border)),
      child: Row(children: [
        Icon(Icons.lock_outline, size: 16, color: c.textMuted),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.label, style: context.text.labelSmall?.copyWith(color: c.textMuted)),
          SelectableText(shown, style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()], letterSpacing: 1.2)),
        ])),
        if (_value == null)
          TextButton.icon(onPressed: _busy ? null : _reveal, icon: const Icon(Icons.visibility_outlined, size: 16), label: const Text('Reveal'))
        else ...[
          IconButton(tooltip: _visible ? 'Hide' : 'Show', icon: Icon(_visible ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18), onPressed: () => setState(() => _visible = !_visible)),
          IconButton(
            tooltip: 'Copy (clears from clipboard automatically)',
            icon: const Icon(Icons.copy_outlined, size: 18),
            onPressed: () async {
              await ref.read(clipboardServiceProvider).copySensitive(_value!);
              if (context.mounted) showToast(context, 'Copied. Clipboard clears automatically.');
            },
          ),
        ],
      ]),
    );
  }
}
