import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

import 'crypto_service.dart';

enum AppLockState { disabled, unlocked, locked }

/// App lock: biometric/system authentication where the platform supports it
/// (macOS Touch ID, iOS Face/Touch ID, Android biometrics) with a local
/// passcode fallback (hashed in the keychain). Auto-locks after inactivity.
class AppLockController extends ChangeNotifier {
  AppLockController(this.crypto, {LocalAuthentication? localAuth, bool? biometricsSupported})
      : _auth = localAuth ?? LocalAuthentication(),
        _platformSupportsLocalAuth = biometricsSupported ?? _defaultLocalAuthSupport();

  final CryptoService crypto;
  final LocalAuthentication _auth;
  final bool _platformSupportsLocalAuth;

  AppLockState _state = AppLockState.disabled;
  AppLockState get state => _state;
  bool get isLocked => _state == AppLockState.locked;

  bool _enabled = false;
  bool get enabled => _enabled;
  Duration timeout = const Duration(minutes: 5);
  Timer? _timer;
  String? lastError;

  static bool _defaultLocalAuthSupport() {
    if (kIsWeb) return false;
    return Platform.isMacOS || Platform.isIOS || Platform.isAndroid || Platform.isWindows;
  }

  Future<bool> canUseDeviceAuth() async {
    if (!_platformSupportsLocalAuth) return false;
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Called at startup with persisted settings. Locks immediately if enabled.
  Future<void> configure({required bool enabled, required int timeoutSeconds}) async {
    _enabled = enabled;
    timeout = Duration(seconds: timeoutSeconds);
    if (!enabled) {
      _state = AppLockState.disabled;
      _timer?.cancel();
    } else if (_state == AppLockState.disabled) {
      _state = AppLockState.locked;
    }
    notifyListeners();
  }

  /// Enabling requires at least one unlock method to exist.
  Future<String?> enable({String? passcode}) async {
    final device = await canUseDeviceAuth();
    final hasPass = await crypto.hasPasscode();
    if (passcode != null && passcode.isNotEmpty) {
      await crypto.setPasscode(passcode);
    } else if (!device && !hasPass) {
      return 'Set a passcode first: this device has no biometric or system authentication available.';
    }
    _enabled = true;
    _state = AppLockState.unlocked;
    _resetTimer();
    notifyListeners();
    return null;
  }

  Future<void> disable() async {
    _enabled = false;
    _state = AppLockState.disabled;
    _timer?.cancel();
    notifyListeners();
  }

  void lock() {
    if (!_enabled) return;
    _state = AppLockState.locked;
    _timer?.cancel();
    notifyListeners();
  }

  /// Any user interaction resets the inactivity timer.
  void touch() {
    if (!_enabled || _state != AppLockState.unlocked) return;
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    if (timeout.inSeconds <= 0) return;
    _timer = Timer(timeout, lock);
  }

  Future<bool> unlockWithDevice() async {
    lastError = null;
    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Unlock SYHU Account Hub',
        persistAcrossBackgrounding: true,
      );
      if (ok) _unlocked();
      return ok;
    } catch (e) {
      lastError = 'Device authentication unavailable';
      notifyListeners();
      return false;
    }
  }

  Future<bool> unlockWithPasscode(String passcode) async {
    lastError = null;
    final ok = await crypto.verifyPasscode(passcode);
    if (ok) {
      _unlocked();
    } else {
      lastError = 'Incorrect passcode';
      notifyListeners();
    }
    return ok;
  }

  void _unlocked() {
    _state = AppLockState.unlocked;
    _resetTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
