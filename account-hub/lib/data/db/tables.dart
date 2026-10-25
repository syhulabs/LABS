// Drift table definitions for SYHU Account Hub.
//
// Design rules:
//  * One relational database for every section (no per-category stores).
//  * Text UUID primary keys so rows can be merged across devices later.
//  * Confidential values never live in these tables in plaintext: the only
//    secret-bearing table is [SecureItems], which stores AES-GCM ciphertext.
//  * Soft delete via `archivedAt` where users expect "archive / restore".
import 'package:drift/drift.dart';

mixin _Timestamps on Table {
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

mixin _Archivable on Table {
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

/// Catalog of platforms (seeded from assets/catalog/platforms.json) plus
/// user-created custom platforms. `inMyWorld` is the explicit user selection.
class Platforms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get categories => text()(); // JSON array of category ids
  TextColumn get website => text().nullable()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get platformType => text().withDefault(const Constant('service'))();
  TextColumn get vendor => text().nullable()(); // google | apple | microsoft
  TextColumn get iconSlug => text().nullable()(); // Simple Icons slug
  TextColumn get logoAsset => text().nullable()(); // assets/logos/<id>.png|svg
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get inMyWorld => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get addedToMyWorldAt => dateTime().nullable()();
  IntColumn get catalogVersion => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Reusable email identities. One row per address; referenced by many
/// accounts, channels and projects.
class EmailIdentities extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get address => text()();
  TextColumn get normalizedAddress => text().unique()();
  TextColumn get provider => text().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get purpose => text().nullable()();
  TextColumn get classification => text().withDefault(const Constant('personal'))();
  TextColumn get recoveryNotes => text().nullable()(); // non-secret hints only
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// A user's account on a platform. Many per platform; optionally bound to an
/// email identity. Secrets are referenced, never stored here.
class ServiceAccounts extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get platformId => text().references(Platforms, #id)();
  TextColumn get emailIdentityId =>
      text().nullable().references(EmailIdentities, #id)();
  TextColumn get accountName => text()(); // e.g. "Personal", "Studio"
  TextColumn get username => text().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get profileUrl => text().nullable()();
  TextColumn get purpose => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get classification => text().withDefault(const Constant('personal'))();
  TextColumn get plan => text().nullable()();
  TextColumn get billingCycle => text().nullable()();
  BoolColumn get isApiAccount => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastAccessedAt => dateTime().nullable()();
  TextColumn get credentialRefId =>
      text().nullable().references(CredentialReferences, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

/// YouTube channels. A Google identity can own many; a channel can be managed
/// by several identities (see [ChannelManagers]).
class YoutubeChannels extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get handle => text().nullable()();
  TextColumn get channelId => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get channelType => text().nullable()(); // main, gaming, music...
  TextColumn get purpose => text().nullable()();
  TextColumn get brandingNotes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get ownerEmailId =>
      text().nullable().references(EmailIdentities, #id)();
  TextColumn get artistId => text().nullable().references(Artists, #id)();
  TextColumn get organizationId =>
      text().nullable().references(Organizations, #id)();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ChannelManagers extends Table {
  TextColumn get channelId => text().references(YoutubeChannels, #id)();
  TextColumn get emailIdentityId => text().references(EmailIdentities, #id)();
  TextColumn get role => text().withDefault(const Constant('manager'))();

  @override
  Set<Column> get primaryKey => {channelId, emailIdentityId};
}

class Organizations extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()(); // business | label | studio
  TextColumn get description => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get primaryEmailId =>
      text().nullable().references(EmailIdentities, #id)();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Artists extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get genre => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get labelId => text().nullable().references(Organizations, #id)();
  TextColumn get primaryEmailId =>
      text().nullable().references(EmailIdentities, #id)();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Projects extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()(); // ProjectKind.name
  TextColumn get status => text().withDefault(const Constant('inProgress'))();
  TextColumn get description => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get organizationId =>
      text().nullable().references(Organizations, #id)();
  TextColumn get artistId => text().nullable().references(Artists, #id)();
  TextColumn get classification => text().withDefault(const Constant('personal'))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Generic relationship between two entities (project ↔ account, project ↔
/// subscription, email ↔ channel, account ↔ document ...).
class Links extends Table {
  TextColumn get id => text()();
  TextColumn get fromType => text()();
  TextColumn get fromId => text()();
  TextColumn get toType => text()();
  TextColumn get toId => text()();
  TextColumn get relation => text().withDefault(const Constant('related'))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {fromType, fromId, toType, toId, relation},
      ];
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  IntColumn get color => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class TagLinks extends Table {
  TextColumn get tagId => text().references(Tags, #id)();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();

  @override
  Set<Column> get primaryKey => {tagId, entityType, entityId};
}

/// Non-secret custom key/value fields on any entity.
class CustomFields extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get label => text()();
  TextColumn get value => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Bank metadata only. The full account number, if the user chooses to keep
/// it, lives encrypted in [SecureItems] (see `fullNumberVaultId`).
class BankAccounts extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get bankName => text()();
  TextColumn get platformId => text().nullable().references(Platforms, #id)();
  TextColumn get nickname => text()();
  TextColumn get holderName => text().nullable()();
  TextColumn get accountType => text().nullable()(); // savings, current...
  TextColumn get last4 => text().nullable()();
  TextColumn get ifsc => text().nullable()();
  TextColumn get branch => text().nullable()();
  TextColumn get swift => text().nullable()();
  TextColumn get routing => text().nullable()();
  TextColumn get netbankingUsername => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get organizationId =>
      text().nullable().references(Organizations, #id)();
  TextColumn get classification => text().withDefault(const Constant('personal'))();
  TextColumn get notes => text().nullable()();
  TextColumn get fullNumberVaultId =>
      text().nullable().references(SecureItems, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Payment card references. Never stores PAN, CVV or PINs.
class PaymentCards extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get nickname => text()();
  TextColumn get issuingBank => text().nullable()();
  TextColumn get network => text().nullable()(); // visa, mastercard, rupay...
  TextColumn get kind => text().withDefault(const Constant('debit'))();
  TextColumn get last4 => text().nullable()();
  IntColumn get expMonth => integer().nullable()();
  IntColumn get expYear => integer().nullable()();
  TextColumn get bankAccountId =>
      text().nullable().references(BankAccounts, #id)();
  TextColumn get classification => text().withDefault(const Constant('personal'))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PaymentMethods extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get kind => text()(); // PaymentMethodKind.name
  TextColumn get cardId => text().nullable().references(PaymentCards, #id)();
  TextColumn get bankAccountId =>
      text().nullable().references(BankAccounts, #id)();
  TextColumn get platformId => text().nullable().references(Platforms, #id)();
  TextColumn get identifierHint => text().nullable()(); // e.g. UPI handle
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Subscriptions extends Table with _Timestamps, _Archivable {
  TextColumn get id => text()();
  TextColumn get platformId => text().nullable().references(Platforms, #id)();
  TextColumn get serviceName => text()();
  TextColumn get accountId =>
      text().nullable().references(ServiceAccounts, #id)();
  TextColumn get plan => text().nullable()();
  IntColumn get priceMinor => integer().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get billingCycle => text().withDefault(const Constant('monthly'))();
  IntColumn get cycleDays => integer().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get nextBillingDate => dateTime().nullable()();
  DateTimeColumn get cancellationDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get paymentMethodId =>
      text().nullable().references(PaymentMethods, #id)();
  TextColumn get classification => text().withDefault(const Constant('personal'))();
  TextColumn get renewalUrl => text().nullable()();
  BoolColumn get remindersEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  /// Where the subscription is billed: web | ios | android (PurchaseChannel).
  /// Null for rows created before schema v2.
  TextColumn get purchaseChannel => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SubscriptionEvents extends Table {
  TextColumn get id => text()();
  TextColumn get subscriptionId => text().references(Subscriptions, #id)();
  DateTimeColumn get at => dateTime().clientDefault(DateTime.now)();
  TextColumn get kind => text()(); // created, renewed, priceChanged, statusChanged, note
  TextColumn get details => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Pointer to where a credential lives (1Password item, Bitwarden, iCloud
/// Keychain...). Optionally points at a vault item if the user stores the
/// secret in-app.
class CredentialReferences extends Table with _Timestamps {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get manager => text().nullable()();
  TextColumn get locator => text().nullable()(); // deep link / item name
  TextColumn get usernameHint => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get vaultItemId => text().nullable().references(SecureItems, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

class DocumentReferences extends Table with _Timestamps {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get locator => text()(); // file path or URL
  TextColumn get kind => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Encrypted vault. `ciphertext` = AES-GCM(ciphertext || tag) with a per-item
/// random nonce, keyed by a master key held in the OS keychain.
class SecureItems extends Table with _Timestamps {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get kind => text()(); // SecureItemKind.name
  BlobColumn get ciphertext => blob()();
  BlobColumn get nonce => blob()();
  TextColumn get keyId => text().withDefault(const Constant('v1'))();
  DateTimeColumn get lastViewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Non-secret activity trail (what changed, never the secret values).
class AuditEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime().clientDefault(DateTime.now)();
  TextColumn get action => text()();
  TextColumn get entityType => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get summary => text()();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()(); // JSON-encoded

  @override
  Set<Column> get primaryKey => {key};
}
