import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Loads `test/fixtures/api/<group>.json`. The fixtures are written by
/// `tool/api_fixtures.py` from the backend's own Pydantic response models, so
/// they carry every field, default and wire name the backend really sends.
Map<String, dynamic> loadFixture(String group) {
  final file = File('test/fixtures/api/$group.json');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

/// One CursorPage fixture: `{items, next_cursor, has_more, limit, total}`.
/// It throws when a key is missing, so it also works in a group body.
Map<String, dynamic> loadPage(String group, String name) {
  final page = loadFixture(group)[name] as Map<String, dynamic>;
  const keys = ['items', 'next_cursor', 'has_more', 'limit', 'total'];
  final missing = keys.where((key) => !page.containsKey(key)).toList();
  if (missing.isNotEmpty) {
    throw StateError('$group.$name is not a CursorPage: missing $missing');
  }
  return page;
}

List<Map<String, dynamic>> pageItems(Map<String, dynamic> page) => [
  for (final item in page['items'] as List<dynamic>)
    item as Map<String, dynamic>,
];

Map<String, dynamic> _requestSchemas() => loadFixture('request_schemas');

/// Checks a request body against the backend request schema `schema`:
/// every key the body sends is declared (unknown keys give 422), and every
/// required key is present.
void expectValidBody(String schema, Map<String, dynamic> body) {
  final spec = _requestSchemas()[schema] as Map<String, dynamic>?;
  expect(spec, isNotNull, reason: 'request_schemas.json has no $schema');
  final properties = (spec!['properties'] as List<dynamic>).cast<String>();
  final required = (spec['required'] as List<dynamic>).cast<String>();
  final unknown = body.keys.where((key) => !properties.contains(key)).toList();
  expect(
    unknown,
    isEmpty,
    reason: '$schema does not declare ${unknown.join(', ')} (422 on the wire)',
  );
  final missing = required.where((key) => !body.containsKey(key)).toList();
  expect(
    missing,
    isEmpty,
    reason: '$schema requires ${missing.join(', ')} (422 on the wire)',
  );
}
