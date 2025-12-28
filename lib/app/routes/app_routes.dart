abstract final class Routes {
  static const splash = '/';

  // Auth
  static const enterPhone = '/auth/enter-phone';
  static const login = '/auth/login';
  static const signup = '/auth/signup';

  // Main Shell
  static const shell = '/shell';

  // Properties
  static const properties = '/properties';
  static const propertyDetail = '/properties/:id';
  static const propertyCreate = '/properties/create';
  static const propertyEdit = '/properties/:id/edit';

  // Tenants
  static const tenants = '/tenants';
  static const tenantDetail = '/tenants/:id';

  // Leases
  static const leases = '/leases';
  static const leaseDetail = '/leases/:id';
  static const leaseCreate = '/leases/create';

  // Finance - Rent
  static const finance = '/finance';
  static const rentCharges = '/finance/charges';
  static const rentChargeGenerate = '/finance/charges/generate';
  static const recordPayment = '/finance/payments/record';

  // Finance - Expenses
  static const expenses = '/expenses';
  static const expenseCreate = '/expenses/create';
  static const expenseDetail = '/expenses/:id';

  // Maintenance
  static const maintenance = '/maintenance';
  static const maintenanceDetail = '/maintenance/:id';
  static const maintenanceCreate = '/maintenance/create';

  // Documents
  static const documents = '/documents';
  static const documentUpload = '/documents/upload';

  // Inspections
  static const inspections = '/inspections';
  static const inspectionDetail = '/inspections/:id';
  static const inspectionCreate = '/inspections/create';

  // Applications
  static const applications = '/applications';
  static const applicationDetail = '/applications/:id';
  static const applicationFormCreate = '/applications/forms/create';

  // Reports
  static const reports = '/reports';
  static const reportDetail = '/reports/:type';

  // Public
  static const publicApplication = '/public/application/:slug';

  // Settings
  static const settings = '/settings';

  // Legacy - redirect to shell
  static const home = '/home';
}
