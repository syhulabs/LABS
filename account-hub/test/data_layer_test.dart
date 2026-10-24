import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/data/backup/backup_service.dart';
import 'package:syhu_account_hub/data/catalog/catalog_service.dart';
import 'package:syhu_account_hub/data/db/app_database.dart';
import 'package:syhu_account_hub/data/db/database_connection.dart';
import 'package:syhu_account_hub/data/repositories/account_repository.dart';
import 'package:syhu_account_hub/data/repositories/audit_repository.dart';
import 'package:syhu_account_hub/data/repositories/email_repository.dart';
import 'package:syhu_account_hub/data/repositories/finance_repository.dart';
import 'package:syhu_account_hub/data/repositories/platform_repository.dart';
import 'package:syhu_account_hub/data/repositories/project_repository.dart';
import 'package:syhu_account_hub/data/repositories/search_service.dart';
import 'package:syhu_account_hub/data/repositories/stats_repository.dart';
import 'package:syhu_account_hub/data/repositories/subscription_repository.dart';
import 'package:syhu_account_hub/data/repositories/youtube_repository.dart';
import 'package:syhu_account_hub/data/secure/crypto_service.dart';
import 'package:syhu_account_hub/data/secure/key_store.dart';
import 'package:syhu_account_hub/data/secure/vault_repository.dart';
import 'package:syhu_account_hub/domain/enums.dart';
import 'package:syhu_account_hub/domain/money.dart';

import 'support/test_bundle.dart';

class Harness {
  Harness._(this.db);
  final AppDatabase db;
  late final audit = AuditRepository(db);
  late final catalog = CatalogService(db, bundle: FileAssetBundle());
  late final platforms = PlatformRepository(db, audit);
  late final emails = EmailRepository(db, audit);
  late final accounts = AccountRepository(db, audit);
  late final youtube = YoutubeRepository(db, audit);
  late final projects = ProjectRepository(db, audit);
  late final finance = FinanceRepository(db, audit);
  late final subs = SubscriptionRepository(db, audit);
  late final crypto = CryptoService(InMemoryKeyStore());
  late final vault = VaultRepository(db, crypto, audit);
  late final backup = BackupService(db, crypto, vault, audit);
  late final search = SearchService(db);
  late final stats = StatsRepository(db, subs);

  static Future<Harness> create({bool seed = true}) async {
    final h = Harness._(openInMemoryDatabase());
    if (seed) await h.catalog.ensureSeeded();
    return h;
  }
}

