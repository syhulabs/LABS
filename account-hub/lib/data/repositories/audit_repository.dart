import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../db/app_database.dart';

/// Non-secret activity trail. Callers must never pass secret values in
/// [summary]; it is shown in the UI and included in plain backups.
class AuditRepository {
  AuditRepository(this.db);
  final AppDatabase db;

  Future<void> log(String action, {EntityType? type, String? id, required String summary}) {
    return db.into(db.auditEvents).insert(AuditEventsCompanion.insert(
          action: action,
          entityType: Value(type?.name),
          entityId: Value(id),
          summary: summary,
        ));
  }

  Stream<List<AuditEvent>> watchRecent({int limit = 50}) {
    return (db.select(db.auditEvents)
          ..orderBy([(a) => OrderingTerm.desc(a.at)])
          ..limit(limit))
        .watch();
  }

  Future<void> clear() => db.delete(db.auditEvents).go();
}
