import 'package:estate_app/core/network/jwt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Jwt', () {
    // A valid JWT with known payload structure.
    // Header: {"alg":"HS256","typ":"JWT"}
    // Payload: {"sub":"123","name":"Test","iat":1516239022,"exp":9999999999}
    // (Signature is not verified — Jwt does not verify signatures)
    const validToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJzdWIiOiIxMjMiLCJuYW1lIjoiVGVzdCIsImlhdCI6MTUxNjIzOTAyMiwiZXhwIjo5OTk5OTk5OTk5fQ.'
        'signature';

    const expiredToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJzdWIiOiIxMjMiLCJleHAiOjF9.'
        'signature';

    test('decodePayload returns parsed payload', () {
      final payload = Jwt.decodePayload(validToken);
      expect(payload, isNotNull);
      expect(payload!['sub'], '123');
      expect(payload['name'], 'Test');
      expect(payload['exp'], 9999999999);
    });

    test('decodePayload returns null for malformed token', () {
      expect(Jwt.decodePayload('not-a-jwt'), isNull);
      expect(Jwt.decodePayload('a.b'), isNull);
    });

    test('expSeconds returns the exp claim', () {
      expect(Jwt.expSeconds(validToken), 9999999999);
      expect(Jwt.expSeconds(expiredToken), 1);
      expect(Jwt.expSeconds('no-dot'), isNull);
    });

    test('isExpired returns true for expired tokens', () {
      expect(Jwt.isExpired(expiredToken), isTrue);
    });

    test('isExpired returns false for valid tokens', () {
      expect(Jwt.isExpired(validToken), isFalse);
    });

    test('isExpired returns false for tokens without exp', () {
      const noExpToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJzdWIiOiIxMjMifQ.'
          'signature';
      expect(Jwt.isExpired(noExpToken), isFalse);
    });

    test('formatExp returns a formatted ISO string', () {
      final formatted = Jwt.formatExp(validToken);
      expect(formatted, isNotNull);
      expect(formatted, contains('T')); // ISO-8601
    });

    test('formatExp returns null for tokens without exp', () {
      const noExpToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJzdWIiOiIxMjMifQ.'
          'signature';
      expect(Jwt.formatExp(noExpToken), isNull);
    });

    test('decodePayload handles non-String-typed Map values', () {
      // If the JWT body is decoded as a `Map<dynamic, dynamic>` (e.g. from
      // a non-standard Dart JSON decoder), it should still be handled.
      const tokenWithNumValues =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJzdWIiOjEyMywiZXhwIjo5OTk5OTk5OTk5fQ.'
          'signature';
      final payload = Jwt.decodePayload(tokenWithNumValues);
      expect(payload, isNotNull);
      expect(payload!['sub'], 123);
      expect(payload['exp'], 9999999999);
    });
  });
}
