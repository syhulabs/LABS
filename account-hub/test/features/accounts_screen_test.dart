import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/features/accounts/account_detail_screen.dart';
import 'package:syhu_account_hub/features/accounts/accounts_screen.dart';
import 'package:syhu_account_hub/features/accounts/email_detail_screen.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('accounts and emails tabs show empty states', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const AccountsScreen());
    await settle(tester);
    expect(find.text('No accounts yet'), findsOneWidget);
    await tester.tap(find.text('Emails'));
    await settle(tester);
    expect(find.text('No email identities yet'), findsOneWidget);
    await tester.tap(find.text('Archived'));
    await settle(tester);
    expect(find.text('Archive is empty'), findsOneWidget);
  });

  testWidgets('adding an email through the form creates one identity', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const AccountsScreen(initialTab: 'emails'));
    await settle(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Add email'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Email address'), 'Studio@Example.com');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Save'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await settle(tester);
    final emails = await data(tester, () => c.read(emailRepositoryProvider).all());
    expect(emails.length, 1);
    expect(emails.single.provider, 'example.com');
    expect(find.text('Studio@Example.com'), findsOneWidget);
    expect(find.text('0 connected'), findsOneWidget);
  });

  testWidgets('account detail shows platform and email; email detail lists the account', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    final (emailId, accountId) = await data(tester, () async {
      final e = await c.read(emailRepositoryProvider).upsert(address: 'dev@studio.com');
      final a = await c.read(accountRepositoryProvider).upsert(platformId: 'github', emailIdentityId: e.id, accountName: 'Studio', username: 'syhu-dev');
      return (e.id, a.id);
    });
    await pumpScreen(tester, c, AccountDetailScreen(accountId: accountId));
    await settle(tester);
    expect(find.text('GitHub'), findsWidgets);
    expect(find.text('dev@studio.com'), findsOneWidget);
    expect(find.text('syhu-dev'), findsOneWidget);
    expect(find.text('No credential reference. Edit the account to point at a password-manager item.'), findsOneWidget);

    await pumpScreen(tester, c, EmailDetailScreen(emailId: emailId));
    await settle(tester);
    expect(find.text('GitHub · Studio'), findsOneWidget);
    expect(find.text('1 connected'), findsOneWidget);
  });
}
