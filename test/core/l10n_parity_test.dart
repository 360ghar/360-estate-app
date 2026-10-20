import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every English string has a Hindi one, and no copy uses an em dash.
void main() {
  Map<String, Object?> arb(String lang) =>
      jsonDecode(File('lib/l10n/arb/app_$lang.arb').readAsStringSync())
          as Map<String, Object?>;

  test('app_hi.arb has every key in app_en.arb', () {
    final en = arb('en').keys.where((k) => !k.startsWith('@')).toSet();
    final hi = arb('hi').keys.where((k) => !k.startsWith('@')).toSet();
    expect(en.difference(hi), isEmpty);
  });

  test('no copy uses an em dash', () {
    for (final lang in ['en', 'hi']) {
      final dashed = [
        for (final e in arb(lang).entries)
          if (e.value is String && (e.value! as String).contains('—'))
            e.key,
      ];
      expect(dashed, isEmpty, reason: lang);
    }
  });
}
