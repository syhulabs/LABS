import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/accounts/account_detail_screen.dart';
import '../features/accounts/accounts_screen.dart';
import '../features/accounts/email_detail_screen.dart';
import '../features/banking/bank_account_detail_screen.dart';
import '../features/banking/banking_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/home/home_screen.dart';
import '../features/hubs/hub_configs.dart';
import '../features/hubs/hub_screen.dart';
import '../features/music/artist_detail_screen.dart';
import '../features/music/music_screen.dart';
import '../features/my_world/my_world_screen.dart';
import '../features/platform/platform_detail_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/studio/organization_detail_screen.dart';
import '../features/studio/project_detail_screen.dart';
import '../features/studio/studio_screen.dart';
import '../features/subscriptions/subscription_detail_screen.dart';
import '../features/subscriptions/subscriptions_screen.dart';
import '../features/vault/vault_screen.dart';
import '../features/youtube/channel_detail_screen.dart';
import '../features/youtube/youtube_screen.dart';
import '../shared/widgets/app_shell.dart';
import 'routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

String _initialLocation() {
  if (kIsWeb) return Routes.home;
  final env = Platform.environment['SYHU_INITIAL_ROUTE'];
  if (env != null && env.startsWith('/')) return env;
  return Routes.home;
}

GoRouter buildRouter() {
  Page<void> page(GoRouterState s, Widget child) => NoTransitionPage(key: s.pageKey, child: child);
  Page<void> sub(GoRouterState s, Widget child) => MaterialPage(key: s.pageKey, child: child);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    // Dev aid for screenshots/automation on desktop: SYHU_INITIAL_ROUTE=/explore
    initialLocation: _initialLocation(),
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', redirect: (_, _) => Routes.home),
          GoRoute(path: Routes.home, pageBuilder: (c, s) => page(s, const HomeScreen())),
          GoRoute(path: Routes.myWorld, pageBuilder: (c, s) => page(s, const MyWorldScreen())),
          GoRoute(path: Routes.explore, pageBuilder: (c, s) => page(s, ExploreScreen(initialCategory: s.uri.queryParameters['category']))),
          GoRoute(path: '/platform/:id', pageBuilder: (c, s) => sub(s, PlatformDetailScreen(platformId: s.pathParameters['id']!))),
          GoRoute(path: Routes.accounts, pageBuilder: (c, s) => page(s, AccountsScreen(initialTab: s.uri.queryParameters['tab'])), routes: [
            GoRoute(path: 'account/:id', pageBuilder: (c, s) => sub(s, AccountDetailScreen(accountId: s.pathParameters['id']!))),
            GoRoute(path: 'email/:id', pageBuilder: (c, s) => sub(s, EmailDetailScreen(emailId: s.pathParameters['id']!))),
          ]),
          GoRoute(path: Routes.youtube, pageBuilder: (c, s) => page(s, const YoutubeScreen()), routes: [
            GoRoute(path: ':id', pageBuilder: (c, s) => sub(s, ChannelDetailScreen(channelId: s.pathParameters['id']!))),
          ]),
          GoRoute(path: Routes.ai, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.ai))),
          GoRoute(path: Routes.social, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.social))),
          GoRoute(path: Routes.music, pageBuilder: (c, s) => page(s, const MusicScreen()), routes: [
            GoRoute(path: 'artist/:id', pageBuilder: (c, s) => sub(s, ArtistDetailScreen(artistId: s.pathParameters['id']!))),
          ]),
          GoRoute(path: Routes.studio, pageBuilder: (c, s) => page(s, const StudioScreen()), routes: [
            GoRoute(path: 'project/:id', pageBuilder: (c, s) => sub(s, ProjectDetailScreen(projectId: s.pathParameters['id']!))),
            GoRoute(path: 'organization/:id', pageBuilder: (c, s) => sub(s, OrganizationDetailScreen(organizationId: s.pathParameters['id']!))),
          ]),
          GoRoute(path: Routes.gaming, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.gaming))),
          GoRoute(path: Routes.engines, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.engines))),
          GoRoute(path: Routes.developer, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.developer))),
          GoRoute(path: Routes.google, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.google))),
          GoRoute(path: Routes.apple, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.apple))),
          GoRoute(path: Routes.microsoft, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.microsoft))),
          GoRoute(path: Routes.cloud, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.cloud))),
          GoRoute(path: Routes.banking, pageBuilder: (c, s) => page(s, BankingScreen(initialTab: s.uri.queryParameters['tab'])), routes: [
            GoRoute(path: 'account/:id', pageBuilder: (c, s) => sub(s, BankAccountDetailScreen(bankAccountId: s.pathParameters['id']!))),
          ]),
          GoRoute(path: Routes.subscriptions, pageBuilder: (c, s) => page(s, const SubscriptionsScreen()), routes: [
            GoRoute(path: ':id', pageBuilder: (c, s) => sub(s, SubscriptionDetailScreen(subscriptionId: s.pathParameters['id']!))),
          ]),
          GoRoute(path: Routes.personal, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.personal))),
          GoRoute(path: Routes.business, pageBuilder: (c, s) => page(s, HubScreen(config: HubConfigs.business))),
          GoRoute(path: Routes.vault, pageBuilder: (c, s) => page(s, const VaultScreen())),
          GoRoute(path: Routes.settings, pageBuilder: (c, s) => page(s, SettingsScreen(initialSection: s.uri.queryParameters['section']))),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
}
