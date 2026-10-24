import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/db/app_database.dart';

/// Single bank account (including archived) for the detail screen.
final bankAccountByIdProvider = StreamProvider.family<BankAccount?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.bankAccounts)..where((b) => b.id.equals(id))).watchSingleOrNull();
});

/// Archived bank accounts, cards and payment methods for "Show archived".
final archivedBankAccountsProvider = StreamProvider<List<BankAccount>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.bankAccounts)
        ..where((b) => b.archivedAt.isNotNull())
        ..orderBy([(b) => OrderingTerm.asc(b.nickname)]))
      .watch();
});

final archivedCardsProvider = StreamProvider<List<PaymentCard>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.paymentCards)
        ..where((c) => c.archivedAt.isNotNull())
        ..orderBy([(c) => OrderingTerm.asc(c.nickname)]))
      .watch();
});

const bankAccountTypes = <String>['Savings', 'Current', 'Salary', 'NRE', 'NRO', 'Fixed deposit', 'Business', 'Other'];
const cardNetworks = <String>['Visa', 'Mastercard', 'RuPay', 'American Express', 'Discover', 'Diners', 'JCB', 'UnionPay', 'Other'];
