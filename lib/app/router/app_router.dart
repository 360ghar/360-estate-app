import 'dart:async';

import 'package:estate_app/app/app_shell.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/enter_phone_page.dart';
import 'package:estate_app/features/auth/presentation/login_page.dart';
import 'package:estate_app/features/auth/presentation/otp_verify_page.dart';
import 'package:estate_app/features/auth/presentation/signup_page.dart';
import 'package:estate_app/features/auth/presentation/splash_page.dart';
import 'package:estate_app/features/collections/presentation/collections_page.dart';
import 'package:estate_app/features/collections/presentation/record_payment_page.dart';
import 'package:estate_app/features/home/presentation/home_page.dart';
import 'package:estate_app/features/inspections/presentation/inspection_detail_page.dart';
import 'package:estate_app/features/inspections/presentation/inspection_form_page.dart';
import 'package:estate_app/features/inspections/presentation/inspections_page.dart';
import 'package:estate_app/features/leases/presentation/lease_detail_page.dart';
import 'package:estate_app/features/leases/presentation/lease_form_page.dart';
import 'package:estate_app/features/leases/presentation/leases_page.dart';
import 'package:estate_app/features/more/documents/presentation/document_upload_page.dart';
import 'package:estate_app/features/more/documents/presentation/documents_page.dart';
import 'package:estate_app/features/more/expenses/presentation/expense_form_page.dart';
import 'package:estate_app/features/more/expenses/presentation/expenses_page.dart';
import 'package:estate_app/features/more/presentation/pages/about_page.dart';
import 'package:estate_app/features/more/presentation/pages/contact_support_page.dart';
import 'package:estate_app/features/more/presentation/pages/help_page.dart';
import 'package:estate_app/features/more/presentation/more_page.dart';
import 'package:estate_app/features/more/profile/presentation/pages/change_password_page.dart';
import 'package:estate_app/features/more/profile/presentation/pages/profile_edit_page.dart';
import 'package:estate_app/features/more/profile/presentation/profile_page.dart';
import 'package:estate_app/features/more/reports/presentation/reports_page.dart';
import 'package:estate_app/features/more/reports/presentation/report_drilldown_page.dart';
import 'package:estate_app/features/more/tenants/presentation/tenant_detail_page.dart';
import 'package:estate_app/features/more/tenants/presentation/tenants_page.dart';
import 'package:estate_app/features/notifications/presentation/notifications_page.dart';
import 'package:estate_app/features/properties/presentation/properties_page.dart';
import 'package:estate_app/features/properties/presentation/property_detail_page.dart';
import 'package:estate_app/features/properties/presentation/property_form_page.dart';
import 'package:estate_app/features/rental_applications/presentation/application_form_create_page.dart';
import 'package:estate_app/features/rental_applications/presentation/application_form_detail_page.dart';
import 'package:estate_app/features/rental_applications/presentation/application_inbox_detail_page.dart';
import 'package:estate_app/features/rental_applications/presentation/applications_page.dart';
import 'package:estate_app/features/rental_applications/presentation/public_application_page.dart';
import 'package:estate_app/features/rental_applications/presentation/public_application_success_page.dart';
import 'package:estate_app/features/settings/presentation/pages/app_settings_page.dart';
import 'package:estate_app/features/settings/presentation/pages/notification_settings_page.dart';
import 'package:estate_app/features/settings/presentation/pages/privacy_settings_page.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/presentation/maintenance_detail_page.dart';
import 'package:estate_app/features/tasks/presentation/task_create_page.dart';
import 'package:estate_app/features/tasks/presentation/tasks_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authController = ref.read(authControllerProvider.notifier);
  final flags = ref.read(appConfigProvider).featureFlags;

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authController.stream),
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isChecking = authState.status == AuthStatus.checking;
      final isLoggedIn = authState.isLoggedIn;
      final location = state.uri.path;

      final isSplash = location == '/splash';
      final isAuthRoute = location == '/enter-phone' ||
          location == '/login' ||
          location == '/otp' ||
          location == '/signup';
      final isPublicRoute = location.startsWith('/public');
      final isApplicationsRoute = location.startsWith('/more/applications');

      if (isPublicRoute) {
        if (!flags.enablePublicApplications) {
          if (!isLoggedIn) return '/enter-phone';
          return '/home';
        }
        return null;
      }

      if (isChecking) {
        return isSplash ? null : '/splash';
      }

      if (!isLoggedIn) {
        return isAuthRoute ? null : '/enter-phone';
      }

      if (!flags.enableApplicationsModule && isApplicationsRoute) {
        return '/more';
      }

      if (isLoggedIn && (isAuthRoute || isSplash)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/public/applications/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return PublicApplicationPage(slug: slug);
        },
        routes: [
          GoRoute(
            path: 'success',
            builder: (context, state) =>
                const PublicApplicationSuccessPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/enter-phone',
        builder: (context, state) => const EnterPhonePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'];
          return LoginPage(phone: phone);
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'];
          return SignupPage(phone: phone);
        },
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          final flow = state.uri.queryParameters['flow'];
          return OtpVerifyPage(
            phone: phone,
            isSignupFlow: flow == 'signup',
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/properties',
                builder: (context, state) => const PropertiesPage(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const PropertyFormPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return PropertyDetailPage(propertyId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return PropertyFormPage(propertyId: id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/collections',
                builder: (context, state) {
                  final status = state.uri.queryParameters['status'];
                  return CollectionsPage(initialStatus: status);
                },
                routes: [
                  GoRoute(
                    path: 'payments/new',
                    builder: (context, state) {
                      final chargeId = state.uri.queryParameters['chargeId'];
                      return RecordPaymentPage(chargeId: chargeId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksPage(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const TaskCreatePage(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return MaintenanceDetailPage(
                        requestId: id,
                        initialRequest: state.extra as MaintenanceRequest?,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MorePage(),
                routes: [
                  GoRoute(
                    path: 'applications',
                    builder: (context, state) => const ApplicationsPage(),
                    routes: [
                      GoRoute(
                        path: 'forms/new',
                        builder: (context, state) =>
                            const ApplicationFormCreatePage(),
                      ),
                      GoRoute(
                        path: 'forms/:id',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return ApplicationFormDetailPage(formId: id);
                        },
                      ),
                      GoRoute(
                        path: 'inbox/:id',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return ApplicationInboxDetailPage(
                            applicationId: id,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'tenants',
                    builder: (context, state) => const TenantsPage(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return TenantDetailPage(tenantId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'leases',
                    builder: (context, state) {
                      final propertyId =
                          state.uri.queryParameters['propertyId'];
                      final tenantId = state.uri.queryParameters['tenantId'];
                      return LeasesPage(
                        propertyId: propertyId,
                        tenantId: tenantId,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (context, state) => const LeaseFormPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return LeaseDetailPage(leaseId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'inspections',
                    builder: (context, state) {
                      final propertyId =
                          state.uri.queryParameters['propertyId'];
                      final tenantId = state.uri.queryParameters['tenantId'];
                      return InspectionsPage(
                        propertyId: propertyId,
                        tenantId: tenantId,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (context, state) => const InspectionFormPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return InspectionDetailPage(inspectionId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'expenses',
                    builder: (context, state) => const ExpensesPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (context, state) => const ExpenseFormPage(),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return ExpenseFormPage(expenseId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'documents',
                    builder: (context, state) => const DocumentsPage(),
                    routes: [
                      GoRoute(
                        path: 'upload',
                        builder: (context, state) => const DocumentUploadPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'reports',
                    builder: (context, state) => const ReportsPage(),
                    routes: [
                      GoRoute(
                        path: 'drilldown',
                        builder: (context, state) {
                          final args =
                              state.extra as ReportDrilldownArgs?;
                          if (args == null) {
                            return const ReportsPage();
                          }
                          return ReportDrilldownPage(args: args);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) => const NotificationsPage(),
                  ),
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfilePage(),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => const ProfileEditPage(),
                      ),
                      GoRoute(
                        path: 'change-password',
                        builder: (context, state) => const ChangePasswordPage(),
                      ),
                      GoRoute(
                        path: 'settings',
                        builder: (context, state) => const AppSettingsPage(),
                        routes: [
                          GoRoute(
                            path: 'notifications',
                            builder: (context, state) => const NotificationSettingsPage(),
                          ),
                          GoRoute(
                            path: 'privacy',
                            builder: (context, state) => const PrivacySettingsPage(),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'help',
                        builder: (context, state) => const HelpPage(),
                      ),
                      GoRoute(
                        path: 'contact',
                        builder: (context, state) => const ContactSupportPage(),
                      ),
                      GoRoute(
                        path: 'about',
                        builder: (context, state) => const AboutPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// A ChangeNotifier that notifies when a Stream emits a new value.
/// Used to make GoRouter aware of authentication state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyOnStreamChange();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  void notifyOnStreamChange() => notifyListeners();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
