import 'package:estate_app/app/router/app_router.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/core/crash_reporting/crash_reporter.dart';
import 'package:estate_app/core/network/owner_scope.dart';
import 'package:estate_app/core/presentation/theme/app_theme.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/core/storage/secure_kv_store.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contract_helpers.dart';
import 'fixture_api.dart';

/// The whole app stack, with a fake backend. A page built here runs the real
/// providers, repositories, models and the real `AuthController`: the app
/// restores a stored session, reads the profile from the fixture, binds the
/// cache store and the owner scope to the account, and every screen reads the
/// fixtures that `tool/api_fixtures.py` built from the backend response models.

class _MemorySecureStorage extends FlutterSecureStorage {
  _MemorySecureStorage(this._values);

  final Map<String, String> _values;

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.clear();
  }
}

/// A running fake app: the widget, the fake backend and the stores.
class FixtureApp {
  FixtureApp._(this.widget, this.adapter, this.prefs, this.container);

  final Widget widget;
  final FixtureAdapter adapter;
  final AppPreferences prefs;
  final ProviderContainer Function() container;

  /// The requests the app sent, as `METHOD /path`.
  List<String> get sent => [
    for (final o in adapter.requests) '${o.method} ${o.path}',
  ];
}

/// Builds [home] on the full stack.
///
/// [role] is the role of the signed-in user (an owner is `user`). An agent has
/// [ownerId] preset, as the owner picker would store it. [replies] replace
/// fixtures by route key (`GET /pm/leases`).
Future<FixtureApp> buildFixtureApp(
  Widget home, {
  UserRole role = UserRole.user,
  int? ownerId,
  Map<String, Object> replies = const {},
  Map<String, Object> prefsValues = const {},
  Object? Function(Object? json)? mutate,
  bool useAppRouter = false,
  ThemeMode themeMode = ThemeMode.light,
  Locale? locale,
  double textScale = 1,
}) async {
  final profile = Map<String, dynamic>.from(
    loadFixture('users')['profile'] as Map<String, dynamic>,
  )..['role'] = role.wire;
  final adapter = FixtureAdapter(
    loadRoutes(),
    overrides: {'GET /users/profile': profile, ...replies},
    mutate: mutate,
  );

  SharedPreferences.setMockInitialValues({
    if (ownerId != null) ownerPrefKey(profile['id'] as int): ownerId,
    ...prefsValues,
  });
  final prefs = await AppPreferences.create();
  final secure = SecureKvStore(
    storage: _MemorySecureStorage({'auth_token': 'test-token'}),
  );

  // Devanagari text (Hindi copy, the language picker) needs the test font
  // as a fallback; the screen tour loads it. Devices fall back on their own.
  const fallback = ['NotoSansDevanagari'];
  late ProviderContainer Function() container;
  final widget = ProviderScope(
    // A new key per app: a second app in one test does not reuse the first one.
    key: UniqueKey(),
    overrides: [
      appConfigProvider.overrideWithValue(
        const AppConfig(
          environment: AppEnvironment.dev,
          apiBaseUrl: 'https://example.com/api/v1',
          supabaseUrl: '',
          supabasePublishableKey: '',
          enableCrashReporting: false,
          enableDebugLogs: false,
          featureFlags: FeatureFlags(
            enableApplicationsModule: true,
            enablePublicApplications: true,
          ),
        ),
      ),
      appPreferencesProvider.overrideWithValue(prefs),
      secureStoreProvider.overrideWithValue(secure),
      crashReporterProvider.overrideWithValue(NoopCrashReporter()),
      apiClientProvider.overrideWith(
        (ref) => fixtureApiClient(
          adapter,
          ownerScope: () => ref.read(ownerScopeProvider),
        ),
      ),
    ],
    child: Builder(
      builder: (context) {
        container = () => ProviderScope.containerOf(context);
        return Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            // Hindi renders need the Devanagari test font as a fallback (the
            // screen tour loads it); devices fall back on their own.
            theme: AppTheme.of(Brightness.light, fontFamilyFallback: fallback),
            darkTheme: AppTheme.of(
              Brightness.dark,
              fontFamilyFallback: fallback,
            ),
            themeMode: themeMode,
            locale: locale,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: textScale == 1
                ? null
                : (context, child) => MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: TextScaler.linear(textScale)),
                    child: child!,
                  ),
            // The real router (with its guards and the shell) when asked;
            // otherwise [home] at `/`.
            routerConfig: useAppRouter
                ? ref.watch(appRouterProvider)
                : GoRouter(
                    routes: [
                      GoRoute(path: '/', builder: (context, state) => home),
                      // Any other route (a tap that navigates) shows its own path.
                      GoRoute(
                        path: '/:rest(.*)',
                        builder: (context, state) =>
                            Scaffold(body: Text('route ${state.uri}')),
                      ),
                    ],
                  ),
          ),
        );
      },
    ),
  );
  return FixtureApp._(widget, adapter, prefs, () => container());
}

/// Pumps [app] until the session is restored and the screen has loaded.
Future<void> pumpFixtureApp(
  WidgetTester tester,
  FixtureApp app, {
  Size size = const Size(900, 3600),
}) async {
  // A tall screen builds the whole list (a ListView builds what is visible).
  // A flow that taps through a wizard passes a phone-sized screen.
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(app.widget);
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}
