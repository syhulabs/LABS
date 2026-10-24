import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/data/repositories/settings_repository.dart';
import 'package:syhu_account_hub/features/settings/settings_screen.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('theme and currency choices persist to the settings table', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const SettingsScreen());
    await settle(tester);
    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.text('Light'));
    await settle(tester);
    expect(await data(tester, () => c.read(settingsRepositoryProvider).get<String>(SettingsRepository.kThemeMode)), 'light');

    await tester.enterText(find.widgetWithText(TextField, 'Display name'), 'SYHU');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(await data(tester, () => c.read(settingsRepositoryProvider).get<String>(SettingsRepository.kDisplayName)), 'SYHU');
  });

  testWidgets('notifications switch persists; security section opens via initialSection', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const SettingsScreen(initialSection: 'notifications'));
    await settle(tester);
    expect(find.text('Renewal reminders'), findsOneWidget);
    await tester.tap(find.byType(Switch).first);
    await settle(tester);
    expect(await data(tester, () => c.read(settingsRepositoryProvider).get<bool>(SettingsRepository.kNotificationsEnabled)), isFalse);

    await tester.tap(find.text('Security'));
    await settle(tester);
    expect(find.text('App Lock'), findsOneWidget);
    expect(find.text('Set passcode'), findsOneWidget);
  });

  testWidgets('about and data sections render honest statements', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const SettingsScreen(initialSection: 'about'));
    await settle(tester);
    expect(find.textContaining('not been independently security-audited'), findsOneWidget);
    await tester.tap(find.text('Data'));
    await settle(tester);
    expect(find.text('Erase all data'), findsOneWidget);
  });
}
