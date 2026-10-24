import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/repositories/settings_repository.dart';
import '../data/secure/app_lock_controller.dart';
import '../features/lock/lock_screen.dart';
import 'providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class AccountHubApp extends ConsumerStatefulWidget {
  const AccountHubApp({super.key});
  @override
  ConsumerState<AccountHubApp> createState() => _AccountHubAppState();
}

class _AccountHubAppState extends ConsumerState<AccountHubApp> with WidgetsBindingObserver {
  late final GoRouter _router = buildRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Lock as soon as the app goes to the background when App Lock is on.
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      ref.read(appLockProvider).lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final mode = switch (settings.themeMode) { 'light' => ThemeMode.light, 'system' => ThemeMode.system, _ => ThemeMode.dark };
    final lock = ref.watch(appLockProvider);
    return MaterialApp.router(
      title: 'SYHU Account Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      routerConfig: _router,
      builder: (context, child) => Stack(children: [
        child ?? const SizedBox.shrink(),
        if (lock.state == AppLockState.locked) const Positioned.fill(child: LockScreen()),
      ]),
    );
  }
}
