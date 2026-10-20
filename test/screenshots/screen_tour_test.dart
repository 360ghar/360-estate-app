import 'dart:io';

import 'package:estate_app/app/router/app_router.dart';
import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/features/auth/presentation/add_phone_page.dart';
import 'package:estate_app/features/auth/presentation/enter_phone_page.dart';
import 'package:estate_app/features/auth/presentation/login_page.dart';
import 'package:estate_app/features/auth/presentation/onboarding_page.dart';
import 'package:estate_app/features/auth/presentation/otp_verify_page.dart';
import 'package:estate_app/features/auth/presentation/profile_completion_page.dart';
import 'package:estate_app/features/auth/presentation/set_password_page.dart';
import 'package:estate_app/features/auth/presentation/signup_page.dart';
import 'package:estate_app/features/auth/presentation/splash_page.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:estate_app/features/more/reports/presentation/report_drilldown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../contract/fixture_app.dart';

/// A screenshot of every screen, for review by eye. Off by default so CI stays
/// green; run it with
///
///   flutter test test/screenshots --update-goldens \
///     --dart-define=SCREENSHOTS=true [--dart-define=SHOTS=light,dark,hi,xl] \
///     [--dart-define=ONLY=home,properties] \
///     [--dart-define=DEVANAGARI_FONT=/abs/path/NotoSansDevanagari.ttf]
///
/// PNGs land in `test/screenshots/goldens/<variant>/<screen>.png` (gitignored).
/// Screens in the shell render through the real router, so the nav bar shows.

const _on = bool.fromEnvironment('SCREENSHOTS');
const _shots = String.fromEnvironment('SHOTS', defaultValue: 'light,dark');
const _only = String.fromEnvironment('ONLY');
const _devanagari = String.fromEnvironment('DEVANAGARI_FONT');

/// Routed screens, by the path the real router opens.
final _routes = <String, String>{
  'home': Routes.home,
  'properties': Routes.properties,
  'property_detail': Routes.propertyDetail('1'),
  'property_create': Routes.propertiesCreate,
  'property_edit': Routes.propertyEdit('1'),
  'location_search': Routes.locationSearch,
  'collections': Routes.collections,
  'record_payment': '${Routes.paymentsNew}?chargeId=101',
  'tasks': Routes.tasks,
  'task_create': Routes.tasksCreate,
  'task_detail': Routes.taskDetail('71'),
  'more': Routes.more,
  'leases': Routes.leases,
  'lease_new': Routes.leasesNew,
  'lease_detail': Routes.leaseDetail('31'),
  'tenants': Routes.tenants,
  'tenant_detail': Routes.tenantDetail('52'),
  'inspections': Routes.inspections,
  'inspection_new': Routes.inspectionsNew,
  'inspection_detail': Routes.inspectionDetail('61'),
  'inspection_templates': Routes.inspectionTemplates,
  'expenses': Routes.expenses,
  'expense_new': Routes.expensesNew,
  'documents': Routes.documents,
  'document_upload': Routes.documentsUpload,
  'reports': Routes.reports,
  'report_drilldown': Routes.reportsDrilldown,
  'notifications': Routes.notifications,
  'applications': Routes.applications,
  'application_form_new': Routes.applicationsFormsNew,
  'application_form_detail': Routes.applicationForm('41'),
  'application_inbox_detail': Routes.applicationInbox('301'),
  'public_application': Routes.publicApplication('sector-51-abc'),
  'public_application_success': Routes.publicApplicationSuccess(
    'sector-51-abc',
  ),
  'profile': Routes.profile,
  'profile_edit': Routes.profileEdit,
  'change_password': Routes.changePassword,
  'settings': Routes.settings,
  'notification_settings': Routes.notificationSettings,
  'privacy_settings': Routes.privacySettings,
  'privacy_policy': Routes.privacyPolicy,
  'terms_of_service': Routes.termsOfService,
  'help': Routes.help,
  'contact': Routes.contact,
  'about': Routes.about,
  'delete_account': '${Routes.settings}/delete-account',
};

/// Signed-out screens: the guard sends a signed-in session away from these,
/// so they render on their own.
/// Routes that need an `extra` to show their screen.
final _extras = <String, Object Function()>{
  'report_drilldown': () {
    const rows = [
      ReportRow(label: '2 BHK Sector 51', amount: 32000, detail: 'Occupied'),
      ReportRow(label: '3 BHK Sector 49', amount: 41000, detail: 'Occupied'),
      ReportRow(label: '1 BHK Sector 52', amount: 18000, detail: 'Vacant'),
    ];
    return ReportDrilldownArgs(
      result: const ReportResult(type: ReportType.rentRoll, rows: rows),
      row: rows.first,
    );
  },
};

