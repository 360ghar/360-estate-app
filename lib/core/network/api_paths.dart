/// Centralized API paths. Base URL already includes `/api/v1`,
/// so all paths here are bare (never start with `/api/v1/`).
/// CI greps for `'/api/v1` literals in `lib/` to prevent double-prefix.
abstract final class ApiPaths {
  // Dashboard
  static const dashboardOverview = '/pm/dashboard/overview';
  static const dashboardActivity = '/pm/dashboard/activity';

  // Auth
  static const identifierStatus = '/auth/identifier-status';
  static const lastMethod = '/auth/last-method';
  static const profile = '/users/profile/';
  static const authState = '/users/me/auth-state';

  // Maintenance
  static const maintenanceRequests = '/pm/maintenance/requests';
  static String maintenanceRequest(String id) => '$maintenanceRequests/$id';

  // Tenants
  static const tenants = '/pm/tenants';

  // Properties
  static const properties = '/pm/properties';

  // Collections
  static const rentCharges = '/pm/rent/charges';
  static const rentPayments = '/pm/rent/payments';

  // Documents
  static const documents = '/pm/documents';
  static const documentsUpload = '/pm/documents/upload';

  // General file upload (avatars, Cloudinary-backed).
  static const generalUpload = '/upload';

  // Reports
  static const reports = '/pm/reports';
}
