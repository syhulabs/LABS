import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'key_store.dart';

/// Authenticated encryption for vault records and encrypted backups.
///
/// * Vault: AES-256-GCM with a random 256-bit master key generated on first
///   use and stored only in the OS keychain ([KeyStore]). Each record gets a
///   fresh 96-bit nonce; ciphertext and GCM tag are stored together.
/// * Backups: AES-256-GCM with a key derived from the user's passphrase via
///   PBKDF2-HMAC-SHA256 (600k iterations, random 16-byte salt).
///
/// No custom primitives: everything comes from package:cryptography.
class CryptoService {
  CryptoService(this.keyStore, {Random? random}) : _rng = random ?? Random.secure();

  final KeyStore keyStore;
  final Random _rng;
  final AesGcm _aes = AesGcm.with256bits();

  static const masterKeyName = 'syhu.vault.masterKey.v1';
  static const currentKeyId = 'v1';
  static const backupKdfIterations = 600000;

  SecretKey? _cachedMaster;

  Uint8List randomBytes(int n) => Uint8List.fromList(List<int>.generate(n, (_) => _rng.nextInt(256)));

  /// Loads the master key from the keychain, generating it on first use.
  Future<SecretKey> masterKey() async {
    if (_cachedMaster != null) return _cachedMaster!;
    final stored = await keyStore.read(masterKeyName);
    if (stored != null) {
      _cachedMaster = SecretKey(base64Decode(stored));
      return _cachedMaster!;
    }
    final fresh = randomBytes(32);
    await keyStore.write(masterKeyName, base64Encode(fresh));
    _cachedMaster = SecretKey(fresh);
    return _cachedMaster!;
  }

  Future<bool> hasMasterKey() async => (await keyStore.read(masterKeyName)) != null;

  /// Encrypts [plaintext] with the master key. Returns (ciphertext||tag, nonce).
  Future<(Uint8List, Uint8List)> encryptWithMaster(List<int> plaintext, {List<int>? aad}) async {
    final key = await masterKey();
    return _encrypt(plaintext, key, aad: aad);
  }

  Future<Uint8List> decryptWithMaster(List<int> ciphertextWithTag, List<int> nonce, {List<int>? aad}) async {
    final key = await masterKey();
    return _decrypt(ciphertextWithTag, nonce, key, aad: aad);
  }

  Future<(Uint8List, Uint8List)> _encrypt(List<int> plaintext, SecretKey key, {List<int>? aad}) async {
    final nonce = randomBytes(12);
    final box = await _aes.encrypt(plaintext, secretKey: key, nonce: nonce, aad: aad ?? const []);
    final out = Uint8List(box.cipherText.length + box.mac.bytes.length)
      ..setAll(0, box.cipherText)
      ..setAll(box.cipherText.length, box.mac.bytes);
    return (out, Uint8List.fromList(nonce));
  }

  Future<Uint8List> _decrypt(List<int> ciphertextWithTag, List<int> nonce, SecretKey key, {List<int>? aad}) async {
    if (ciphertextWithTag.length < 16) throw const FormatException('Ciphertext too short');
    final split = ciphertextWithTag.length - 16;
    final box = SecretBox(
      ciphertextWithTag.sublist(0, split),
      nonce: nonce,
      mac: Mac(ciphertextWithTag.sublist(split)),
    );
    final clear = await _aes.decrypt(box, secretKey: key, aad: aad ?? const []);
    return Uint8List.fromList(clear);
  }

  // ---------- Passphrase-based (backups) ----------

  Future<SecretKey> deriveBackupKey(String passphrase, List<int> salt, {int iterations = backupKdfIterations}) {
    final kdf = Pbkdf2.hmacSha256(iterations: iterations, bits: 256);
    return kdf.deriveKeyFromPassword(password: passphrase, nonce: salt);
  }

  /// Encrypts [plaintext] with a passphrase. Output is a self-describing JSON
  /// envelope (all fields base64) safe to write to disk.
  Future<String> encryptWithPassphrase(List<int> plaintext, String passphrase, {int iterations = backupKdfIterations}) async {
    if (passphrase.length < 8) throw ArgumentError('Passphrase must be at least 8 characters');
    final salt = randomBytes(16);
    final key = await deriveBackupKey(passphrase, salt, iterations: iterations);
    final (ct, nonce) = await _encrypt(plaintext, key);
    return jsonEncode({
      'format': 'syhu-account-hub-encrypted-backup',
      'version': 1,
      'kdf': 'pbkdf2-hmac-sha256',
      'iterations': iterations,
      'cipher': 'aes-256-gcm',
      'salt': base64Encode(salt),
      'nonce': base64Encode(nonce),
      'data': base64Encode(ct),
    });
  }

  Future<Uint8List> decryptWithPassphrase(String envelopeJson, String passphrase) async {
    final Map<String, dynamic> env;
    try {
      env = jsonDecode(envelopeJson) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('Not an encrypted backup file');
    }
    if (env['format'] != 'syhu-account-hub-encrypted-backup') {
      throw const FormatException('Not a SYHU Account Hub encrypted backup');
    }
    final salt = base64Decode(env['salt'] as String);
    final nonce = base64Decode(env['nonce'] as String);
    final data = base64Decode(env['data'] as String);
    final iterations = (env['iterations'] as num?)?.toInt() ?? backupKdfIterations;
    final key = await deriveBackupKey(passphrase, salt, iterations: iterations);
    try {
      return await _decrypt(data, nonce, key);
    } on SecretBoxAuthenticationError {
      throw const FormatException('Wrong passphrase or corrupted backup');
    }
  }

  // ---------- Passcode (fallback app lock) ----------

  static const _passcodeHashName = 'syhu.lock.passcode.v1';

  Future<bool> hasPasscode() async => (await keyStore.read(_passcodeHashName)) != null;

  Future<void> setPasscode(String passcode) async {
    if (passcode.length < 4) throw ArgumentError('Passcode must be at least 4 characters');
    final salt = randomBytes(16);
    final key = await deriveBackupKey(passcode, salt, iterations: 200000);
    final bytes = await key.extractBytes();
    await keyStore.write(_passcodeHashName, jsonEncode({'salt': base64Encode(salt), 'hash': base64Encode(bytes)}));
  }

  Future<void> clearPasscode() => keyStore.delete(_passcodeHashName);

  Future<bool> verifyPasscode(String passcode) async {
    final raw = await keyStore.read(_passcodeHashName);
    if (raw == null) return false;
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final key = await deriveBackupKey(passcode, base64Decode(j['salt'] as String), iterations: 200000);
    final bytes = await key.extractBytes();
    return _constantTimeEquals(bytes, base64Decode(j['hash'] as String));
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var r = 0;
    for (var i = 0; i < a.length; i++) {
      r |= a[i] ^ b[i];
    }
    return r == 0;
  }
}