final _pages = <String, Widget Function()>{
  'splash': () => const SplashPage(),
  'enter_phone': () => const EnterPhonePage(),
  'login': () => const LoginPage(identifier: '+919876543210'),
  'signup': () => const SignupPage(identifier: '+919876543210'),
  'otp': () => const OtpVerifyPage(identifier: '+919876543210'),
  'set_password': () => const SetPasswordPage(),
  'add_phone': () => const AddPhonePage(),
  'profile_completion': () => const ProfileCompletionPage(),
  'onboarding': () => const OnboardingPage(),
};

class _Variant {
  const _Variant(this.themeMode, {this.locale, this.textScale = 1});
  final ThemeMode themeMode;
  final Locale? locale;
  final double textScale;
}

const _variants = <String, _Variant>{
  'light': _Variant(ThemeMode.light),
  'dark': _Variant(ThemeMode.dark),
  'hi': _Variant(ThemeMode.light, locale: Locale('hi')),
  'xl': _Variant(ThemeMode.light, textScale: 1.5),
};

Future<void> _loadFont(String family, Iterable<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

/// The Flutter SDK's material fonts (Roboto, the icon font), found from the
/// test runner's own path: `<flutter>/bin/cache/artifacts/engine/...`.
String _materialFonts() {
  final exe = Platform.resolvedExecutable;
  final cache = exe.substring(
    0,
    exe.indexOf('/bin/cache/') + '/bin/cache/'.length,
  );
  return '${cache}artifacts/material_fonts';
}

Future<void> _loadFonts() async {
  final material = _materialFonts();
  await _loadFont('Roboto', [
    for (final w in ['Regular', 'Medium', 'Bold']) '$material/Roboto-$w.ttf',
  ]);
  await _loadFont('MaterialIcons', ['$material/MaterialIcons-Regular.otf']);
  final uncut = Directory('assets/fonts')
      .listSync()
      .whereType<File>()
      .map((f) => f.path)
      .where((p) => p.contains('UncutSans') && p.endsWith('.ttf'));
  if (uncut.isNotEmpty) await _loadFont('UncutSans', uncut);
  if (_devanagari.isNotEmpty) {
    // The text engine falls back to any loaded family for missing glyphs.
    await _loadFont('NotoSansDevanagari', [_devanagari]);
  }
}

Future<void> _settle(WidgetTester tester, [int frames = 10]) async {
  // Never pumpAndSettle: skeletons and spinners repeat forever.
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

bool _wanted(String name) => _only.isEmpty || _only.split(',').contains(name);

void main() {
  setUpAll(() async {
    PackageInfo.setMockInitialValues(
      appName: '360 Estate',
      packageName: 'com.the360ghar.estateapp',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    // Plugins have no platform side in tests: answer them with fixed values.
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger
      ..setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (_) async => Directory.systemTemp.path,
      )
      ..setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        (_) async => true,
      )
      // The OTP page listens for an SMS code; in tests there is none.
      ..setMockMethodCallHandler(
        const MethodChannel('sms_autofill'),
        (call) async => switch (call.method) {
          'listenForCode' => '',
          _ => null,
        },
      );
    await _loadFonts();
  });

  for (final variantName in _shots.split(',')) {
    final variant = _variants[variantName]!;
    group(variantName, () {
      Future<FixtureApp> open(
        WidgetTester tester,
        Widget home,
        bool router,
      ) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        final app = await buildFixtureApp(
          home,
          useAppRouter: router,
          themeMode: variant.themeMode,
          locale: variant.locale,
          textScale: variant.textScale,
        );
        await tester.pumpWidget(app.widget);
        await _settle(tester);
        return app;
      }

      Future<void> shoot(WidgetTester tester, String name) async {
        // Images decode off the frame clock: decode them for real, then
        // paint, or logos and photos are missing from the shot.
        await tester.runAsync(() async {
          for (final element in find.byType(Image).evaluate()) {
            // A fixture photo URL fails to load: the screen shows its own
            // placeholder, which is what the shot should show.
            await precacheImage(
              (element.widget as Image).image,
              element,
              onError: (_, _) {},
            );
          }
        });
        await tester.pump();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/$variantName/$name.png'),
        );
      }

      for (final entry in _routes.entries) {
        if (!_wanted(entry.key)) continue;
        testWidgets(entry.key, (tester) async {
          final app = await open(tester, const SizedBox(), true);
          app
              .container()
              .read(appRouterProvider)
              .go(entry.value, extra: _extras[entry.key]?.call());
          await _settle(tester, 15);
          await shoot(tester, entry.key);
        });
      }

      for (final entry in _pages.entries) {
        if (!_wanted(entry.key)) continue;
        testWidgets(entry.key, (tester) async {
          await open(tester, entry.value(), false);
          await shoot(tester, entry.key);
        });
      }
    }, skip: !_on);
  }
}
