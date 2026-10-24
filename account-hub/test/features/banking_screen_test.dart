import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/data/secure/vault_repository.dart';
import 'package:syhu_account_hub/domain/enums.dart';
import 'package:syhu_account_hub/features/banking/bank_account_detail_screen.dart';
import 'package:syhu_account_hub/features/banking/banking_screen.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('banking shows privacy banner and empty states on every tab', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const BankingScreen());
    await settle(tester);
    expect(find.textContaining('Metadata only. No bank connections'), findsOneWidget);
    expect(find.text('No bank accounts yet'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byWidgetPredicate((w) => w is SegmentedButton), matching: find.text('Cards')));
    await settle(tester);
    expect(find.text('No cards yet'), findsOneWidget);
    await tester.tap(find.text('UPI, wallets & methods'));
    await settle(tester);
    expect(find.text('No payment methods yet'), findsOneWidget);
  });

  testWidgets('bank account created with a 16-digit number renders only the last four', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await data(tester, () => c.read(financeRepositoryProvider).upsertBankAccount(bankName: 'HDFC Bank', nickname: 'Main savings', last4: '1234 5678 9012 4321', ifsc: 'hdfc0001234'));
    await pumpScreen(tester, c, const BankingScreen());
    await settle(tester);
    expect(find.text('•••• 4321'), findsOneWidget);
    expect(find.textContaining('1234 5678'), findsNothing);
    expect(find.textContaining('9012'), findsNothing);
    expect(find.textContaining('IFSC HDFC0001234'), findsOneWidget);
    expect(find.text('Main savings'), findsOneWidget);
  });

  testWidgets('cards never show more than four digits and flag expiry', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    final now = DateTime.now();
    await data(tester, () async {
      final f = c.read(financeRepositoryProvider);
      await f.upsertCard(nickname: 'Travel card', last4: '4111111111111111', expMonth: 12, expYear: now.year + 3, kind: CardKind.credit, network: 'Visa');
      await f.upsertCard(nickname: 'Old card', last4: '9999', expMonth: 1, expYear: now.year - 1);
    });
    await pumpScreen(tester, c, const BankingScreen(initialTab: 'cards'));
    await settle(tester);
    expect(find.text('•••• •••• •••• 1111'), findsOneWidget);
    expect(find.textContaining('4111 1111'), findsNothing);
    expect(find.textContaining('41111111'), findsNothing);
    expect(find.text('Expired'), findsOneWidget);
    expect(find.text('Visa'), findsOneWidget);
  });

  testWidgets('payment methods tab lists methods with default star and linked card', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await data(tester, () async {
      final f = c.read(financeRepositoryProvider);
      final card = await f.upsertCard(nickname: 'HDFC Visa', last4: '4321');
      await f.upsertPaymentMethod(label: 'Visa ending 4321', kind: PaymentMethodKind.card, cardId: card.id, isDefault: true);
      await f.upsertPaymentMethod(label: 'Studio UPI', kind: PaymentMethodKind.upi, identifierHint: 'studio@okhdfc');
    });
    await pumpScreen(tester, c, const BankingScreen(initialTab: 'methods'));
    await settle(tester);
    expect(find.text('Visa ending 4321'), findsWidgets);
    expect(find.text('Studio UPI'), findsOneWidget);
    expect(find.textContaining('studio@okhdfc'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });

  testWidgets('bank detail masks number, shows vault status and linked cards', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    final bankId = await data(tester, () async {
      final vault = c.read(vaultRepositoryProvider);
      final item = await vault.create(title: 'Main account number', kind: SecureItemKind.bankAccountNumber, secret: const VaultSecret(value: '123456789012'));
      final f = c.read(financeRepositoryProvider);
      final b = await f.upsertBankAccount(bankName: 'State Bank of India', nickname: 'Salary', last4: '123456789012', holderName: 'SYHU', fullNumberVaultId: item.id, website: 'https://www.onlinesbi.sbi');
      await f.upsertCard(nickname: 'SBI debit', last4: '0001', bankAccountId: b.id);
      return b.id;
    });
    await pumpScreen(tester, c, BankAccountDetailScreen(bankAccountId: bankId));
    await settle(tester);
    expect(find.text('•••• 9012'), findsOneWidget);
    expect(find.textContaining('123456789012'), findsNothing);
    expect(find.text('Full number in Vault'), findsOneWidget);
    expect(find.text('Reveal'), findsOneWidget);
    expect(find.text('SBI debit'), findsOneWidget);
    expect(find.text('Open bank website'), findsOneWidget);
  });
}
