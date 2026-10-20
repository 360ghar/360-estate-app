import 'package:dio/dio.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/dio_failure_mapper.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

DioException _error(
  int status,
  Object? body, {
  Map<String, List<String>>? headers,
}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: body,
      headers: Headers.fromMap(headers ?? const {}),
    ),
  );
}

void main() {
  final errors = loadFixture('errors');
  const mapper = DioFailureMapper();

  group('error envelope', () {
    test('404 reads error.message and error.code', () {
      final failure = mapper.map(
        _error(404, errors['not_found']),
        isOffline: false,
      );
      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'Lease not found');
      expect(failure.code, 'NOT_FOUND');
    });

    test('422 reads error.details.fields into field messages', () {
      final failure =
          mapper.map(_error(422, errors['validation']), isOffline: false)
              as ValidationFailure;
      expect(failure.code, 'VALIDATION_ERROR');
      expect(failure.message, 'Request validation failed');
      // The source prefix (body.) is dropped from the key.
      expect(failure.fields, {
        'monthly_rent': 'Input should be greater than 0',
        'start_date': 'Field required',
      });
    });

    test('422 with an empty fields list still gives the envelope message', () {
      final failure =
          mapper.map(_error(422, errors['invalid_cursor']), isOffline: false)
              as ValidationFailure;
      expect(failure.code, 'INVALID_CURSOR');
      expect(failure.fields, isEmpty);
    });

    test('400 keeps the backend message for the user', () {
      final failure = mapper.map(
        _error(400, errors['bad_request']),
        isOffline: false,
      );
      expect(failure, isA<ValidationFailure>());
      expect(
        failure.message,
        'Payment amount (900.00) exceeds outstanding balance (500.00)',
      );
    });

    test('429 carries Retry-After', () {
      final failure =
          mapper.map(
                _error(
                  429,
                  errors['rate_limited'],
                  headers: {
                    'retry-after': ['60'],
                  },
                ),
                isOffline: false,
              )
              as ApiFailure;
      expect(failure.code, 'RATE_LIMITED');
      expect(failure.error.retryAfterSeconds, 60);
      // The screen tells the user when to try again.
      expect(
        userFacingMessage(failure),
        'Too many requests\nTry again in 60 seconds.',
      );
    });

    test('a body without the envelope gets a fixed message', () {
      final failure = mapper.map(
        _error(404, '<html>nope</html>'),
        isOffline: false,
      );
      expect(failure.message, 'Not found');
      expect(failure.code, isNull);
    });

    test('the old FastAPI detail shape is not read', () {
      final failure =
          mapper.map(
                _error(422, {
                  'detail': [
                    {
                      'loc': ['body', 'x'],
                      'msg': 'bad',
                      'type': 't',
                    },
                  ],
                }),
                isOffline: false,
              )
              as ValidationFailure;
      expect(failure.fields, isEmpty);
      expect(failure.message, 'Invalid request');
    });
  });
}
