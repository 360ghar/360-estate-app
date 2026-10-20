import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';

/// Body of `POST /pm/applications/forms` (`RentalApplicationFormCreate`).
/// `title` is required. The questions are `custom_fields`: each has an `id`
/// (the key of the answer), a `label` and a `field_type`.
class ApplicationFormCreateRequest {
  const ApplicationFormCreateRequest({
    required this.title,
    this.propertyId,
    this.description,
    this.isActive = true,
    this.expiresAt,
    this.fields = const [],
  });

  final String title;
  final int? propertyId;
  final String? description;
  final bool isActive;

  /// The last day the form accepts applications. The wire value is the end of
  /// that day as a UTC instant.
  final DateTime? expiresAt;
  final List<ApplicationFormField> fields;

  Map<String, dynamic> toJson() {
    final text = description?.trim();
    final expiry = expiresAt;
    return {
      'title': title.trim(),
      'is_active': isActive,
      if (propertyId != null) 'property_id': propertyId,
      if (text != null && text.isNotEmpty) 'description': text,
      if (expiry != null)
        'expires_at': toApiUtcInstant(
          DateTime(expiry.year, expiry.month, expiry.day, 23, 59, 59),
        ),
      if (fields.isNotEmpty)
        'custom_fields': [
          for (final field in fields)
            {
              'id': field.key,
              'label': field.label,
              if (field.fieldType != null) 'field_type': field.fieldType!.wire,
              'is_required': field.isRequired ?? false,
              if (field.options != null && field.options!.isNotEmpty)
                'options': field.options,
            },
        ],
    };
  }
}

/// Body of `POST /pm/applications/{id}/decision` (`RentalApplicationDecision`).
class ApplicationDecisionRequest {
  const ApplicationDecisionRequest({required this.decision, this.notes});

  final ApplicationDecision decision;
  final String? notes;

  Map<String, dynamic> toJson() {
    final text = notes?.trim();
    return {
      'decision': decision.wire,
      if (text != null && text.isNotEmpty) 'notes': text,
    };
  }
}

/// Body of `POST /pm/public/applications/{slug}/submit`
/// (`RentalApplicationSubmit`): `applicant_full_name`, `applicant_email`,
/// `applicant_phone`, `answers` (keyed by the form field id) and
/// `application_data` (the free note goes in `application_data.notes`).
class PublicApplicationSubmitRequest {
  const PublicApplicationSubmitRequest({
    required this.applicantFullName,
    required this.applicantEmail,
    required this.applicantPhone,
    this.answers = const {},
    this.notes,
  });

  final String applicantFullName;
  final String applicantEmail;
  final String applicantPhone;
  final Map<String, dynamic> answers;
  final String? notes;

  Map<String, dynamic> toJson() {
    final note = notes?.trim();
    return {
      'applicant_full_name': applicantFullName.trim(),
      'applicant_email': applicantEmail.trim(),
      'applicant_phone': applicantPhone.trim(),
      if (answers.isNotEmpty) 'answers': answers,
      if (note != null && note.isNotEmpty) 'application_data': {'notes': note},
    };
  }
}

class ApplicationsRepository {
  ApplicationsRepository(this._client);

  final ApiClient _client;

  Future<Page<ApplicationForm>> listFormsPage({
    required String? cursor,
    required int limit,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.applicationForms,
      ownerScoped: true,
      queryParameters: {if (cursor != null) 'cursor': cursor, 'limit': limit},
    );
    final page = unwrapPage(response.data);
    return Page(
      items: page.items
          .whereType<Map<String, dynamic>>()
          .map(ApplicationForm.fromJson)
          .toList(),
      limit: limit,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  Future<ApplicationForm> fetchForm(int id) async {
    final response = await _client.get<dynamic>(ApiPaths.applicationForm(id));
    return ApplicationForm.fromJson(unwrapMap(response.data));
  }

  Future<ApplicationForm> createForm(
    ApplicationFormCreateRequest request,
  ) async {
    final response = await _client.post<dynamic>(
      ApiPaths.applicationForms,
      data: request.toJson(),
      ownerScoped: true,
    );
    return ApplicationForm.fromJson(unwrapMap(response.data));
  }

  Future<Page<ApplicationSubmission>> listApplicationsPage({
    required String? cursor,
    required int limit,
    RentalApplicationStatus? status,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.applications,
      ownerScoped: true,
      queryParameters: {
        if (status != null) 'status': status.wire,
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
      },
    );
    final page = unwrapPage(response.data);
    return Page(
      items: page.items
          .whereType<Map<String, dynamic>>()
          .map(ApplicationSubmission.fromJson)
          .toList(),
      limit: limit,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
    );
  }

  Future<ApplicationSubmission> fetchApplication(int id) async {
    final response = await _client.get<dynamic>(ApiPaths.application(id));
    return ApplicationSubmission.fromJson(unwrapMap(response.data));
  }

  Future<ApplicationSubmission> decide(
    int id,
    ApplicationDecisionRequest request,
  ) async {
    final response = await _client.post<dynamic>(
      ApiPaths.applicationDecision(id),
      data: request.toJson(),
    );
    return ApplicationSubmission.fromJson(unwrapMap(response.data));
  }

  /// The public form of a slug. No sign-in is needed. A form that is inactive
  /// or expired gives 404.
  Future<ApplicationForm> fetchPublicForm(String slug) async {
    final response = await _client.get<dynamic>(
      ApiPaths.publicApplication(slug),
    );
    return ApplicationForm.fromJson(unwrapMap(response.data));
  }

  Future<ApplicationSubmitted> submitPublicForm(
    String slug,
    PublicApplicationSubmitRequest request,
  ) async {
    final response = await _client.post<dynamic>(
      ApiPaths.publicApplicationSubmit(slug),
      data: request.toJson(),
    );
    return ApplicationSubmitted.fromJson(unwrapMap(response.data));
  }
}
