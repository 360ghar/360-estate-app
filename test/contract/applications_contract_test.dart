import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  final fixtures = loadFixture('applications');

  group('application forms', () {
    test('owner form reads custom_fields, expires_at, property labels', () {
      final page = unwrapPage(loadPage('applications', 'forms_page'));
      final forms = page.items
          .cast<Map<String, dynamic>>()
          .map(ApplicationForm.fromJson)
          .toList();
      final form = forms.first;
      expect(form.id, 41);
      expect(form.slug, 'sector-51-abc');
      expect(form.isActive, isTrue);
      expect(form.propertyName, '2 BHK Sector 51');
      expect(form.expiresAt, DateTime.utc(2026, 12, 31, 18, 29, 59));
      expect(form.fields, hasLength(3));
      expect(form.fields![0].id, 'pets');
      expect(form.fields![0].fieldType, ApplicationFieldType.boolean);
      expect(form.fields![0].isRequired, isTrue);
      expect(form.fields![2].fieldType, ApplicationFieldType.select);
      expect(form.fields![2].options, ['Salaried', 'Self employed']);
      expect(forms[1].isActive, isFalse);
      expect(forms[1].fields, isNull);
    });

    test('public form renders the same questions and has no id', () {
      final form = ApplicationForm.fromJson(
        fixtures['public_form'] as Map<String, dynamic>,
      );
      expect(form.id, isNull);
      expect(form.slug, 'sector-51-abc');
      expect(form.propertyAddress, startsWith('Tower 1'));
      expect(form.fields!.map((f) => f.key), ['pets', 'job']);
      expect(form.fields![1].fieldType, ApplicationFieldType.select);
    });

    test('create sends custom_fields with ids, is_active and a UTC expiry', () {
      final body = ApplicationFormCreateRequest(
        title: ' Apply here ',
        propertyId: 1,
        description: 'Two bedroom flat',
        expiresAt: DateTime(2026, 12, 31),
        fields: const [
          ApplicationFormField(
            id: 'q1',
            label: 'Pets?',
            fieldType: ApplicationFieldType.boolean,
            isRequired: true,
          ),
          ApplicationFormField(
            id: 'q2',
            label: 'Job',
            fieldType: ApplicationFieldType.select,
            options: ['Salaried', 'Other'],
          ),
        ],
      ).toJson();
      expectValidBody('RentalApplicationFormCreate', body);
      expect(body['title'], 'Apply here');
      expect(body['is_active'], isTrue);
      expect(body['expires_at'], endsWith('Z'));
      expect(body['custom_fields'], [
        {
          'id': 'q1',
          'label': 'Pets?',
          'field_type': 'boolean',
          'is_required': true,
        },
        {
          'id': 'q2',
          'label': 'Job',
          'field_type': 'select',
          'is_required': false,
          'options': ['Salaried', 'Other'],
        },
      ]);
      expect(body.containsKey('questions'), isFalse);
    });
  });

  group('applications inbox', () {
    test('reads applicant_full_name, answers, application_data', () {
      final page = unwrapPage(loadPage('applications', 'inbox_page'));
      final items = page.items
          .cast<Map<String, dynamic>>()
          .map(ApplicationSubmission.fromJson)
          .toList();
      final first = items.first;
      expect(first.id, 301);
      expect(first.formId, 41);
      expect(first.applicantFullName, 'Karan Mehta');
      expect(first.applicantEmail, 'karan@example.com');
      expect(first.status, RentalApplicationStatus.applicant);
      expect(first.status!.label, 'Applicant');
      expect(first.answers, {'pets': true, 'job': 'Salaried'});
      expect(first.notes, 'Need parking');
      expect(first.propertyName, '2 BHK Sector 51');
      expect(items[1].status, RentalApplicationStatus.rejected);
      expect(items[1].decisionNotes, 'Income proof missing');
    });

    test('a decided application carries decision_notes and decision_at', () {
      final detail = ApplicationSubmission.fromJson(
        fixtures['detail'] as Map<String, dynamic>,
      );
      expect(detail.status, RentalApplicationStatus.approved);
      expect(detail.decisionNotes, 'Welcome');
      expect(detail.decisionAt, DateTime.utc(2026, 10, 2, 8));
    });

    test('decision sends decision and notes', () {
      final body = const ApplicationDecisionRequest(
        decision: ApplicationDecision.approved,
        notes: ' Welcome ',
      ).toJson();
      expectValidBody('RentalApplicationDecision', body);
      expect(body, {'decision': 'approved', 'notes': 'Welcome'});
    });
  });

  group('public submit', () {
    test('sends applicant_full_name, answers and application_data', () {
      final body = const PublicApplicationSubmitRequest(
        applicantFullName: ' Karan Mehta ',
        applicantEmail: 'karan@example.com',
        applicantPhone: '+919822223333',
        answers: {'pets': false, 'job': 'Salaried'},
        notes: ' Need parking ',
      ).toJson();
      expectValidBody('RentalApplicationSubmit', body);
      expect(body['applicant_full_name'], 'Karan Mehta');
      expect(body['answers'], {'pets': false, 'job': 'Salaried'});
      expect(body['application_data'], {'notes': 'Need parking'});
      expect(body.containsKey('applicant_name'), isFalse);
      expect(body.containsKey('custom_field_responses'), isFalse);
      expect(body.containsKey('notes'), isFalse);
    });

    test('reads the {id, status, submitted_at} result', () {
      final result = ApplicationSubmitted.fromJson(
        fixtures['submitted'] as Map<String, dynamic>,
      );
      expect(result.id, 301);
      expect(result.status, RentalApplicationStatus.applicant);
      expect(result.submittedAt, DateTime.utc(2026, 10, 1, 10, 15, 2));
    });
  });
}
