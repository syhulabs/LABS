import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/data/secure/crypto_service.dart';
import 'package:syhu_account_hub/data/secure/key_store.dart';

void main() {
  late CryptoService crypto;
  late InMemoryKeyStore store;
  setUp(() {
    store = InMemoryKeyStore();
    crypto = CryptoService(store);
  });

  test('master key is generated once and kept in the key store', () async {
    expect(await crypto.hasMasterKey(), isFalse);
    final k1 = await crypto.masterKey();
    expect(await crypto.hasMasterKey(), isTrue);
    final k2 = await CryptoService(store).masterKey();
    expect(await k1.extractBytes(), await k2.extractBytes());
    expect((await k1.extractBytes()).length, 32);
  });

  test('AES-GCM round trip with fresh nonce per call and AAD binding', () async {
    final plain = utf8.encode('sk-live-SECRET');
    final (c1, n1) = await crypto.encryptWithMaster(plain, aad: utf8.encode('item-1'));
    final (c2, n2) = await crypto.encryptWithMaster(plain, aad: utf8.encode('item-1'));
    expect(n1, isNot(n2));
    expect(c1, isNot(c2));
    expect(n1.length, 12);
    expect(c1.length, plain.length + 16);
    expect(utf8.decode(await crypto.decryptWithMaster(c1, n1, aad: utf8.encode('item-1'))), 'sk-live-SECRET');
    expect(() => crypto.decryptWithMaster(c1, n1, aad: utf8.encode('item-2')), throwsA(anything), reason: 'ciphertext bound to a different id must fail');
    final tampered = List<int>.from(c1)..[0] ^= 0xFF;
    expect(() => crypto.decryptWithMaster(tampered, n1, aad: utf8.encode('item-1')), throwsA(anything));
  });

  test('passphrase envelope round trip and wrong passphrase rejection', () async {
    final env = await crypto.encryptWithPassphrase(utf8.encode('{"hello":"world"}'), 'correct horse battery', iterations: 2000);
    final j = jsonDecode(env) as Map<String, dynamic>;
    expect(j['format'], 'syhu-account-hub-encrypted-backup');
    expect(j['cipher'], 'aes-256-gcm');
    expect(env.contains('hello'), isFalse);
    expect(utf8.decode(await crypto.decryptWithPassphrase(env, 'correct horse battery')), '{"hello":"world"}');
    expect(() => crypto.decryptWithPassphrase(env, 'wrong'), throwsFormatException);
    expect(() => crypto.decryptWithPassphrase('not json', 'x'), throwsFormatException);
    expect(() => crypto.encryptWithPassphrase([1], 'short'), throwsArgumentError);
  });

  test('passcode is stored as a salted hash and verified in constant time', () async {
    expect(await crypto.hasPasscode(), isFalse);
    await crypto.setPasscode('1234');
    expect(await crypto.hasPasscode(), isTrue);
    expect(store.read(CryptoService.masterKeyName), completion(isNull), reason: 'passcode must not create a vault key');
    final raw = (await store.read('syhu.lock.passcode.v1'))!;
    expect(raw.contains('1234'), isFalse);
    expect(await crypto.verifyPasscode('1234'), isTrue);
    expect(await crypto.verifyPasscode('1235'), isFalse);
    await crypto.clearPasscode();
    expect(await crypto.verifyPasscode('1234'), isFalse);
    expect(() => crypto.setPasscode('12'), throwsArgumentError);
  });
}
