import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('getBool reads a bool, and a string an older build saved', () async {
    SharedPreferences.setMockInitialValues({
      'a': true,
      'b': 'true',
      'c': 'false',
      'd': 'yes',
    });
    final prefs = await AppPreferences.create();
    expect(prefs.getBool('a'), isTrue);
    expect(prefs.getBool('b'), isTrue);
    expect(prefs.getBool('c'), isFalse);
    expect(prefs.getBool('d'), isNull);
    expect(prefs.getBool('missing'), isNull);
  });
}