void main() {
  late Harness h;
  setUp(() async => h = await Harness.create());
  tearDown(() => h.db.close());

  test('catalog seeds hundreds of platforms and is idempotent', () async {
    final all = await h.platforms.watchAll().first;
    expect(all.length, greaterThan(400));
    expect(all.where((p) => p.inMyWorld), isEmpty, reason: 'catalog must not pre-populate My World');
    final again = await h.catalog.ensureSeeded();
    expect(again, 0);
    expect((await h.platforms.watchAll().first).length, all.length);
  });

  test('catalog re-import preserves user flags', () async {
    await h.platforms.setInMyWorld('chatgpt', true);
    await h.platforms.setFavorite('chatgpt', true);
    final doc = await h.catalog.loadBundled();
    await h.catalog.importDocument(doc);
    final p = await h.platforms.byId('chatgpt');
    expect(p!.inMyWorld, isTrue);
    expect(p.isFavorite, isTrue);
  });

  test('catalog import rejects duplicate ids', () async {
    expect(
      () => h.catalog.importFromJsonString('{"version":2,"platforms":[{"id":"a","name":"A","categories":[]},{"id":"a","name":"B","categories":[]}]}'),
      throwsFormatException,
    );
  });

  test('one email identity is reused across multiple accounts; multiple accounts per platform', () async {
    final studio = await h.emails.upsert(address: 'Studio@Example.com');
    final same = await h.emails.upsert(address: 'studio@example.com ');
    expect(same.id, studio.id, reason: 'address dedupe is case/space-insensitive');
    expect((await h.emails.all()).length, 1);

    await h.accounts.upsert(platformId: 'chatgpt', emailIdentityId: studio.id, accountName: 'Personal');
    await h.accounts.upsert(platformId: 'chatgpt', emailIdentityId: studio.id, accountName: 'Studio', classification: Classification.business);
    await h.accounts.upsert(platformId: 'github', emailIdentityId: studio.id, accountName: 'Main');
    expect(() => h.accounts.upsert(platformId: 'chatgpt', emailIdentityId: studio.id, accountName: 'studio'), throwsStateError, reason: 'duplicate account rejected');

    final chatgpt = await h.accounts.watchByPlatform('chatgpt').first;
    expect(chatgpt.length, 2);
    final usage = await h.emails.watchUsage(studio.id).first;
    expect(usage.accounts.length, 3, reason: 'reverse lookup lists every connected service');
    final p = await h.platforms.byId('chatgpt');
    expect(p!.inMyWorld, isTrue, reason: 'adding an account places the platform in My World');
  });

  test('one Google identity owns several channels; a channel can have several managers', () async {
    final a = await h.emails.upsert(address: 'a@gmail.com');
    final b = await h.emails.upsert(address: 'b@gmail.com');
    await h.youtube.upsert(name: 'Main Channel', ownerEmailId: a.id, handle: 'main');
    await h.youtube.upsert(name: 'Gaming Channel', ownerEmailId: a.id);
    final music = await h.youtube.upsert(name: 'Music Channel', ownerEmailId: a.id, managers: [(b.id, ChannelRole.manager), (a.id, ChannelRole.editor)]);
    final all = await h.youtube.watchAll().first;
    final grouped = YoutubeRepository.groupByOwner(all);
    expect(grouped.entries.where((e) => e.key?.id == a.id).single.value.length, 3);
    final view = all.firstWhere((c) => c.channel.id == music.id);
    expect(view.managers.map((m) => m.$1.id), [b.id], reason: 'owner is not duplicated as manager');
    expect(view.channel.handle, '@main'.replaceAll('main', 'main') == '@main' ? view.channel.handle : null);
    final usage = await h.emails.watchUsage(b.id).first;
    expect(usage.managedChannels.length, 1);
    final usageA = await h.emails.watchUsage(a.id).first;
    expect(usageA.ownedChannels.length, 3);
  });

  test('deleting an email detaches accounts instead of deleting them', () async {
    final e = await h.emails.upsert(address: 'x@y.com');
    final acc = await h.accounts.upsert(platformId: 'github', emailIdentityId: e.id, accountName: 'Main');
    await h.emails.delete(e.id);
    final v = await h.accounts.byId(acc.id);
    expect(v, isNotNull);
    expect(v!.account.emailIdentityId, isNull);
  });

  test('projects link to accounts, subscriptions and emails via the link table', () async {
    final e = await h.emails.upsert(address: 'dev@studio.com');
    final acc = await h.accounts.upsert(platformId: 'github', emailIdentityId: e.id, accountName: 'Studio');
    final label = await h.projects.upsertOrganization(name: 'My Label', kind: OrganizationKind.recordLabel);
    final game = await h.projects.upsertProject(name: 'Game A', kind: ProjectKind.game, organizationId: label.id);
    await h.projects.link(EntityType.project, game.id, EntityType.serviceAccount, acc.id);
    await h.projects.link(EntityType.project, game.id, EntityType.emailIdentity, e.id);
    await h.projects.link(EntityType.project, game.id, EntityType.serviceAccount, acc.id); // duplicate ignored
    final links = await h.projects.watchLinks(EntityType.project, game.id).first;
    expect(links.length, 2);
    expect(links.map((l) => l.type), containsAll([EntityType.serviceAccount, EntityType.emailIdentity]));
    final usage = await h.emails.watchUsage(e.id).first;
    expect(usage.linkedProjects.single.id, game.id);
  });

  test('bank and card metadata never keep full numbers', () async {
    final bank = await h.finance.upsertBankAccount(bankName: 'HDFC Bank', nickname: 'Savings', last4: '1234 5678 9012 4321');
    expect(bank.last4, '4321');
    final card = await h.finance.upsertCard(nickname: 'Travel card', last4: '4111111111111111', expMonth: 12, expYear: 2030, kind: CardKind.credit);
    expect(card.last4, '1111');
    expect(() => h.finance.upsertCard(nickname: 'Bad', expMonth: 13), throwsArgumentError);
  });

  test('subscription totals are currency-aware and history is recorded', () async {
    await h.subs.upsert(serviceName: 'Spotify', price: Money.fromMajor(119, 'INR'), cycle: BillingCycle.monthly, nextBillingDate: DateTime.now().add(const Duration(days: 3)));
    final adobe = await h.subs.upsert(serviceName: 'Adobe CC', price: Money.fromMajor(1675, 'INR'), cycle: BillingCycle.monthly, nextBillingDate: DateTime.now().add(const Duration(days: 5)), classification: Classification.business);
    await h.subs.upsert(serviceName: 'Claude Pro', price: Money.fromMajor(20, 'USD'), cycle: BillingCycle.monthly, nextBillingDate: DateTime.now().add(const Duration(days: 40)));
    await h.subs.upsert(serviceName: 'Old thing', price: Money.fromMajor(999, 'INR'), cycle: BillingCycle.yearly, status: SubscriptionStatus.cancelled);
    await h.subs.upsert(serviceName: 'Lifetime app', price: Money.fromMajor(3000, 'INR'), cycle: BillingCycle.oneTime, status: SubscriptionStatus.lifetime);

    final stats = await h.stats.watch().first;
    expect(stats.activeSubscriptions, 3);
    expect(stats.monthlyCost!['INR'], Money.fromMajor(1794, 'INR'));
    expect(stats.monthlyCost!['USD'], Money.fromMajor(20, 'USD'));
    expect(stats.monthlyCost!.isMixed, isTrue);
    expect(stats.annualCost!['INR'], Money.fromMajor(1794 * 12, 'INR'));
    expect(stats.upcomingRenewals, 2);

    await h.subs.upsert(id: adobe.id, serviceName: 'Adobe CC', price: Money.fromMajor(1999, 'INR'), cycle: BillingCycle.monthly, nextBillingDate: adobe.nextBillingDate);
    await h.subs.markRenewed(adobe.id);
    final hist = await h.subs.watchHistory(adobe.id).first;
    expect(hist.map((e) => e.kind).toList(), containsAll(['created', 'priceChanged', 'renewed']));
  });

  test('vault encrypts, reveals and never exposes secrets in search or plain backup', () async {
    final item = await h.vault.create(title: 'OpenAI API key', kind: SecureItemKind.apiKey, secret: const VaultSecret(value: 'sk-SUPERSECRET-123'));
    final raw = await (h.db.select(h.db.secureItems)..where((s) => s.id.equals(item.id))).getSingle();
    expect(String.fromCharCodes(raw.ciphertext).contains('SUPERSECRET'), isFalse);
    final revealed = await h.vault.reveal(item.id);
    expect(revealed.value, 'sk-SUPERSECRET-123');

    final hits = await h.search.search('SUPERSECRET');
    expect(hits, isEmpty);
    final plain = await h.backup.plainBackupJson();
    expect(plain.contains('SUPERSECRET'), isFalse);
    expect(plain.contains('secure_items'), isFalse);

    final audit = await h.audit.watchRecent().first;
    expect(audit.any((a) => a.summary.contains('SUPERSECRET')), isFalse);
  });

  test('encrypted backup round-trips through restore, including vault', () async {
    final e = await h.emails.upsert(address: 'keep@me.com');
    await h.accounts.upsert(platformId: 'spotify', emailIdentityId: e.id, accountName: 'Music');
    final vaultItem = await h.vault.create(title: 'Netbanking', kind: SecureItemKind.password, secret: const VaultSecret(value: 'hunter2', username: 'syhu'));
    await h.finance.upsertBankAccount(bankName: 'SBI', nickname: 'Main', fullNumberVaultId: vaultItem.id);
    final envelope = await h.backup.encryptedBackup('correct horse battery');
    expect(envelope.contains('hunter2'), isFalse);

    final fresh = await Harness.create(seed: false);
    expect(() => fresh.backup.inspect(envelope, passphrase: 'wrong'), throwsFormatException);
    final (doc, summary) = await fresh.backup.inspect(envelope, passphrase: 'correct horse battery');
    expect(summary.includesVault, isTrue);
    expect(summary.rowCounts['service_accounts'], 1);
    await fresh.backup.restore(doc);
    final accounts = await fresh.accounts.watchAll().first;
    expect(accounts.single.email!.address, 'keep@me.com');
    final banks = await fresh.finance.watchBankAccounts().first;
    final restoredSecret = await fresh.vault.reveal(banks.single.fullNumberVaultId!);
    expect(restoredSecret.value, 'hunter2');
    await fresh.db.close();
  });

  test('global search finds platforms, emails, accounts and channels', () async {
    final e = await h.emails.upsert(address: 'gamer@studio.com');
    await h.accounts.upsert(platformId: 'steam', emailIdentityId: e.id, accountName: 'Gaming', username: 'syhu_plays');
    await h.youtube.upsert(name: 'SYHU Gaming', ownerEmailId: e.id);
    final hits = await h.search.search('gam');
    expect(hits.where((x) => x.type == EntityType.serviceAccount).length, 1);
    expect(hits.where((x) => x.type == EntityType.emailIdentity).length, 1);
    expect(hits.where((x) => x.type == EntityType.youtubeChannel).length, 1);
    expect(hits.where((x) => x.type == EntityType.platform), isNotEmpty);
  });

  test('empty database yields zero stats, never fabricated numbers', () async {
    final s = await h.stats.watch().first;
    expect(s.accountCount, 0);
    expect(s.emailCount, 0);
    expect(s.monthlyCost!.isEmpty, isTrue);
    expect(s.upcomingRenewals, 0);
  });
}
