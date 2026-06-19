import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';

abstract interface class ApplicationsRepository {
  // Application Forms
  Future<Page<ApplicationForm>> getApplicationForms({
    required String? cursor,
    required int limit,
    int? propertyId,
    bool? isActive,
  });

  Future<ApplicationForm> getApplicationFormById(int id);

  Future<ApplicationForm> getApplicationFormBySlug(String slug);

  Future<ApplicationForm> createApplicationForm({
    required int propertyId,
    List<ApplicationFormField>? customFields,
    DateTime? expiresAt,
  });

  Future<ApplicationForm> updateApplicationForm(
    int id,
    Map<String, dynamic> updates,
  );

  Future<void> deactivateApplicationForm(int id);

  // Applications (Submissions)
  Future<Page<Application>> getApplications({
    required String? cursor,
    required int limit,
    int? propertyId,
    int? formId,
    ApplicationStatus? status,
  });

  Future<Application> getApplicationById(int id);

  Future<Application> reviewApplication(int id);

  Future<Application> approveApplication(int id, {String? notes});

  Future<Application> rejectApplication(int id, {String? notes});
}
