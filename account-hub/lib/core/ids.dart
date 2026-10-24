import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Random v4 identifiers for all user-created rows.
String newId() => _uuid.v4();

/// Lower-cased, trimmed email used for uniqueness checks.
String normalizeEmail(String address) => address.trim().toLowerCase();

/// Slug for custom platforms: "My Studio Site" -> "custom-my-studio-site-ab12".
String customPlatformId(String name) {
  final base = name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return 'custom-${base.isEmpty ? 'platform' : base}-${_uuid.v4().substring(0, 4)}';
}
