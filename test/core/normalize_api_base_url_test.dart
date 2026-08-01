import 'package:estate_app/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig.normalizeApiBaseUrl', () {
    test('appends /api/v1 when host-only', () {
      expect(
        AppConfig.normalizeApiBaseUrl('https://api.360ghar.com'),
        'https://api.360ghar.com/api/v1',
      );
    });

    test('keeps a single /api/v1 when already present', () {
      expect(
        AppConfig.normalizeApiBaseUrl('https://api.360ghar.com/api/v1'),
        'https://api.360ghar.com/api/v1',
      );
    });

    test('collapses double /api/v1 prefix', () {
      expect(
        AppConfig.normalizeApiBaseUrl('https://api.360ghar.com/api/v1/api/v1'),
        'https://api.360ghar.com/api/v1',
      );
    });

    test('strips trailing slashes before suffixing', () {
      expect(
        AppConfig.normalizeApiBaseUrl('https://api.360ghar.com/'),
        'https://api.360ghar.com/api/v1',
      );
    });
  });
}
