import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/applications/data/models/application_dto.dart';

abstract interface class ApplicationsRemoteDataSource {
  // Forms
  Future<List<ApplicationFormDto>> getApplicationForms({
    required int limit,
    required int offset,
    int? propertyId,
    bool? isActive,
  });

  Future<ApplicationFormDto> getApplicationFormById(int id);

  Future<ApplicationFormDto> getApplicationFormBySlug(String slug);

  Future<ApplicationFormDto> createApplicationForm(Map<String, dynamic> data);

  Future<ApplicationFormDto> updateApplicationForm(
    int id,
    Map<String, dynamic> data,
  );

  Future<void> deactivateApplicationForm(int id);

  // Applications
  Future<List<ApplicationDto>> getApplications({
    required int limit,
    required int offset,
    int? propertyId,
    int? formId,
    String? status,
  });

  Future<ApplicationDto> getApplicationById(int id);

  Future<ApplicationDto> reviewApplication(int id);

  Future<ApplicationDto> approveApplication(int id, {String? notes});

  Future<ApplicationDto> rejectApplication(int id, {String? notes});
}

final class ApiApplicationsRemoteDataSource
    implements ApplicationsRemoteDataSource {
  ApiApplicationsRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ApplicationFormDto>> getApplicationForms({
    required int limit,
    required int offset,
    int? propertyId,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (isActive != null) 'is_active': isActive,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/applications/forms',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items =
        data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [];

    return items
        .map((e) => ApplicationFormDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ApplicationFormDto> getApplicationFormById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/applications/forms/$id',
    );

    final data = response.data!;
    final form = data['data'] as Map<String, dynamic>? ?? data;

    return ApplicationFormDto.fromJson(form);
  }

  @override
  Future<ApplicationFormDto> getApplicationFormBySlug(String slug) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/public/applications/forms/$slug',
    );

    final data = response.data!;
    final form = data['data'] as Map<String, dynamic>? ?? data;

    return ApplicationFormDto.fromJson(form);
  }

  @override
  Future<ApplicationFormDto> createApplicationForm(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/applications/forms',
      data: data,
    );

    final responseData = response.data!;
    final form = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return ApplicationFormDto.fromJson(form);
  }

  @override
  Future<ApplicationFormDto> updateApplicationForm(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/pm/applications/forms/$id',
      data: data,
    );

    final responseData = response.data!;
    final form = responseData['data'] as Map<String, dynamic>? ?? responseData;

    return ApplicationFormDto.fromJson(form);
  }

  @override
  Future<void> deactivateApplicationForm(int id) async {
    await _apiClient.patch<Map<String, dynamic>>(
      '/pm/applications/forms/$id',
      data: {'is_active': false},
    );
  }

  @override
  Future<List<ApplicationDto>> getApplications({
    required int limit,
    required int offset,
    int? propertyId,
    int? formId,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (propertyId != null) 'property_id': propertyId,
      if (formId != null) 'form_id': formId,
      if (status != null) 'status': status,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/applications',
      queryParameters: queryParams,
    );

    final data = response.data!;
    final items =
        data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [];

    return items
        .map((e) => ApplicationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ApplicationDto> getApplicationById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/applications/$id',
    );

    final data = response.data!;
    final application = data['data'] as Map<String, dynamic>? ?? data;

    return ApplicationDto.fromJson(application);
  }

  @override
  Future<ApplicationDto> reviewApplication(int id) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/applications/$id/review',
    );

    final data = response.data!;
    final application = data['data'] as Map<String, dynamic>? ?? data;

    return ApplicationDto.fromJson(application);
  }

  @override
  Future<ApplicationDto> approveApplication(int id, {String? notes}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/applications/$id/decision',
      data: {
        'decision': 'approved',
        if (notes != null) 'notes': notes,
      },
    );

    final data = response.data!;
    final application = data['data'] as Map<String, dynamic>? ?? data;

    return ApplicationDto.fromJson(application);
  }

  @override
  Future<ApplicationDto> rejectApplication(int id, {String? notes}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/pm/applications/$id/decision',
      data: {
        'decision': 'rejected',
        if (notes != null) 'notes': notes,
      },
    );

    final data = response.data!;
    final application = data['data'] as Map<String, dynamic>? ?? data;

    return ApplicationDto.fromJson(application);
  }
}
