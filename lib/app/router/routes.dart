/// Route path constants for the app.
///
/// Using a dedicated constants file improves maintainability
/// and makes route paths discoverable.
abstract final class Routes {
  // Auth routes
  static const splash = '/splash';
  static const enterPhone = '/enter-phone';
  static const login = '/login';
  static const signup = '/signup';
  static const otp = '/otp';

  // Main tab routes
  static const home = '/home';
  static const properties = '/properties';
  static const collections = '/collections';
  static const tasks = '/tasks';
  static const more = '/more';

  // Properties sub-routes
  static const propertiesCreate = '/properties/create';
  static String propertyDetail(String id) => '/properties/$id';
  static String propertyEdit(String id) => '/properties/$id/edit';

  // Collections sub-routes
  static const paymentsNew = '/collections/payments/new';

  // Tasks sub-routes
  static const tasksCreate = '/tasks/create';
  static String taskDetail(String id) => '/tasks/$id';

  // More tab sub-routes
  static const applications = '/more/applications';
  static const applicationsFormsNew = '/more/applications/forms/new';
  static String applicationForm(String id) => '/more/applications/forms/$id';
  static String applicationInbox(String id) => '/more/applications/inbox/$id';

  static const tenants = '/more/tenants';
  static String tenantDetail(String id) => '/more/tenants/$id';

  static const leases = '/more/leases';
  static const leasesNew = '/more/leases/new';
  static String leaseDetail(String id) => '/more/leases/$id';

  static const inspections = '/more/inspections';
  static const inspectionsNew = '/more/inspections/new';
  static String inspectionDetail(String id) => '/more/inspections/$id';

  static const expenses = '/more/expenses';
  static const expensesNew = '/more/expenses/new';
  static String expenseEdit(String id) => '/more/expenses/$id/edit';

  static const documents = '/more/documents';
  static const documentsUpload = '/more/documents/upload';

  static const reports = '/more/reports';
  static const reportsDrilldown = '/more/reports/drilldown';

  static const notifications = '/more/notifications';

  static const profile = '/more/profile';
  static const profileEdit = '/more/profile/edit';
  static const changePassword = '/more/profile/change-password';
  static const settings = '/more/profile/settings';
  static const notificationSettings = '/more/profile/settings/notifications';
  static const privacySettings = '/more/profile/settings/privacy';
  static const help = '/more/profile/help';
  static const contact = '/more/profile/contact';
  static const about = '/more/profile/about';

  // Public routes
  static String publicApplication(String slug) => '/public/applications/$slug';
  static String publicApplicationSuccess(String slug) =>
      '/public/applications/$slug/success';
}
