/// Domain enumerations shared by the database layer, business logic and UI.
///
/// Values are persisted by their [name], so never rename a member without a
/// migration that rewrites stored rows.
library;

enum Classification {
  personal,
  business;

  String get label => switch (this) {
        Classification.personal => 'Personal',
        Classification.business => 'Business',
      };
}

enum AccountStatus {
  active,
  inactive,
  suspended,
  closed,
  pendingVerification;

  String get label => switch (this) {
        AccountStatus.active => 'Active',
        AccountStatus.inactive => 'Inactive',
        AccountStatus.suspended => 'Suspended',
        AccountStatus.closed => 'Closed',
        AccountStatus.pendingVerification => 'Pending verification',
      };
}

enum SubscriptionStatus {
  active,
  trial,
  paused,
  cancelled,
  expired,
  lifetime;

  String get label => switch (this) {
        SubscriptionStatus.active => 'Active',
        SubscriptionStatus.trial => 'Trial',
        SubscriptionStatus.paused => 'Paused',
        SubscriptionStatus.cancelled => 'Cancelled',
        SubscriptionStatus.expired => 'Expired',
        SubscriptionStatus.lifetime => 'Lifetime',
      };

  /// Whether the subscription currently costs money on a recurring basis.
  bool get isRecurringCost =>
      this == SubscriptionStatus.active || this == SubscriptionStatus.trial;
}

enum BillingCycle {
  weekly,
  monthly,
  quarterly,
  halfYearly,
  yearly,
  custom,
  oneTime;

  String get label => switch (this) {
        BillingCycle.weekly => 'Weekly',
        BillingCycle.monthly => 'Monthly',
        BillingCycle.quarterly => 'Quarterly',
        BillingCycle.halfYearly => 'Every 6 months',
        BillingCycle.yearly => 'Yearly',
        BillingCycle.custom => 'Custom (days)',
        BillingCycle.oneTime => 'One-time',
      };

  /// Billing periods per year. `null` for one-time payments and custom cycles
  /// (which need [cycleDays]).
  double? get periodsPerYear => switch (this) {
        BillingCycle.weekly => 52,
        BillingCycle.monthly => 12,
        BillingCycle.quarterly => 4,
        BillingCycle.halfYearly => 2,
        BillingCycle.yearly => 1,
        BillingCycle.custom => null,
        BillingCycle.oneTime => null,
      };
}

enum ProjectKind {
  app,
  game,
  website,
  song,
  release,
  story,
  comic,
  video,
  intellectualProperty,
  other;

  String get label => switch (this) {
        ProjectKind.app => 'App',
        ProjectKind.game => 'Game',
        ProjectKind.website => 'Website',
        ProjectKind.song => 'Song',
        ProjectKind.release => 'Release',
        ProjectKind.story => 'Story',
        ProjectKind.comic => 'Comic',
        ProjectKind.video => 'Video',
        ProjectKind.intellectualProperty => 'Intellectual property',
        ProjectKind.other => 'Other',
      };
}

enum ProjectStatus {
  idea,
  inProgress,
  released,
  paused,
  archived;

  String get label => switch (this) {
        ProjectStatus.idea => 'Idea',
        ProjectStatus.inProgress => 'In progress',
        ProjectStatus.released => 'Released',
        ProjectStatus.paused => 'Paused',
        ProjectStatus.archived => 'Archived',
      };
}

enum OrganizationKind {
  business,
  recordLabel,
  studio;

  String get label => switch (this) {
        OrganizationKind.business => 'Business',
        OrganizationKind.recordLabel => 'Record label',
        OrganizationKind.studio => 'Studio',
      };
}

enum ChannelRole {
  owner,
  manager,
  editor,
  viewer;

  String get label => switch (this) {
        ChannelRole.owner => 'Owner',
        ChannelRole.manager => 'Manager',
        ChannelRole.editor => 'Editor',
        ChannelRole.viewer => 'Viewer',
      };
}

enum CardKind {
  debit,
  credit,
  prepaid;

  String get label => switch (this) {
        CardKind.debit => 'Debit',
        CardKind.credit => 'Credit',
        CardKind.prepaid => 'Prepaid',
      };
}

enum PaymentMethodKind {
  card,
  bankAccount,
  upi,
  wallet,
  paypal,
  appStore,
  playStore,
  cash,
  other;

  String get label => switch (this) {
        PaymentMethodKind.card => 'Card',
        PaymentMethodKind.bankAccount => 'Bank account',
        PaymentMethodKind.upi => 'UPI',
        PaymentMethodKind.wallet => 'Wallet',
        PaymentMethodKind.paypal => 'PayPal',
        PaymentMethodKind.appStore => 'App Store billing',
        PaymentMethodKind.playStore => 'Google Play billing',
        PaymentMethodKind.cash => 'Cash',
        PaymentMethodKind.other => 'Other',
      };
}

enum SecureItemKind {
  password,
  apiKey,
  secureNote,
  recoveryCodes,
  bankAccountNumber,
  document,
  other;

  String get label => switch (this) {
        SecureItemKind.password => 'Password',
        SecureItemKind.apiKey => 'API key / token',
        SecureItemKind.secureNote => 'Secure note',
        SecureItemKind.recoveryCodes => 'Recovery codes',
        SecureItemKind.bankAccountNumber => 'Bank account number',
        SecureItemKind.document => 'Document',
        SecureItemKind.other => 'Other',
      };
}

/// Polymorphic entity discriminator used by tags, custom fields, links and
/// audit events. Persisted by [name].
enum EntityType {
  platform,
  emailIdentity,
  serviceAccount,
  youtubeChannel,
  project,
  organization,
  artist,
  bankAccount,
  paymentCard,
  paymentMethod,
  subscription,
  credentialReference,
  documentReference,
  secureItem;

  String get label => switch (this) {
        EntityType.platform => 'Platform',
        EntityType.emailIdentity => 'Email',
        EntityType.serviceAccount => 'Account',
        EntityType.youtubeChannel => 'YouTube channel',
        EntityType.project => 'Project',
        EntityType.organization => 'Organization',
        EntityType.artist => 'Artist',
        EntityType.bankAccount => 'Bank account',
        EntityType.paymentCard => 'Card',
        EntityType.paymentMethod => 'Payment method',
        EntityType.subscription => 'Subscription',
        EntityType.credentialReference => 'Credential reference',
        EntityType.documentReference => 'Document',
        EntityType.secureItem => 'Vault item',
      };
}

T enumFromName<T extends Enum>(List<T> values, String? name, T fallback) {
  if (name == null) return fallback;
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}
