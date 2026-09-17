import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/settings/presentation/pages/delete_account_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldFallbackToEmailOnDelete', () {
    test('NetworkFailure -> no mailto fallback (stay with offline snackbar)', () {
      expect(
        shouldFallbackToEmailOnDelete(
          const NetworkFailure('offline', isOffline: true),
        ),
        isFalse,
      );
    });

    test('online NetworkFailure (timeout) -> offer mailto fallback', () {
      expect(
        shouldFallbackToEmailOnDelete(
          const NetworkFailure('timeout'),
        ),
        isTrue,
      );
    });

    test('401 Unauthorized -> offer mailto fallback', () {
      expect(
        shouldFallbackToEmailOnDelete(const UnauthorizedFailure('401')),
        isTrue,
      );
    });

    test('404 NotFound -> offer mailto fallback', () {
      expect(
        shouldFallbackToEmailOnDelete(const NotFoundFailure('404')),
        isTrue,
      );
    });

    test('unknown error -> offer mailto fallback', () {
      expect(
        shouldFallbackToEmailOnDelete(const UnknownFailure('boom')),
        isTrue,
      );
    });
  });
}
