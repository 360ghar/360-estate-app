import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:estate_app/features/auth/presentation/middleware/auth_middleware.dart';
import 'package:estate_app/features/auth/presentation/middleware/guest_middleware.dart';
import 'package:estate_app/features/auth/presentation/pages/enter_phone_page.dart';
import 'package:estate_app/features/auth/presentation/pages/login_page.dart';
import 'package:estate_app/features/auth/presentation/pages/signup_page.dart';
import 'package:estate_app/features/auth/presentation/pages/splash_page.dart';
import 'package:estate_app/features/finance/presentation/bindings/expense_form_bindings.dart';
import 'package:estate_app/features/finance/presentation/bindings/finance_bindings.dart';
import 'package:estate_app/features/finance/presentation/bindings/record_payment_bindings.dart';
import 'package:estate_app/features/finance/presentation/pages/expense_form_page.dart';
import 'package:estate_app/features/finance/presentation/pages/record_payment_page.dart';
import 'package:estate_app/features/documents/presentation/bindings/document_upload_bindings.dart';
import 'package:estate_app/features/documents/presentation/bindings/documents_bindings.dart';
import 'package:estate_app/features/documents/presentation/pages/document_upload_page.dart';
import 'package:estate_app/features/documents/presentation/pages/documents_page.dart';
import 'package:estate_app/features/home/presentation/bindings/home_bindings.dart';
import 'package:estate_app/features/applications/presentation/bindings/application_detail_bindings.dart';
import 'package:estate_app/features/applications/presentation/bindings/application_form_bindings.dart';
import 'package:estate_app/features/applications/presentation/bindings/applications_bindings.dart';
import 'package:estate_app/features/applications/presentation/pages/application_detail_page.dart';
import 'package:estate_app/features/applications/presentation/pages/application_form_create_page.dart';
import 'package:estate_app/features/applications/presentation/pages/applications_page.dart';
import 'package:estate_app/features/inspections/presentation/bindings/inspection_detail_bindings.dart';
import 'package:estate_app/features/inspections/presentation/bindings/inspection_form_bindings.dart';
import 'package:estate_app/features/inspections/presentation/bindings/inspections_bindings.dart';
import 'package:estate_app/features/inspections/presentation/pages/inspection_detail_page.dart';
import 'package:estate_app/features/inspections/presentation/pages/inspection_form_page.dart';
import 'package:estate_app/features/inspections/presentation/pages/inspections_page.dart';
import 'package:estate_app/features/maintenance/presentation/bindings/maintenance_bindings.dart';
import 'package:estate_app/features/maintenance/presentation/bindings/maintenance_detail_bindings.dart';
import 'package:estate_app/features/maintenance/presentation/bindings/maintenance_form_bindings.dart';
import 'package:estate_app/features/maintenance/presentation/pages/maintenance_detail_page.dart';
import 'package:estate_app/features/maintenance/presentation/pages/maintenance_form_page.dart';
import 'package:estate_app/features/maintenance/presentation/pages/maintenance_page.dart';
import 'package:estate_app/features/leases/presentation/bindings/lease_detail_bindings.dart';
import 'package:estate_app/features/leases/presentation/bindings/leases_bindings.dart';
import 'package:estate_app/features/leases/presentation/pages/lease_detail_page.dart';
import 'package:estate_app/features/leases/presentation/pages/leases_page.dart';
import 'package:estate_app/features/properties/presentation/bindings/properties_bindings.dart';
import 'package:estate_app/features/properties/presentation/bindings/property_detail_bindings.dart';
import 'package:estate_app/features/properties/presentation/pages/property_create_page.dart';
import 'package:estate_app/features/properties/presentation/pages/property_detail_page.dart';
import 'package:estate_app/features/public_applications/presentation/pages/public_application_page.dart';
import 'package:estate_app/features/reports/presentation/bindings/reports_bindings.dart';
import 'package:estate_app/features/reports/presentation/pages/report_detail_page.dart';
import 'package:estate_app/features/reports/presentation/pages/reports_page.dart';
import 'package:estate_app/features/settings/presentation/bindings/settings_bindings.dart';
import 'package:estate_app/features/tenants/presentation/bindings/tenant_detail_bindings.dart';
import 'package:estate_app/features/tenants/presentation/bindings/tenants_bindings.dart';
import 'package:estate_app/features/tenants/presentation/pages/tenant_detail_page.dart';
import 'package:estate_app/features/settings/presentation/pages/settings_page.dart';
import 'package:estate_app/features/shell/presentation/bindings/shell_bindings.dart';
import 'package:estate_app/features/shell/presentation/pages/shell_page.dart';
import 'package:get/get.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: Routes.splash, page: SplashPage.new, binding: AuthBindings()),
    GetPage(
      name: Routes.enterPhone,
      page: EnterPhonePage.new,
      binding: AuthBindings(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.login,
      page: LoginPage.new,
      binding: AuthBindings(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: Routes.signup,
      page: SignupPage.new,
      binding: AuthBindings(),
      middlewares: [GuestMiddleware()],
    ),

    // Main Shell (replaces home)
    GetPage(
      name: Routes.shell,
      page: ShellPage.new,
      bindings: [
        ShellBindings(),
        HomeBindings(),
        PropertiesBindings(),
        TenantsBindings(),
        FinanceBindings(),
        SettingsBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Legacy home route - redirect to shell
    GetPage(
      name: Routes.home,
      page: ShellPage.new,
      bindings: [
        ShellBindings(),
        HomeBindings(),
        PropertiesBindings(),
        TenantsBindings(),
        FinanceBindings(),
        SettingsBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Property routes
    GetPage(
      name: Routes.propertyDetail,
      page: PropertyDetailPage.new,
      bindings: [
        PropertiesBindings(),
        PropertyDetailBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.propertyCreate,
      page: PropertyCreatePage.new,
      binding: PropertiesBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.propertyEdit,
      page: PropertyCreatePage.new, // Reuse create page for edit
      bindings: [
        PropertiesBindings(),
        PropertyDetailBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Tenant routes
    GetPage(
      name: Routes.tenantDetail,
      page: TenantDetailPage.new,
      bindings: [
        TenantsBindings(),
        TenantDetailBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Lease routes
    GetPage(
      name: Routes.leases,
      page: LeasesPage.new,
      binding: LeasesBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.leaseDetail,
      page: LeaseDetailPage.new,
      bindings: [
        LeasesBindings(),
        LeaseDetailBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Finance routes
    GetPage(
      name: Routes.recordPayment,
      page: RecordPaymentPage.new,
      bindings: [
        FinanceBindings(),
        RecordPaymentBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.expenseCreate,
      page: ExpenseFormPage.new,
      bindings: [
        FinanceBindings(),
        ExpenseFormBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Maintenance routes
    GetPage(
      name: Routes.maintenance,
      page: MaintenancePage.new,
      binding: MaintenanceBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.maintenanceDetail,
      page: MaintenanceDetailPage.new,
      bindings: [
        MaintenanceBindings(),
        MaintenanceDetailBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.maintenanceCreate,
      page: MaintenanceFormPage.new,
      bindings: [
        MaintenanceBindings(),
        MaintenanceFormBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Documents routes
    GetPage(
      name: Routes.documents,
      page: DocumentsPage.new,
      binding: DocumentsBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.documentUpload,
      page: DocumentUploadPage.new,
      bindings: [
        DocumentsBindings(),
        DocumentUploadBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Inspections routes
    GetPage(
      name: Routes.inspections,
      page: InspectionsPage.new,
      binding: InspectionsBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.inspectionDetail,
      page: InspectionDetailPage.new,
      bindings: [
        InspectionsBindings(),
        InspectionDetailBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.inspectionCreate,
      page: InspectionFormPage.new,
      bindings: [
        InspectionsBindings(),
        InspectionFormBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Applications routes
    GetPage(
      name: Routes.applications,
      page: ApplicationsPage.new,
      binding: ApplicationsBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.applicationDetail,
      page: ApplicationDetailPage.new,
      bindings: [
        ApplicationsBindings(),
        ApplicationDetailBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.applicationFormCreate,
      page: ApplicationFormCreatePage.new,
      bindings: [
        ApplicationsBindings(),
        ApplicationFormBindings(),
      ],
      middlewares: [AuthMiddleware()],
    ),

    // Reports routes
    GetPage(
      name: Routes.reports,
      page: ReportsPage.new,
      binding: ReportsBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.reportDetail,
      page: ReportDetailPage.new,
      binding: ReportsBindings(),
      middlewares: [AuthMiddleware()],
    ),

    // Public routes
    GetPage(name: Routes.publicApplication, page: PublicApplicationPage.new),

    // Settings (standalone)
    GetPage(
      name: Routes.settings,
      page: SettingsPage.new,
      binding: SettingsBindings(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
