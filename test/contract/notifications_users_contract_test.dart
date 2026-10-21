import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart';
import 'package:estate_app/features/auth/models/auth_gate_state.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/feedback/data/feedback_repository.dart';
import 'package:estate_app/features/feedback/models/bug_report.dart';
import 'package:estate_app/features/notifications/data/notifications_repository.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  group('notifications (GET /notifications/me)', () {
    test('reads type, read_at and the delivery id', () {
      final page = unwrapPage(loadPage('notifications', 'inbox_page'));
      expect(page.hasMore, isTrue);
      final items = page.items
          .cast<Map<String, dynamic>>()
          .map(NotificationItem.fromJson)
          .toList();
      expect(items[0].id, 'd-1001');
      expect(items[0].type, 'rent_due');
      expect(items[0].readAt, isNull);
      expect(items[0].data, {'route': '/collections'});
      expect(items[1].readAt, DateTime.utc(2026, 10, 2, 8));
      expect(items[1].type, isNull);
    });

    test('the last page is empty and ends the cursor', () {
      final page = unwrapPage(loadPage('notifications', 'inbox_last_page'));
      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('device register sends app_key estate and a DevicePlatform', () {
      final body = const DeviceRegistrationRequest(
        token: ' tok ',
        platform: DevicePlatform.android,
      ).toJson();
      expectValidBody('DeviceRegisterIn', body);
      expect(body['app_key'], 'estate');
      expect(body['platform'], 'android');
      expect(body['token'], 'tok');
    });
  });

  group('user profile', () {
    test('SelfUser reads full_name and profile_image_url', () {
      final profile = UserProfile.fromJson(
        loadFixture('users')['profile'] as Map<String, dynamic>,
      );
      expect(profile.id, 7);
      expect(profile.fullName, 'Asha Verma');
      expect(profile.avatarUrl, 'https://cdn.example.com/u7.webp');
      expect(profile.role, UserRole.user);
      expect(profile.displayName, 'Asha Verma');
    });

    test('auth gate reads stage and next_action', () {
      final gate = AuthGateState.fromJson(
        loadFixture('users')['auth_gate'] as Map<String, dynamic>,
      );
      expect(gate.stage, AuthGateStage.profileCompletion);
      expect(gate.nextAction, AuthGateNextAction.completeProfile);
      expect(gate.missingFields, ['full_name']);
    });

    test('identifier status channel and next step map to enums', () {
      final status =
          loadFixture('users')['identifier_status'] as Map<String, dynamic>;
      expect(
        IdentifierStatusChannel.fromJson(status['channel']),
        IdentifierStatusChannel.phone,
      );
      expect(
        IdentifierStatusNextStep.fromJson(status['next_step']),
        IdentifierStatusNextStep.otp,
      );
      expect(status['exists'], isTrue);
    });

    test('profile update sends no first_name, last_name, email or photo', () {
      final body = UserProfileUpdate(
        fullName: ' Asha Verma ',
        phone: '+919800000000',
        dateOfBirth: DateTime(1988, 4, 2),
      ).toJson();
      expectValidBody('UserUpdate', body);
      expect(body, {
        'full_name': 'Asha Verma',
        'phone': '+919800000000',
        'date_of_birth': '1988-04-02',
      });
    });
  });

  group('bug report', () {
    test('request body keys are declared and the required ones are sent', () {
      final body = const BugReportPayload(
        bugType: BugType.featureRequest,
        title: 'Add dark map',
        description: 'Please.',
        severity: BugSeverity.low,
      ).toJson();
      expectValidBody('BugReportCreate', body);
      expect(body['bug_type'], 'feature_request');
      expect(body['severity'], 'low');
    });

    test('response parses', () {
      final report = BugReport.fromJson(
        loadFixture('users')['bug'] as Map<String, dynamic>,
      );
      expect(report.id, 3);
      expect(report.bugType, 'feature_request');
      expect(report.status, 'open');
    });
  });

  group('uploads', () {
    test('UploadResult reads public_url', () {
      final result = UploadResult.fromJson(
        loadFixture('uploads')['upload_result'] as Map<String, dynamic>,
      );
      expect(
        result.publicUrl,
        'https://res.example.com/ghar/uploads/7/abc.jpg',
      );
      expect(result.filePath, 'ghar/uploads/7/abc');
    });

    test('an upload body without public_url is a failure', () {
      expect(
        () => UploadResult.fromJson(const {'file_path': 'x'}),
        throwsA(isA<Object>()),
      );
    });
  });
}
