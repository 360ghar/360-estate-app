import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';

class ApplicationFormCreateRequest {
  const ApplicationFormCreateRequest({
    required this.propertyId,
    this.title,
    this.description,
    this.isActive = true,
    this.expiresAt,
    this.fields = const [],
  });

  final String propertyId;
  final String? title;
  final String? description;
  final bool isActive;
  final DateTime? expiresAt;
  final List<ApplicationFormField> fields;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'property_id': propertyId,
      'is_active': isActive,
      if (title != null && title!.trim().isNotEmpty) 'title': title!.trim(),
      if (description != null && description!.trim().isNotEmpty)
        'description': description!.trim(),
      if (expiresAt != null) 'expires_at': toApiDateOnly(expiresAt),
      if (fields.isNotEmpty)
        'custom_fields': fields
            .map(
              (field) => {
                if (field.label != null) 'label': field.label,
                if (field.fieldType != null) 'field_type': field.fieldType,
                if (field.isRequired != null) 'is_required': field.isRequired,
                if (field.options != null && field.options!.isNotEmpty)
                  'options': field.options,
              },
            )
            .toList(),
    };
    return payload;
  }
}

class ApplicationDecisionRequest {
  const ApplicationDecisionRequest({required this.decision, this.notes});

  final String decision;
  final String? notes;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'decision': decision};
    if (notes != null && notes!.trim().isNotEmpty) {
      payload['notes'] = notes!.trim();
    }
    return payload;
  }
}

class PublicApplicationSubmitRequest {
  const PublicApplicationSubmitRequest({
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPhone,
    this.responses = const {},
    this.notes,
  });

  final String applicantName;
  final String applicantEmail;
  final String applicantPhone;
  final Map<String, dynamic> responses;
  final String? notes;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'applicant_name': applicantName,
      'applicant_email': applicantEmail,
      'applicant_phone': applicantPhone,
      if (responses.isNotEmpty) 'custom_field_responses': responses,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
    return payload;
  }
}

class ApplicationsRepository {
  ApplicationsRepository(this._client);

  final ApiClient _client;

  Future<Page<ApplicationForm>> listFormsPage({
    required int page,
    required int limit,
  }) async {
    final response = await _client.get<dynamic>(
      '/pm/applications/forms',
      queryParameters: {
        'page': page,
        'limit': limit,
        'offset': (page - 1) * limit,
      },
    );
    final data = unwrapList(response.data);
    final items = data
        .whereType<Map<String, dynamic>>()
        .map(ApplicationForm.fromJson)
        .toList();
    return Page(
      items: items,
      page: page,
      limit: limit,
      hasMore: items.length >= limit,
    );
  }

  Future<ApplicationForm> fetchForm(String id) async {
    final response = await _client.get<dynamic>('/pm/applications/forms/$id');
    final data = unwrapMap(response.data);
    return ApplicationForm.fromJson(data);
  }

  Future<ApplicationForm> createForm(
    ApplicationFormCreateRequest request,
  ) async {
    final response = await _client.post<dynamic>(
      '/pm/applications/forms',
      data: request.toJson(),
    );
    final data = unwrapMap(response.data);
    return ApplicationForm.fromJson(data);
  }

  Future<Page<ApplicationSubmission>> listApplicationsPage({
    required int page,
    required int limit,
    String? status,
  }) async {
    final response = await _client.get<dynamic>(
      '/pm/applications/',
      queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'limit': limit,
        'offset': (page - 1) * limit,
      },
    );
    final data = unwrapList(response.data);
    final items = data
        .whereType<Map<String, dynamic>>()
        .map(ApplicationSubmission.fromJson)
        .toList();
    return Page(
      items: items,
      page: page,
      limit: limit,
      hasMore: items.length >= limit,
    );
  }

  Future<ApplicationSubmission> fetchApplication(String id) async {
    final response = await _client.get<dynamic>('/pm/applications/$id');
    final data = unwrapMap(response.data);
    return ApplicationSubmission.fromJson(data);
  }

  Future<ApplicationSubmission> decide(
    String id,
    ApplicationDecisionRequest request,
  ) async {
    final response = await _client.post<dynamic>(
      '/pm/applications/$id/decision',
      data: request.toJson(),
    );
    final data = unwrapMap(response.data);
    return ApplicationSubmission.fromJson(data);
  }

  Future<ApplicationForm> fetchPublicForm(String slug) async {
    final response = await _client.get<dynamic>('/pm/public/applications/$slug');
    final data = unwrapMap(response.data);
    return ApplicationForm.fromJson(data);
  }

  Future<void> submitPublicForm(
    String slug,
    PublicApplicationSubmitRequest request,
  ) async {
    await _client.post<dynamic>(
      '/pm/public/applications/$slug/submit',
      data: request.toJson(),
    );
  }
}
