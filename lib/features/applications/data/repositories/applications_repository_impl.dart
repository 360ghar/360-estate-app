import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/applications/data/datasources/applications_remote_data_source.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';
import 'package:estate_app/features/applications/domain/repositories/applications_repository.dart';

final class ApplicationsRepositoryImpl implements ApplicationsRepository {
  ApplicationsRepositoryImpl({required ApplicationsRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final ApplicationsRemoteDataSource _dataSource;

  @override
  Future<Page<ApplicationForm>> getApplicationForms({
    required int page,
    required int limit,
    int? propertyId,
    bool? isActive,
  }) async {
    final offset = (page - 1) * limit;
    final dtos = await _dataSource.getApplicationForms(
      limit: limit,
      offset: offset,
      propertyId: propertyId,
      isActive: isActive,
    );

    final forms = dtos.map((dto) => dto.toEntity()).toList();

    return Page(
      items: forms,
      page: page,
      limit: limit,
      hasMore: forms.length >= limit,
    );
  }

  @override
  Future<ApplicationForm> getApplicationFormById(int id) async {
    final dto = await _dataSource.getApplicationFormById(id);
    return dto.toEntity();
  }

  @override
  Future<ApplicationForm> getApplicationFormBySlug(String slug) async {
    final dto = await _dataSource.getApplicationFormBySlug(slug);
    return dto.toEntity();
  }

  @override
  Future<ApplicationForm> createApplicationForm({
    required int propertyId,
    List<ApplicationFormField>? customFields,
    DateTime? expiresAt,
  }) async {
    final data = <String, dynamic>{
      'property_id': propertyId,
      if (customFields != null && customFields.isNotEmpty)
        'custom_fields': customFields
            .map((f) => {
                  'label': f.label,
                  'field_type': f.fieldType,
                  'is_required': f.isRequired,
                  if (f.options.isNotEmpty) 'options': f.options,
                })
            .toList(),
      if (expiresAt != null)
        'expires_at': expiresAt.toIso8601String().split('T')[0],
    };

    final dto = await _dataSource.createApplicationForm(data);
    return dto.toEntity();
  }

  @override
  Future<ApplicationForm> updateApplicationForm(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final dto = await _dataSource.updateApplicationForm(id, updates);
    return dto.toEntity();
  }

  @override
  Future<void> deactivateApplicationForm(int id) async {
    await _dataSource.deactivateApplicationForm(id);
  }

  @override
  Future<Page<Application>> getApplications({
    required int page,
    required int limit,
    int? propertyId,
    int? formId,
    ApplicationStatus? status,
  }) async {
    final offset = (page - 1) * limit;
    final dtos = await _dataSource.getApplications(
      limit: limit,
      offset: offset,
      propertyId: propertyId,
      formId: formId,
      status: status?.apiValue,
    );

    final applications = dtos.map((dto) => dto.toEntity()).toList();

    return Page(
      items: applications,
      page: page,
      limit: limit,
      hasMore: applications.length >= limit,
    );
  }

  @override
  Future<Application> getApplicationById(int id) async {
    final dto = await _dataSource.getApplicationById(id);
    return dto.toEntity();
  }

  @override
  Future<Application> reviewApplication(int id) async {
    final dto = await _dataSource.reviewApplication(id);
    return dto.toEntity();
  }

  @override
  Future<Application> approveApplication(int id, {String? notes}) async {
    final dto = await _dataSource.approveApplication(id, notes: notes);
    return dto.toEntity();
  }

  @override
  Future<Application> rejectApplication(int id, {String? notes}) async {
    final dto = await _dataSource.rejectApplication(id, notes: notes);
    return dto.toEntity();
  }
}
