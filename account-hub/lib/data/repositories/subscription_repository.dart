import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../domain/enums.dart';
import '../../domain/markets.dart';
import '../../domain/money.dart';
import '../../domain/subscription_math.dart';
import '../db/app_database.dart';
import 'audit_repository.dart';

class SubscriptionView {
  const SubscriptionView(this.sub, this.platform, this.paymentMethod);
  final Subscription sub;
  final Platform? platform;
  final PaymentMethod? paymentMethod;

  Money get price => Money(sub.priceMinor, sub.currency);
  BillingCycle get cycle => enumFromName(BillingCycle.values, sub.billingCycle, BillingCycle.monthly);
  SubscriptionStatus get status => enumFromName(SubscriptionStatus.values, sub.status, SubscriptionStatus.active);
  Classification get classification => enumFromName(Classification.values, sub.classification, Classification.personal);

  SubscriptionLike get like => SubscriptionLike(
        id: sub.id,
        price: price,
        cycle: cycle,
        cycleDays: sub.cycleDays,
        status: status,
        nextBillingDate: sub.nextBillingDate,
        classification: classification,
      );
}

class SubscriptionRepository {
  SubscriptionRepository(this.db, this.audit);
  final AppDatabase db;
  final AuditRepository audit;

  Stream<List<SubscriptionView>> watchAll({bool includeArchived = false}) {
    final q = db.select(db.subscriptions).join([
      leftOuterJoin(db.platforms, db.platforms.id.equalsExp(db.subscriptions.platformId)),
      leftOuterJoin(db.paymentMethods, db.paymentMethods.id.equalsExp(db.subscriptions.paymentMethodId)),
    ])
      ..orderBy([OrderingTerm.asc(db.subscriptions.nextBillingDate), OrderingTerm.asc(db.subscriptions.serviceName)]);
    if (!includeArchived) q.where(db.subscriptions.archivedAt.isNull());
    return q.watch().map((rows) => rows
        .map((r) => SubscriptionView(
              r.readTable(db.subscriptions),
              r.readTableOrNull(db.platforms),
              r.readTableOrNull(db.paymentMethods),
            ))
        .toList());
  }

  Stream<SubscriptionView?> watchById(String id) =>
      watchAll(includeArchived: true).map((l) => l.where((s) => s.sub.id == id).firstOrNull);

  Stream<List<SubscriptionEvent>> watchHistory(String subscriptionId) => (db.select(db.subscriptionEvents)
        ..where((e) => e.subscriptionId.equals(subscriptionId))
        ..orderBy([(e) => OrderingTerm.desc(e.at)]))
      .watch();

  Future<Subscription> upsert({
    String? id,
    String? platformId,
    required String serviceName,
    String? accountId,
    String? plan,
    required Money price,
    required BillingCycle cycle,
    int? cycleDays,
    DateTime? startDate,
    DateTime? nextBillingDate,
    DateTime? cancellationDate,
    SubscriptionStatus status = SubscriptionStatus.active,
    String? paymentMethodId,
    Classification classification = Classification.personal,
    String? renewalUrl,
    bool remindersEnabled = true,
    String? notes,
    PurchaseChannel? purchaseChannel,
  }) async {
    if (serviceName.trim().isEmpty) throw ArgumentError('Service name is required');
    if (cycle == BillingCycle.custom && (cycleDays == null || cycleDays <= 0)) throw ArgumentError('Custom cycle needs a number of days');
    if (price.minor < 0) throw ArgumentError('Price cannot be negative');
    final rowId = id ?? newId();
    final previous = id == null ? null : await (db.select(db.subscriptions)..where((s) => s.id.equals(id))).getSingleOrNull();
    final c = SubscriptionsCompanion(
      id: Value(rowId),
      platformId: Value(platformId),
      serviceName: Value(serviceName.trim()),
      accountId: Value(accountId),
      plan: Value(_clean(plan)),
      priceMinor: Value(price.minor),
      currency: Value(price.currency),
      billingCycle: Value(cycle.name),
      cycleDays: Value(cycle == BillingCycle.custom ? cycleDays : null),
      startDate: Value(startDate),
      nextBillingDate: Value(nextBillingDate),
      cancellationDate: Value(cancellationDate),
      status: Value(status.name),
      paymentMethodId: Value(paymentMethodId),
      classification: Value(classification.name),
      renewalUrl: Value(_clean(renewalUrl)),
      purchaseChannel: Value(purchaseChannel?.name),
      remindersEnabled: Value(remindersEnabled),
      notes: Value(_clean(notes)),
      updatedAt: Value(DateTime.now()),
    );
    await db.transaction(() async {
      if (id == null) {
        await db.into(db.subscriptions).insert(c);
        await _event(rowId, 'created', 'Created · ${price.format()} ${cycle.label.toLowerCase()} · ${status.label}');
      } else {
        await (db.update(db.subscriptions)..where((s) => s.id.equals(id))).write(c);
        if (previous != null) {
          if (previous.priceMinor != price.minor || previous.currency != price.currency) {
            await _event(rowId, 'priceChanged', '${Money(previous.priceMinor, previous.currency).format()} → ${price.format()}');
          }
          if (previous.status != status.name) {
            await _event(rowId, 'statusChanged', '${enumFromName(SubscriptionStatus.values, previous.status, SubscriptionStatus.active).label} → ${status.label}');
          }
          if (previous.plan != _clean(plan)) {
            await _event(rowId, 'planChanged', '${previous.plan ?? '—'} → ${_clean(plan) ?? '—'}');
          }
        }
      }
    });
    await audit.log(id == null ? 'subscription.create' : 'subscription.update', type: EntityType.subscription, id: rowId, summary: '${id == null ? 'Added' : 'Updated'} subscription "${serviceName.trim()}"');
    return (db.select(db.subscriptions)..where((s) => s.id.equals(rowId))).getSingle();
  }

