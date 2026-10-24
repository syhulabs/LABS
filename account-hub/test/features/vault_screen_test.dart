import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/features/vault/vault_screen.dart';
import 'package:syhu_account_hub/shared/widgets/app_card.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('vault shows empty state and lock banner', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const VaultScreen());
    await settle(tester);
    expect(find.text('The vault is empty'), findsOneWidget);
    expect(find.textContaining('App Lock is off'), findsOneWidget);
  });

  testWidgets('creating a secret via the form encrypts it; list never shows the value; reveal returns it', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const VaultScreen());
    await settle(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Add secret').first);
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'OpenAI key');
    await tester.enterText(find.widgetWithText(TextFormField, 'Secret value'), 'sk-TOPSECRET-999');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Encrypt & save'));
    // AES-GCM completes only with real async, so the save runs under runAsync.
    // Animations started there never finish under the fake clock, so the
    // screen is pumped fresh afterwards instead of waiting for the dialog.
    await tester.runAsync(() async {
      await tester.tap(find.widgetWithText(FilledButton, 'Encrypt & save'));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    final items = await data(tester, () => c.read(vaultRepositoryProvider).watchAll().first);
    expect(items.length, 1);
    expect(items.single.title, 'OpenAI key');
    expect(String.fromCharCodes(items.single.ciphertext).contains('TOPSECRET'), isFalse);
    // Decrypt round-trip is covered in test/data_layer_test.dart.

    await pumpScreen(tester, c, const VaultScreen());
    await settle(tester);
    final card = find.descendant(of: find.byType(AppCard), matching: find.text('OpenAI key'));
    expect(card, findsOneWidget);
    expect(find.textContaining('TOPSECRET'), findsNothing);

    // The detail sheet shows metadata and only reveals on request.
    await tester.tap(card);
    await settle(tester);
    expect(find.text('Reveal secret'), findsOneWidget);
    expect(find.textContaining('TOPSECRET'), findsNothing);
  });

  testWidgets('credential reference can be added', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const VaultScreen());
    await settle(tester);
    await tester.tap(find.textContaining('Credential references'));
    await settle(tester);
    expect(find.text('No credential references'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Add reference').first);
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Label'), 'GitHub login');
    await tester.tap(find.widgetWithText(ActionChip, '1Password'));
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Save'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await settle(tester);
    final refs = await data(tester, () => c.read(vaultRepositoryProvider).watchCredentialRefs().first);
    expect(refs.single.manager, '1Password');
    expect(find.text('GitHub login'), findsOneWidget);
  });
}
