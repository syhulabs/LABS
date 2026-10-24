import 'dart:convert';

List<String> decodeStringList(String? json) {
  if (json == null || json.isEmpty) return const [];
  final v = jsonDecode(json);
  return v is List ? v.map((e) => e.toString()).toList() : const [];
}

String encodeStringList(Iterable<String> values) => jsonEncode(values.toList());
