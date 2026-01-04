import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/applications/data/models/application_dto.dart';

/// Remote data source for tenant applications.
/// NOTE: The PM applications endpoints (/pm/applications/*) do not yet exist in the backend.
/// This implementation provides graceful fallbacks until the PM module is added.
abstract interface class ApplicationsRemoteDataSource {
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
    Map<String, dynamic> updates,
  );

  Future<void> deactivateApplicationForm(int id);

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

/// Stub implementation that returns empty data since PM applications endpoints
/// are not available in the current backend.
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
    // NOTE: /pm/applications/forms endpoint does NOT exist
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    return [];
  }

  @override
  Future<ApplicationFormDto> getApplicationFormById(int id) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application forms are not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<ApplicationFormDto> getApplicationFormBySlug(String slug) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application forms are not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<ApplicationFormDto> createApplicationForm(
      Map<String, dynamic> data) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application form creation is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<ApplicationFormDto> updateApplicationForm(
    int id,
    Map<String, dynamic> updates,
  ) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application form update is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<void> deactivateApplicationForm(int id) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application form deactivation is not yet available. PM module pending backend implementation.',
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
    // NOTE: /pm/applications endpoint does NOT exist
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    return [];
  }

  @override
  Future<ApplicationDto> getApplicationById(int id) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application details are not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<ApplicationDto> reviewApplication(int id) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application review is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<ApplicationDto> approveApplication(int id, {String? notes}) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application approval is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<ApplicationDto> rejectApplication(int id, {String? notes}) async {
    print('[APPLICATIONS] WARNING: PM applications endpoint not available');
    throw UnsupportedError(
      'Application rejection is not yet available. PM module pending backend implementation.',
    );
  }
}
