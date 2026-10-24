import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../data/backup/backup_service.dart';
import '../data/catalog/catalog_service.dart';
import '../data/db/app_database.dart';
import '../data/notifications/notification_service.dart';
import '../data/repositories/account_repository.dart';
import '../data/repositories/audit_repository.dart';
import '../data/repositories/email_repository.dart';
import '../data/repositories/finance_repository.dart';
import '../data/repositories/platform_repository.dart';
import '../data/repositories/project_repository.dart';
import '../data/repositories/search_service.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/stats_repository.dart';
import '../data/repositories/subscription_repository.dart';
import '../data/repositories/tag_repository.dart';
import '../domain/enums.dart';
import '../data/repositories/youtube_repository.dart';
import '../data/secure/app_lock_controller.dart';
import '../data/secure/clipboard_service.dart';
import '../data/secure/crypto_service.dart';
import '../data/secure/key_store.dart';
import '../data/secure/vault_repository.dart';

/// Composition root. `databaseProvider` and `keyStoreProvider` are overridden
/// in main() (real) and in tests (in-memory).
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('override databaseProvider'));
final keyStoreProvider = Provider<KeyStore>((ref) => throw UnimplementedError('override keyStoreProvider'));

final auditRepositoryProvider = Provider((ref) => AuditRepository(ref.watch(databaseProvider)));
final catalogServiceProvider = Provider((ref) => CatalogService(ref.watch(databaseProvider)));
final platformRepositoryProvider = Provider((ref) => PlatformRepository(ref.watch(databaseProvider), ref.watch(auditRepositoryProvider)));
final emailRepositoryProvider = Provider((ref) => EmailRepository(ref.watch(databaseProvider), ref.watch(auditRepositoryProvider)));
final accountRepositoryProvider = Provider((ref) => AccountRepository(ref.watch(databaseProvider), ref.watch(auditRepositoryProvider)));
final youtubeRepositoryProvider = Provider((ref) => YoutubeRepository(ref.watch(databaseProvider), ref.watch(auditRepositoryProvider)));
final projectRepositoryProvider = Provider((ref) => ProjectRepository(ref.watch(databaseProvider), ref.watch(auditRepositoryProvider)));
final financeRepositoryProvider = Provider((ref) => FinanceRepository(ref.watch(databaseProvider), ref.watch(auditRepositoryProvider)));
final subscriptionRepositoryProvider = Provider((ref) => SubscriptionRepository(ref.watch(databaseProvider), ref.watch(auditRepositoryProvider)));
final tagRepositoryProvider = Provider((ref) => TagRepository(ref.watch(databaseProvider)));
final settingsRepositoryProvider = Provider((ref) => SettingsRepository(ref.watch(databaseProvider)));
final searchServiceProvider = Provider((ref) => SearchService(ref.watch(databaseProvider)));
final statsRepositoryProvider = Provider((ref) => StatsRepository(ref.watch(databaseProvider), ref.watch(subscriptionRepositoryProvider)));

final cryptoServiceProvider = Provider((ref) => CryptoService(ref.watch(keyStoreProvider)));
final vaultRepositoryProvider = Provider((ref) => VaultRepository(ref.watch(databaseProvider), ref.watch(cryptoServiceProvider), ref.watch(auditRepositoryProvider)));
final backupServiceProvider = Provider((ref) => BackupService(ref.watch(databaseProvider), ref.watch(cryptoServiceProvider), ref.watch(vaultRepositoryProvider), ref.watch(auditRepositoryProvider)));
final clipboardServiceProvider = Provider((ref) => ClipboardService());
final notificationServiceProvider = Provider((ref) => NotificationService());

/// ChangeNotifierProvider disposes the controller itself; do not add a
/// second onDispose or the notifier is disposed twice.
final appLockProvider = ChangeNotifierProvider<AppLockController>((ref) => AppLockController(ref.watch(cryptoServiceProvider)));

