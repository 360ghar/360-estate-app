import 'dart:async';

import 'package:estate_app/app/app_shell.dart';
import 'package:estate_app/core/config/constants.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/services/deep_link_service.dart';
import 'package:estate_app/features/auth/presentation/add_phone_page.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/enter_phone_page.dart';
import 'package:estate_app/features/auth/presentation/login_page.dart';
import 'package:estate_app/features/auth/presentation/otp_verify_page.dart';
import 'package:estate_app/features/auth/presentation/set_password_page.dart';
import 'package:estate_app/features/auth/presentation/profile_completion_page.dart';
import 'package:estate_app/features/auth/presentation/onboarding_page.dart';
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
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/more/documents/presentation/document_upload_page.dart';
import 'package:estate_app/features/more/documents/presentation/documents_page.dart';
import 'package:estate_app/features/more/expenses/presentation/expense_form_page.dart';
import 'package:estate_app/features/more/expenses/presentation/expenses_page.dart';
import 'package:estate_app/features/more/presentation/more_page.dart';
import 'package:estate_app/features/more/presentation/pages/about_page.dart';
import 'package:estate_app/features/more/presentation/pages/contact_support_page.dart';
import 'package:estate_app/features/more/presentation/pages/help_page.dart';
import 'package:estate_app/features/more/profile/presentation/pages/change_password_page.dart';
import 'package:estate_app/features/more/profile/presentation/pages/profile_edit_page.dart';
import 'package:estate_app/features/more/profile/presentation/profile_page.dart';
import 'package:estate_app/features/more/reports/presentation/report_drilldown_page.dart';
import 'package:estate_app/features/more/reports/presentation/reports_page.dart';
import 'package:estate_app/features/more/tenants/presentation/tenant_detail_page.dart';
import 'package:estate_app/features/more/tenants/presentation/tenants_page.dart';
import 'package:estate_app/features/notifications/presentation/notifications_page.dart';
import 'package:estate_app/features/properties/presentation/pages/location_search_page.dart';
import 'package:estate_app/features/properties/presentation/pages/property_map_page.dart';
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
import 'package:estate_app/features/settings/presentation/pages/legal_content_page.dart';
import 'package:estate_app/features/settings/presentation/pages/notification_settings_page.dart';
import 'package:estate_app/features/settings/presentation/pages/privacy_settings_page.dart';
import 'package:estate_app/features/tasks/presentation/maintenance_detail_page.dart';
import 'package:estate_app/features/tasks/presentation/task_create_page.dart';
import 'package:estate_app/features/tasks/presentation/tasks_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Paths that originate from external deep links and must be reachable
/// without going through the home shell. The /public/applications/* path
/// is intentionally public; the others require authentication which is
/// enforced by [AuthMiddleware] in the route definitions.
bool _isEstateDeepLinkPath(String location) {
  return location.startsWith('/properties/') ||
      location.startsWith('/tasks/') ||
      location.startsWith('/more/tenants/') ||
      location.startsWith('/more/leases/');
}

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
      final needsPhone = authState.status == AuthStatus.needsPhone;
      final needsPassword = authState.status == AuthStatus.needsPassword;
      final needsProfileCompletion = authState.status == AuthStatus.needsProfileCompletion;
      final needsOnboarding = authState.status == AuthStatus.needsOnboarding;
      final location = state.uri.path;

      final isSplash = location == '/splash';
      final isAddPhone = location == '/add-phone';
      final isSetPassword = location == '/set-password';
      final isProfileCompletion = location == '/profile-completion';
      final isOnboarding = location == '/onboarding';
      final isAuthRoute =
          location == '/enter-phone' ||
          location == '/login' ||
          location == '/otp' ||
          location == '/signup' ||
          isAddPhone ||
          isSetPassword ||
          isProfileCompletion ||
          isOnboarding;
      final isPublicRoute = location.startsWith('/public');
      final isApplicationsRoute = location.startsWith('/more/applications');
      final isDeepLinkPath = _isEstateDeepLinkPath(location);

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

      // Replay any pending deep link captured during cold start once the
      // user is authenticated and the splash has been processed.
      if (isLoggedIn && !isSplash && !isAuthRoute) {
        final pending = DeepLinkService.consumePendingPath();
        if (pending != null && pending != location) {
          return pending;
        }
      }

      if (!isLoggedIn) {
        // Allow public deep links (rental applications) through the
        // unauthenticated state. Authenticated deep links are stored as
        // pending paths and replayed after login.
        if (isDeepLinkPath) {
          return null;
        }
        return isAuthRoute ? null : '/enter-phone';
      }

      // Mandatory set-password step (req 6): an OTP-verified account with no
      // password must set one before reaching the app. Non-skippable.
      if (needsPassword) {
        return isSetPassword ? null : '/set-password';
      }

      // Post-Google passwordless users without a phone get the skippable
      // add-phone interstitial before reaching the app shell.
      if (needsPhone) {
        return isAddPhone ? null : '/add-phone';
      }

      // Profile completion gate: mandatory fields (full_name, date_of_birth)
      // must be filled before reaching the app.
      if (needsProfileCompletion) {
        return isProfileCompletion ? null : '/profile-completion';
      }

      // App onboarding gate: app-specific onboarding must be completed.
      if (needsOnboarding) {
        return isOnboarding ? null : '/onboarding';
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
            builder: (context, state) => const PublicApplicationSuccessPage(),
          ),
        ],
      ),
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/properties/map',
        builder: (context, state) {
          final markers = state.extra as List<PropertyMarker>? ?? [];
          final lat =
              double.tryParse(state.uri.queryParameters['lat'] ?? '') ??
              20.5937;
          final lng =
              double.tryParse(state.uri.queryParameters['lng'] ?? '') ??
              78.9629;
          return PropertyMapPage(
            markers: markers,
            initialLatitude: lat,
            initialLongitude: lng,
          );
        },
      ),
      GoRoute(
        path: '/enter-phone',
        builder: (context, state) => const EnterPhonePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final identifier =
              state.uri.queryParameters['identifier'] ??
              state.uri.queryParameters['phone'];
          return LoginPage(identifier: identifier);
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          final identifier =
              state.uri.queryParameters['identifier'] ??
              state.uri.queryParameters['phone'];
          return SignupPage(identifier: identifier);
        },
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final identifier =
              state.uri.queryParameters['identifier'] ??
              state.uri.queryParameters['phone'] ??
              '';
          final flow = state.uri.queryParameters['flow'];
          final channel = state.uri.queryParameters['channel'];
          final requirePassword =
              state.uri.queryParameters['requirePassword'] == 'true';
          return OtpVerifyPage(
            identifier: identifier,
            isSignupFlow: flow == 'signup',
            isResetFlow: flow == 'reset',
            isEmailChannel: channel == 'email',
            requirePassword: requirePassword,
          );
        },
      ),
      GoRoute(
        path: '/add-phone',
        builder: (context, state) => const AddPhonePage(),
      ),
      GoRoute(
        path: '/set-password',
        builder: (context, state) => const SetPasswordPage(),
      ),
      GoRoute(
        path: '/profile-completion',
        builder: (context, state) => const ProfileCompletionPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/location-search',
        builder: (context, state) => const LocationSearchPage(),
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
                          return ApplicationInboxDetailPage(applicationId: id);
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
                          final args = state.extra as ReportDrilldownArgs?;
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
                            builder: (context, state) =>
                                const NotificationSettingsPage(),
                          ),
                          GoRoute(
                            path: 'privacy',
                            builder: (context, state) =>
                                const PrivacySettingsPage(),
                          ),
                          GoRoute(
                            path: 'privacy-policy',
                            builder: (context, state) => LegalContentPage(
                              title: 'Privacy Policy',
                              url: kPrivacyPolicyUrl,
                            ),
                          ),
                          GoRoute(
                            path: 'terms-of-service',
                            builder: (context, state) => LegalContentPage(
                              title: 'Terms of Service',
                              url: kTermsOfServiceUrl,
                            ),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'help',
                        builder: (context, state) => const HelpPage(),
                      ),
                      GoRoute(
                        path: 'contact',
                        builder: (context, state) => ContactSupportPage(
                          initialCategory:
                              state.uri.queryParameters['category'],
                        ),
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