  /// Marks the current period as paid and advances the next billing date.
  Future<void> markRenewed(String id, {DateTime? now}) async {
    final s = await (db.select(db.subscriptions)..where((x) => x.id.equals(id))).getSingle();
    final cycle = enumFromName(BillingCycle.values, s.billingCycle, BillingCycle.monthly);
    final base = s.nextBillingDate ?? (now ?? DateTime.now());
    final next = SubscriptionMath.nextDate(base, cycle, s.cycleDays);
    await (db.update(db.subscriptions)..where((x) => x.id.equals(id)))
        .write(SubscriptionsCompanion(nextBillingDate: Value(next), updatedAt: Value(DateTime.now())));
    await _event(id, 'renewed', 'Renewed · next ${_date(next)}');
  }

  Future<void> setStatus(String id, SubscriptionStatus status) async {
    final s = await (db.select(db.subscriptions)..where((x) => x.id.equals(id))).getSingle();
    if (s.status == status.name) return;
    await (db.update(db.subscriptions)..where((x) => x.id.equals(id))).write(SubscriptionsCompanion(
      status: Value(status.name),
      cancellationDate: Value(status == SubscriptionStatus.cancelled ? DateTime.now() : s.cancellationDate),
      updatedAt: Value(DateTime.now()),
    ));
    await _event(id, 'statusChanged', '${enumFromName(SubscriptionStatus.values, s.status, SubscriptionStatus.active).label} → ${status.label}');
  }

  Future<void> addNote(String id, String note) => _event(id, 'note', note.trim());

  Future<void> setArchived(String id, bool archived) =>
      (db.update(db.subscriptions)..where((s) => s.id.equals(id))).write(SubscriptionsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));

  Future<void> delete(String id) async {
    await db.transaction(() async {
      await (db.delete(db.subscriptionEvents)..where((e) => e.subscriptionId.equals(id))).go();
      await (db.delete(db.links)..where((l) => (l.fromType.equals(EntityType.subscription.name) & l.fromId.equals(id)) | (l.toType.equals(EntityType.subscription.name) & l.toId.equals(id)))).go();
      await (db.delete(db.tagLinks)..where((t) => t.entityType.equals(EntityType.subscription.name) & t.entityId.equals(id))).go();
      await (db.delete(db.customFields)..where((t) => t.entityType.equals(EntityType.subscription.name) & t.entityId.equals(id))).go();
      await (db.delete(db.subscriptions)..where((s) => s.id.equals(id))).go();
    });
    await audit.log('subscription.delete', type: EntityType.subscription, id: id, summary: 'Deleted subscription');
  }

  Future<void> _event(String subId, String kind, String details) => db.into(db.subscriptionEvents).insert(
        SubscriptionEventsCompanion.insert(id: newId(), subscriptionId: subId, kind: kind, details: Value(details)),
      );

  static String _date(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String? _clean(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