// ---------- Reactive data streams ----------
final settingsProvider = StreamProvider<Map<String, dynamic>>((ref) => ref.watch(settingsRepositoryProvider).watchAll());
final allPlatformsProvider = StreamProvider<List<Platform>>((ref) => ref.watch(platformRepositoryProvider).watchAll());
final myWorldProvider = StreamProvider<List<Platform>>((ref) => ref.watch(platformRepositoryProvider).watchMyWorld());
final emailsProvider = StreamProvider<List<EmailIdentity>>((ref) => ref.watch(emailRepositoryProvider).watchAll());
final archivedEmailsProvider = StreamProvider<List<EmailIdentity>>((ref) => ref.watch(emailRepositoryProvider).watchAll(includeArchived: true).map((l) => l.where((e) => e.archivedAt != null).toList()));
final accountsProvider = StreamProvider<List<AccountView>>((ref) => ref.watch(accountRepositoryProvider).watchAll());
final archivedAccountsProvider = StreamProvider<List<AccountView>>((ref) => ref.watch(accountRepositoryProvider).watchArchived());
final recentAccountsProvider = StreamProvider<List<AccountView>>((ref) => ref.watch(accountRepositoryProvider).watchRecent());
final channelsProvider = StreamProvider<List<ChannelView>>((ref) => ref.watch(youtubeRepositoryProvider).watchAll());
final projectsProvider = StreamProvider<List<Project>>((ref) => ref.watch(projectRepositoryProvider).watchProjects());
final organizationsProvider = StreamProvider<List<Organization>>((ref) => ref.watch(projectRepositoryProvider).watchOrganizations());
final artistsProvider = StreamProvider<List<Artist>>((ref) => ref.watch(projectRepositoryProvider).watchArtists());
final documentsProvider = StreamProvider<List<DocumentReference>>((ref) => ref.watch(projectRepositoryProvider).watchDocuments());
final bankAccountsProvider = StreamProvider<List<BankAccount>>((ref) => ref.watch(financeRepositoryProvider).watchBankAccounts());
final cardsProvider = StreamProvider<List<PaymentCard>>((ref) => ref.watch(financeRepositoryProvider).watchCards());
final paymentMethodsProvider = StreamProvider<List<PaymentMethod>>((ref) => ref.watch(financeRepositoryProvider).watchPaymentMethods());
final subscriptionsProvider = StreamProvider<List<SubscriptionView>>((ref) => ref.watch(subscriptionRepositoryProvider).watchAll());
final vaultItemsProvider = StreamProvider<List<SecureItem>>((ref) => ref.watch(vaultRepositoryProvider).watchAll());
final credentialRefsProvider = StreamProvider<List<CredentialReference>>((ref) => ref.watch(vaultRepositoryProvider).watchCredentialRefs());
final tagsProvider = StreamProvider<List<Tag>>((ref) => ref.watch(tagRepositoryProvider).watchTags());
final auditProvider = StreamProvider<List<AuditEvent>>((ref) => ref.watch(auditRepositoryProvider).watchRecent());
final statsProvider = StreamProvider<DashboardStats>((ref) => ref.watch(statsRepositoryProvider).watch());

final accountsByPlatformProvider = StreamProvider.family<List<AccountView>, String>((ref, platformId) => ref.watch(accountRepositoryProvider).watchByPlatform(platformId));
final platformByIdProvider = StreamProvider.family<Platform?, String>((ref, id) => ref.watch(platformRepositoryProvider).watchById(id));
final emailUsageProvider = StreamProvider.family<EmailUsage, String>((ref, id) => ref.watch(emailRepositoryProvider).watchUsage(id));
final linksProvider = StreamProvider.family<List<LinkedEntity>, (EntityType, String)>((ref, key) => ref.watch(projectRepositoryProvider).watchLinks(key.$1, key.$2));
final tagsForProvider = StreamProvider.family<List<Tag>, (EntityType, String)>((ref, key) => ref.watch(tagRepositoryProvider).watchTagsFor(key.$1, key.$2));
final fieldsForProvider = StreamProvider.family<List<CustomField>, (EntityType, String)>((ref, key) => ref.watch(tagRepositoryProvider).watchFields(key.$1, key.$2));
final subscriptionHistoryProvider = StreamProvider.family<List<SubscriptionEvent>, String>((ref, id) => ref.watch(subscriptionRepositoryProvider).watchHistory(id));
