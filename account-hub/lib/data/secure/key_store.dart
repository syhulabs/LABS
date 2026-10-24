import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Minimal abstraction over the OS secret store so the vault can be unit
/// tested with an in-memory implementation.
abstract class KeyStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Apple Keychain (macOS/iOS), Android Keystore-backed storage, libsecret on
/// Linux. Only small secrets (master key, passcode hash) are stored here.
class SecureKeyStore implements KeyStore {
  SecureKeyStore()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(),
          mOptions: MacOsOptions(),
        );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class InMemoryKeyStore implements KeyStore {
  final Map<String, String> _m = {};
  @override
  Future<String?> read(String key) async => _m[key];
  @override
  Future<void> write(String key, String value) async => _m[key] = value;
  @override
  Future<void> delete(String key) async => _m.remove(key);
}
