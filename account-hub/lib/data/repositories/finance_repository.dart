import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';
import 'audit_repository.dart';

/// Bank accounts, payment cards and payment methods. Only metadata is kept
/// here; see [SecureItems] for the optional encrypted full account number.
class FinanceRepository {
  FinanceRepository(this.db, this.audit);
  final AppDatabase db;
  final AuditRepository audit;

  static final _digitsOnly = RegExp(r'\D');

  /// Keeps only the last four digits of whatever the user typed, so a full
  /// number can never land in the metadata table by accident.
  static String? last4Of(String? raw) {
    if (raw == null) return null;
    final d = raw.replaceAll(_digitsOnly, '');
    if (d.isEmpty) return null;
    return d.length <= 4 ? d : d.substring(d.length - 4);
  }

  // ---------- Bank accounts ----------
  Stream<List<BankAccount>> watchBankAccounts({bool includeArchived = false}) {
    final q = db.select(db.bankAccounts)..orderBy([(b) => OrderingTerm.asc(b.bankName), (b) => OrderingTerm.asc(b.nickname)]);
    if (!includeArchived) q.where((b) => b.archivedAt.isNull());
    return q.watch();
  }

  Future<BankAccount> upsertBankAccount({
    String? id,
    required String bankName,
    String? platformId,
    required String nickname,
    String? holderName,
    String? accountType,
    String? last4,
    String? ifsc,
    String? branch,
    String? swift,
    String? routing,
    String? netbankingUsername,
    String? website,
    String currency = 'INR',
    String? organizationId,
    Classification classification = Classification.personal,
    String? notes,
    String? fullNumberVaultId,
  }) async {
    if (bankName.trim().isEmpty || nickname.trim().isEmpty) throw ArgumentError('Bank name and nickname are required');
    final rowId = id ?? newId();
    final c = BankAccountsCompanion(
      id: Value(rowId),
      bankName: Value(bankName.trim()),
      platformId: Value(platformId),
      nickname: Value(nickname.trim()),
      holderName: Value(_clean(holderName)),
      accountType: Value(_clean(accountType)),
      last4: Value(last4Of(last4)),
      ifsc: Value(_clean(ifsc)?.toUpperCase()),
      branch: Value(_clean(branch)),
      swift: Value(_clean(swift)?.toUpperCase()),
      routing: Value(_clean(routing)),
      netbankingUsername: Value(_clean(netbankingUsername)),
      website: Value(_clean(website)),
      currency: Value(currency),
      organizationId: Value(organizationId),
      classification: Value(classification.name),
      notes: Value(_clean(notes)),
      fullNumberVaultId: Value(fullNumberVaultId),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.bankAccounts).insert(c);
    } else {
      await (db.update(db.bankAccounts)..where((b) => b.id.equals(id))).write(c);
    }
    await audit.log(id == null ? 'bank.create' : 'bank.update', type: EntityType.bankAccount, id: rowId, summary: '${id == null ? 'Added' : 'Updated'} bank account "${nickname.trim()}"');
    return (db.select(db.bankAccounts)..where((b) => b.id.equals(rowId))).getSingle();
  }

  Future<void> setBankArchived(String id, bool archived) =>
      (db.update(db.bankAccounts)..where((b) => b.id.equals(id))).write(BankAccountsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));

  Future<void> deleteBankAccount(String id) async {
    await db.transaction(() async {
      await (db.update(db.paymentCards)..where((c) => c.bankAccountId.equals(id))).write(const PaymentCardsCompanion(bankAccountId: Value(null)));
      await (db.update(db.paymentMethods)..where((m) => m.bankAccountId.equals(id))).write(const PaymentMethodsCompanion(bankAccountId: Value(null)));
      await _deleteLinksFor(EntityType.bankAccount, id);
      await (db.delete(db.bankAccounts)..where((b) => b.id.equals(id))).go();
    });
    await audit.log('bank.delete', type: EntityType.bankAccount, id: id, summary: 'Deleted bank account');
  }

  // ---------- Cards ----------
  Stream<List<PaymentCard>> watchCards({bool includeArchived = false}) {
    final q = db.select(db.paymentCards)..orderBy([(c) => OrderingTerm.asc(c.nickname)]);
    if (!includeArchived) q.where((c) => c.archivedAt.isNull());
    return q.watch();
  }

  Future<PaymentCard> upsertCard({
    String? id,
    required String nickname,
    String? issuingBank,
    String? network,
    CardKind kind = CardKind.debit,
    String? last4,
    int? expMonth,
    int? expYear,
    String? bankAccountId,
    Classification classification = Classification.personal,
    String? notes,
  }) async {
    if (nickname.trim().isEmpty) throw ArgumentError('Card nickname is required');
    if (expMonth != null && (expMonth < 1 || expMonth > 12)) throw ArgumentError('Expiry month must be 1-12');
    final rowId = id ?? newId();
    final c = PaymentCardsCompanion(
      id: Value(rowId),
      nickname: Value(nickname.trim()),
      issuingBank: Value(_clean(issuingBank)),
      network: Value(_clean(network)),
      kind: Value(kind.name),
      last4: Value(last4Of(last4)),
      expMonth: Value(expMonth),
      expYear: Value(expYear),
      bankAccountId: Value(bankAccountId),
      classification: Value(classification.name),
      notes: Value(_clean(notes)),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.paymentCards).insert(c);
    } else {
      await (db.update(db.paymentCards)..where((x) => x.id.equals(id))).write(c);
    }
    await audit.log(id == null ? 'card.create' : 'card.update', type: EntityType.paymentCard, id: rowId, summary: '${id == null ? 'Added' : 'Updated'} card "${nickname.trim()}"');
    return (db.select(db.paymentCards)..where((x) => x.id.equals(rowId))).getSingle();
  }

  Future<void> setCardArchived(String id, bool archived) =>
      (db.update(db.paymentCards)..where((c) => c.id.equals(id))).write(PaymentCardsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));

  Future<void> deleteCard(String id) async {
    await db.transaction(() async {
      await (db.update(db.paymentMethods)..where((m) => m.cardId.equals(id))).write(const PaymentMethodsCompanion(cardId: Value(null)));
      await _deleteLinksFor(EntityType.paymentCard, id);
      await (db.delete(db.paymentCards)..where((c) => c.id.equals(id))).go();
    });
    await audit.log('card.delete', type: EntityType.paymentCard, id: id, summary: 'Deleted card');
  }

  // ---------- Payment methods ----------
  Stream<List<PaymentMethod>> watchPaymentMethods({bool includeArchived = false}) {
    final q = db.select(db.paymentMethods)..orderBy([(m) => OrderingTerm.desc(m.isDefault), (m) => OrderingTerm.asc(m.label)]);
    if (!includeArchived) q.where((m) => m.archivedAt.isNull());
    return q.watch();
  }

  Future<PaymentMethod> upsertPaymentMethod({
    String? id,
    required String label,
    required PaymentMethodKind kind,
    String? cardId,
    String? bankAccountId,
    String? platformId,
    String? identifierHint,
    bool isDefault = false,
    String? notes,
  }) async {
    if (label.trim().isEmpty) throw ArgumentError('Label is required');
    final rowId = id ?? newId();
    final c = PaymentMethodsCompanion(
      id: Value(rowId),
      label: Value(label.trim()),
      kind: Value(kind.name),
      cardId: Value(cardId),
      bankAccountId: Value(bankAccountId),
      platformId: Value(platformId),
      identifierHint: Value(_clean(identifierHint)),
      isDefault: Value(isDefault),
      notes: Value(_clean(notes)),
      updatedAt: Value(DateTime.now()),
    );
    await db.transaction(() async {
      if (isDefault) {
        await db.update(db.paymentMethods).write(const PaymentMethodsCompanion(isDefault: Value(false)));
      }
      if (id == null) {
        await db.into(db.paymentMethods).insert(c);
      } else {
        await (db.update(db.paymentMethods)..where((m) => m.id.equals(id))).write(c);
      }
    });
    return (db.select(db.paymentMethods)..where((m) => m.id.equals(rowId))).getSingle();
  }

  Future<void> deletePaymentMethod(String id) async {
    await db.transaction(() async {
      await (db.update(db.subscriptions)..where((s) => s.paymentMethodId.equals(id))).write(const SubscriptionsCompanion(paymentMethodId: Value(null)));
      await _deleteLinksFor(EntityType.paymentMethod, id);
      await (db.delete(db.paymentMethods)..where((m) => m.id.equals(id))).go();
    });
  }

  Future<void> _deleteLinksFor(EntityType type, String id) async {
    await (db.delete(db.links)..where((l) => (l.fromType.equals(type.name) & l.fromId.equals(id)) | (l.toType.equals(type.name) & l.toId.equals(id)))).go();
    await (db.delete(db.tagLinks)..where((t) => t.entityType.equals(type.name) & t.entityId.equals(id))).go();
    await (db.delete(db.customFields)..where((t) => t.entityType.equals(type.name) & t.entityId.equals(id))).go();
  }

  static String? _clean(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
