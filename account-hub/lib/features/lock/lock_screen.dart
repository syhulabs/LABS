import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';

/// Full-screen gate shown while the app is locked.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});
  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _pass = TextEditingController();
  bool _busy = false;
  bool _deviceAuth = false;
  bool _hasPasscode = false;

  @override
  void initState() {
    super.initState();
    final lock = ref.read(appLockProvider);
    lock.canUseDeviceAuth().then((v) {
      if (!mounted) return;
      setState(() => _deviceAuth = v);
      if (v) _tryDevice();
    });
    lock.crypto.hasPasscode().then((v) => mounted ? setState(() => _hasPasscode = v) : null);
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  Future<void> _tryDevice() async {
    if (!_deviceAuth || _busy) return;
    setState(() => _busy = true);
    await ref.read(appLockProvider).unlockWithDevice();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final lock = ref.watch(appLockProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: c.heroGradient),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Container(width: 56, height: 56, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: [c.accent, c.accentPink])), child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28)),
                  const SizedBox(height: 18),
                  Text('SYHU Account Hub is locked', style: context.text.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text('Authenticate to continue.', style: context.text.bodyMedium?.copyWith(color: c.textMuted), textAlign: TextAlign.center),
                  const SizedBox(height: 22),
                  if (_deviceAuth)
                    FilledButton.icon(onPressed: _busy ? null : _tryDevice, icon: const Icon(Icons.fingerprint), label: const Text('Unlock with Touch ID / device')),
                  if (_hasPasscode) ...[
                    if (_deviceAuth) const SizedBox(height: 14),
                    TextField(
                      controller: _pass,
                      obscureText: true,
                      autofocus: !_deviceAuth,
                      decoration: const InputDecoration(labelText: 'Passcode', prefixIcon: Icon(Icons.password, size: 18)),
                      onSubmitted: (_) => _submitPasscode(),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(onPressed: _busy ? null : _submitPasscode, child: const Text('Unlock with passcode')),
                  ],
                  if (!_deviceAuth && !_hasPasscode)
                    Text('No unlock method is available on this device.', style: TextStyle(color: c.danger), textAlign: TextAlign.center),
                  if (lock.lastError != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(lock.lastError!, style: TextStyle(color: c.danger), textAlign: TextAlign.center)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitPasscode() async {
    setState(() => _busy = true);
    await ref.read(appLockProvider).unlockWithPasscode(_pass.text);
    _pass.clear();
    if (mounted) setState(() => _busy = false);
  }
}
