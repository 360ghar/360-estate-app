/// Centralized API paths. Base URL already includes `/api/v1`,
/// so all paths here are bare (never start with `/api/v1/`).
/// CI greps for `'/api/v1` literals in `lib/` to prevent double-prefix.
abstract final class ApiPaths {
  // Dashboard
  static const dashboardOverview = '/pm/dashboard/overview';
  static const dashboardActivity = '/pm/dashboard/activity';

  // Auth and the signed-in user
  static const identifierStatus = '/auth/identifier-status';
  static const lastMethod = '/auth/last-method';
  static const profile = '/users/profile';
  static const userMe = '/users/me';
  static const userAvatar = '/users/me/avatar';
  static const authState = '/users/me/auth-state';
  static const onboarding = '/users/me/onboarding';

  // Properties
  static const properties = '/pm/properties';
  static String property(int id) => '$properties/$id';
  static const amenities = '/amenities';

  // Leases
  static const leases = '/pm/leases';
  static String lease(int id) => '$leases/$id';
  static String leaseUploadSigned(int id) => '${lease(id)}/upload-signed';
  static String leaseRenew(int id) => '${lease(id)}/renew';
  static String leaseTerminate(int id) => '${lease(id)}/terminate';

  // Tenants
  static const tenants = '/pm/tenants';
  static String tenant(int userId) => '$tenants/$userId';

  // Collections
  static const rentCharges = '/pm/rent/charges';
  static const rentChargesGenerate = '/pm/rent/charges/generate';
  static const rentPayments = '/pm/rent/payments';

  // Maintenance
  static const maintenanceRequests = '/pm/maintenance/requests';
  static String maintenanceRequest(int id) => '$maintenanceRequests/$id';

  // Inspections
  static const inspections = '/pm/inspections';
  static String inspection(int id) => '$inspections/$id';
  static String inspectionSign(int id) => '${inspection(id)}/sign';

  // Expenses
  static const expenses = '/pm/expenses';
  static String expense(int id) => '$expenses/$id';

  // Documents
  static const documents = '/pm/documents';
  static const documentsUpload = '/pm/documents/upload';
  static String documentDownload(int id) => '$documents/$id/download';

  // Rental applications
  static const applicationForms = '/pm/applications/forms';
  static String applicationForm(int id) => '$applicationForms/$id';
  static const applications = '/pm/applications';
  static String application(int id) => '$applications/$id';
  static String applicationDecision(int id) => '${application(id)}/decision';
  static String publicApplication(String slug) =>
      '/pm/public/applications/$slug';
  static String publicApplicationSubmit(String slug) =>
      '${publicApplication(slug)}/submit';

  // Agents
  static const assignedAgent = '/agents/assigned';

  // Reports
  static const reports = '/pm/reports';

  // Notifications
  static const notificationsMe = '/notifications/me';
  static String notificationOpened(String deliveryId) =>
      '/notifications/deliveries/$deliveryId/opened';
  static const deviceRegister = '/notifications/devices/register';

  // General file upload (Cloudinary-backed).
  static const generalUpload = '/upload';

  // Support
  static const bugs = '/bugs';
}
