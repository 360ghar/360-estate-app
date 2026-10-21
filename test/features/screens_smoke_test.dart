import 'package:dio/dio.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/owner_scope.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/collections/presentation/collections_page.dart';
import 'package:estate_app/features/collections/presentation/record_payment_page.dart';
import 'package:estate_app/features/home/presentation/home_page.dart';
import 'package:estate_app/features/inspections/presentation/inspection_detail_page.dart';
import 'package:estate_app/features/inspections/presentation/inspection_form_page.dart';
import 'package:estate_app/features/inspections/presentation/inspections_page.dart';
import 'package:estate_app/features/leases/presentation/lease_detail_page.dart';
import 'package:estate_app/features/leases/presentation/lease_form_page.dart';
import 'package:estate_app/features/leases/presentation/leases_page.dart';
import 'package:estate_app/features/more/documents/presentation/documents_page.dart';
import 'package:estate_app/features/more/expenses/presentation/expense_form_page.dart';
import 'package:estate_app/features/more/expenses/presentation/expenses_page.dart';
import 'package:estate_app/features/more/presentation/more_page.dart';
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
import 'package:estate_app/features/tasks/presentation/maintenance_detail_page.dart';
import 'package:estate_app/features/tasks/presentation/task_create_page.dart';
import 'package:estate_app/features/tasks/presentation/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../contract/contract_helpers.dart';
import '../contract/fixture_app.dart';

/// Every screen runs on the full app stack against the backend fixtures (see
/// `test/contract/fixture_app.dart`): real providers, repositories, models and
/// auth controller, with a fake backend. The tests prove that each screen
/// builds from what the backend really sends, shows the contract fields, and
/// sends the requests the backend accepts.

Future<FixtureApp> _open(
  WidgetTester tester,
  Widget page, {
  UserRole role = UserRole.user,
  int? ownerId,
  Map<String, Object> replies = const {},
  Size size = const Size(900, 3600),
}) async {
  final app = await buildFixtureApp(
    page,
    role: role,
    ownerId: ownerId,
    replies: replies,
  );
  await pumpFixtureApp(tester, app, size: size);
  expect(tester.takeException(), isNull);
  return app;
}

/// A snack bar covers the buttons at the bottom of a wizard until it times out.
Future<void> _dismissSnackBar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

/// The button that carries [label]. `FilledButton.icon` is a subclass, so the
/// finder matches by subtype.
Finder _button(String label) => find.ancestor(
  of: find.text(label),
  matching: find.bySubtype<ButtonStyleButton>(),
);

void _expectTexts(List<String> expected) {
  for (final text in expected) {
    expect(find.text(text), findsWidgets, reason: 'missing "$text"');
  }
}

void main() {
  group('screens read the backend contract', () {
    testWidgets('properties list: management status and dedup address', (
      tester,
    ) async {
      await _open(tester, const PropertiesPage());
      _expectTexts(['2 BHK Sector 51', 'Active', 'Archived']);
      // The street line names the city, so the city is not repeated.
      expect(
        find.text('Tower 1, Sector 51, Gurugram, Haryana, 122002'),
        findsWidgets,
      );
    });

    testWidgets('the search box and the occupancy chips filter on the server', (
      tester,
    ) async {
      final app = await _open(tester, const PropertiesPage());
      List<RequestOptions> lists() => [
        for (final o in app.adapter.requests)
          if (o.method == 'GET' && o.path == '/pm/properties') o,
      ];
      expect(lists().last.queryParameters.containsKey('q'), isFalse);

      await tester.enterText(find.byType(TextField), '  sector 51 ');
      // The text is sent after a short pause, not on every key.
      await tester.pump(const Duration(milliseconds: 100));
      expect(lists().last.queryParameters.containsKey('q'), isFalse);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(lists().last.queryParameters['q'], 'sector 51');

      await tester.tap(find.widgetWithText(FilterChip, 'Vacant'));
      await tester.pumpAndSettle();
      expect(lists().last.queryParameters['occupancy'], 'vacant');
      expect(lists().last.queryParameters['q'], 'sector 51');
    });

    testWidgets('property detail: amenities, rent terms and tabs', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const PropertyDetailPage(propertyId: '1'),
      );
      _expectTexts([
        'Power Backup',
        'Lift',
        'Due day (new leases)',
        'Grace period (new leases)',
        // The active lease of the wrapper makes the property occupied, even
        // when `current_lease_id` is not set.
        'Occupied',
      ]);
      expect(find.text('Vacant'), findsNothing);

      await tester.tap(find.widgetWithText(Tab, 'Lease'));
      await tester.pumpAndSettle();
      _expectTexts([
        'Current lease',
        'Rent is due on day 5 of each month. '
            'A late fee of ₹500 flat is charged once after 3 days of grace.',
        'Expiring soon',
        'Pending signature',
      ]);

      for (final tab in [
        'Rent',
        'Expenses',
        'Maintenance',
        'Documents',
        'Inspections',
      ]) {
        await tester.tap(find.widgetWithText(Tab, tab));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: tab);
      }
      expect(app.sent, contains('GET /pm/rent/charges'));
    });

    testWidgets('lease detail: enforced late fee, grace and signed lease', (
      tester,
    ) async {
      await _open(tester, const LeaseDetailPage(leaseId: '31'));
      _expectTexts([
        'Meera Nair',
        '₹32,000',
        '₹64,000',
        'Day 5 of each month',
        '3 days',
        '₹500 flat',
        'View signed lease',
        'Renew',
        'Terminate',
      ]);
    });

    testWidgets('lease detail offers only the actions the backend accepts', (
      tester,
    ) async {
      final terminated = loadFixture('leases')['terminated']! as Object;
      await _open(
        tester,
        const LeaseDetailPage(leaseId: '31'),
        replies: {'GET /pm/leases/{lease_id}': terminated},
      );
      _expectTexts(['Terminated', 'Moved out']);
      // A terminated lease cannot be renewed or terminated again.
      expect(find.text('Renew'), findsNothing);
      expect(find.text('Terminate'), findsNothing);
    });

    testWidgets('leases list: shows each lease status', (tester) async {
      await _open(tester, const LeasesPage());
      // The "Ends in N days" fact depends on today's date, so the fixture end
      // date cannot be pinned; Lease.daysUntilEnd is covered in test/contract.
      _expectTexts(['Expiring soon', 'Pending signature', 'Active']);
    });

    testWidgets('tenant list and detail read user_id and the status', (
      tester,
    ) async {
      final list = await _open(tester, const TenantsPage());
      _expectTexts(['Meera Nair', 'Active', 'Vacated']);
      expect(list.sent, contains('GET /pm/tenants'));

      final detail = await _open(
        tester,
        const TenantDetailPage(tenantId: '52'),
      );
      // The detail route sends no status: the app derives it from the leases.
      expect(find.text('Active'), findsWidgets);
      expect(find.text('Unknown'), findsNothing);
      expect(detail.sent, contains('GET /pm/tenants/52'));
    });

    testWidgets('collections: five status tabs and the charge totals', (
      tester,
    ) async {
      await _open(tester, const CollectionsPage());
      _expectTexts(['Due', 'Partly paid', 'Overdue', 'Paid', 'Waived']);
      // The totals come from the charge wrapper.
      _expectTexts(['₹19,999.50', 'Partly paid', 'Overdue', 'Collected']);
    });

    testWidgets('home, tasks, maintenance, documents, expenses, inspections', (
      tester,
    ) async {
      await _open(tester, const HomePage());
      _expectTexts(['₹48,000 rent outstanding', 'Rent received']);

      await _open(tester, const TasksPage());
      _expectTexts(['Kitchen tap leaking', 'Emergency', 'Property #2']);

      await _open(tester, const MaintenanceDetailPage(requestId: '71'));
      // The assigned agent of the signed-in user is known by name.
      _expectTexts(['Plumbing', 'Meera Nair', '₹1,800', 'Ravi Kumar']);

      await _open(tester, const DocumentsPage());
      _expectTexts(['Lease 2026', 'Tax receipt']);

      await _open(tester, const ExpensesPage());
      _expectTexts(['Q2 property tax', 'Property tax', 'Repairs']);

      await _open(tester, const InspectionsPage());
      _expectTexts(['Move-in inspection', 'Signed by tenant', 'Open']);

      await _open(tester, const InspectionDetailPage(inspectionId: '61'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('applications: forms, public link, answers read Yes or No', (
      tester,
    ) async {
      await _open(tester, const ApplicationsPage());
      // The inbox is the first tab; the forms are one tap away.
      _expectTexts(['Karan Mehta']);
      await tester.tap(find.widgetWithText(Tab, 'Forms'));
      await tester.pumpAndSettle();
      _expectTexts(['Apply for Sector 51', 'Active', 'Inactive']);

      await _open(tester, const ApplicationFormDetailPage(formId: '41'));
      _expectTexts([
        'https://the360ghar.com/estate/apply/sector-51-abc',
        'Do you have pets?',
      ]);

      await _open(
        tester,
        const ApplicationInboxDetailPage(applicationId: '301'),
      );
      _expectTexts(['Karan Mehta', 'Need parking', 'Welcome']);
      // A yes or no answer is not shown as a raw bool.
      expect(find.text('false'), findsNothing);
      expect(find.text('No'), findsOneWidget);
    });
  });

  group('requests the screens send', () {
    testWidgets('Pay opens the record payment screen with the charge', (
      tester,
    ) async {
      final app = await _open(tester, const RecordPaymentPage(chargeId: '101'));
      // A charge the route preselects starts with its balance as the amount.
      expect(find.text('19999.50'), findsOneWidget);

      await tester.tap(find.text('UPI'));
      await tester.pump();
      await tester.tap(_button('Record payment'));
      await tester.pumpAndSettle();

      final post = app.adapter.requests.singleWhere(
        (o) => o.method == 'POST' && o.path == '/pm/rent/payments',
      );
      final body = Map<String, dynamic>.from(post.data as Map);
      expect(body['charge_id'], 101);
      expect(body['amount_paid'], 19999.5);
      expect(body['payment_method'], 'upi');
      expect(body['paid_at'], endsWith('Z'));
      expect(body.keys, isNot(contains('amount')));
      expect(body.keys, isNot(contains('tenant_id')));
    });

    testWidgets('a public application sends the answers by field id', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const PublicApplicationPage(slug: 'sector-51-abc'),
      );
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Ravi Kumar');
      await tester.enterText(fields.at(1), '9876543210');
      await tester.enterText(fields.at(2), 'ravi@example.com');
      final submit = find.text('Submit application');
      await tester.ensureVisible(submit);
      await tester.pumpAndSettle();
      await tester.tap(submit);
      await tester.pumpAndSettle();

      final post = app.adapter.requests.singleWhere(
        (o) => o.method == 'POST' && o.path.endsWith('/submit'),
      );
      final body = Map<String, dynamic>.from(post.data as Map);
      expect(body['applicant_full_name'], 'Ravi Kumar');
      expect(body['answers'], containsPair('pets', false));
      expect(body.keys, isNot(contains('applicant_name')));
      expect(body.keys, isNot(contains('custom_field_responses')));
    });

    testWidgets('an unread notification is marked opened', (tester) async {
      final app = await _open(tester, const NotificationsPage());
      _expectTexts(['Rent due', 'Welcome']);
      await tester.tap(find.text('Rent due'));
      await tester.pumpAndSettle();
      expect(
        app.sent,
        contains('POST /notifications/deliveries/d-1001/opened'),
      );
      // A row that is already read is not marked again.
      await tester.tap(find.text('Welcome'));
      await tester.pumpAndSettle();
      expect(app.sent.where((s) => s.contains('/d-1000/opened')), isEmpty);
    });
  });

  group('other forms', () {
    Map<String, dynamic> body(FixtureApp app, String method, String path) {
      final request = app.adapter.requests.singleWhere(
        (o) => o.method == method && o.path == path,
      );
      return Map<String, dynamic>.from(request.data as Map);
    }

    testWidgets(
      'an expense is created with a property, a category and a title',
      (tester) async {
        final app = await _open(
          tester,
          const ExpenseFormPage(),
          size: const Size(480, 2400),
        );
        await tester.enterText(find.byType(TextFormField).first, '1200');
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Expense title'),
          'Pipe repair',
        );
        await tester.tap(find.text('Repairs'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byType(DropdownButtonFormField<int>),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('2 BHK Sector 51').last);
        await tester.pumpAndSettle();
        final create = find.widgetWithText(FilledButton, 'Create expense');
        await tester.ensureVisible(create);
        await tester.pumpAndSettle();
        await tester.tap(create);
        await tester.pumpAndSettle();

        final sent = body(app, 'POST', '/pm/expenses');
        expect(sent['property_id'], 1);
        expect(sent['category'], 'repairs');
        expect(sent['amount'], 1200);
        expect(sent['title'], 'Pipe repair');
        expect(sent['expense_date'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      },
    );

    testWidgets('a task is created with urgency, cost and the agent', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const TaskCreatePage(),
        size: const Size(480, 2600),
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Title'),
        'Fix tap',
      );
      await tester.tap(find.text('Plumbing'));
      await tester.tap(find.text('High'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(DropdownButtonFormField<int>, 'Property'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 BHK Sector 51').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Estimated cost (optional)'),
        '1500',
      );
      await tester.tap(find.text('Assign to Ravi Kumar'));
      await tester.pumpAndSettle();
      final create = _button('Create task');
      await tester.ensureVisible(create);
      await tester.pumpAndSettle();
      await tester.tap(create);
      await tester.pumpAndSettle();

      final sent = body(app, 'POST', '/pm/maintenance/requests');
      expect(sent['property_id'], 1);
      expect(sent['category'], 'plumbing');
      expect(sent['urgency'], 'high');
      expect(sent['estimated_cost'], 1500);
      expect(sent['assigned_agent_id'], 12);
      expect(sent['title'], 'Fix tap');
      expect(sent.keys, isNot(contains('priority')));
    });

    testWidgets('an application form sends custom_fields and is_active', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const ApplicationFormCreatePage(),
        size: const Size(480, 3000),
      );
      await tester.tap(
        find.byType(DropdownButtonFormField<int>),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 BHK Sector 51').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Form title'),
        'Flat 4B',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Question'),
        'Occupation',
      );
      await tester.tap(find.text('Add question'));
      await tester.pumpAndSettle();
      final create = _button('Create form');
      await tester.ensureVisible(create);
      await tester.pumpAndSettle();
      await tester.tap(create);
      await tester.pumpAndSettle();

      final sent = body(app, 'POST', '/pm/applications/forms');
      expect(sent['title'], 'Flat 4B');
      expect(sent['property_id'], 1);
      expect(sent['is_active'], true);
      final fields = sent['custom_fields'] as List<dynamic>;
      expect(fields, hasLength(1));
      final field = Map<String, dynamic>.from(fields.single as Map);
      expect(field['label'], 'Occupation');
      expect(field['field_type'], 'text');
      expect(field['id'], isNotEmpty);
      expect(sent.keys, isNot(contains('questions')));
    });

    testWidgets('a removed form field never gives its id to a later field', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const ApplicationFormCreatePage(),
        size: const Size(480, 3000),
      );
      Future<void> addField(String label) async {
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Question'),
          label,
        );
        await tester.tap(find.text('Add question'));
        await tester.pumpAndSettle();
      }

      await tester.tap(
        find.byType(DropdownButtonFormField<int>),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 BHK Sector 51').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Form title'),
        'Flat 4B',
      );
      await addField('Q-A');
      await addField('Q-B');
      await tester.tap(find.byIcon(Icons.close_rounded).first);
      await tester.pumpAndSettle();
      await addField('Q-C');
      await addField('Q-D');
      final create = _button('Create form');
      await tester.ensureVisible(create);
      await tester.pumpAndSettle();
      await tester.tap(create);
      await tester.pumpAndSettle();

      final fields =
          (body(app, 'POST', '/pm/applications/forms')['custom_fields']
                  as List<dynamic>)
              .map((f) => Map<String, dynamic>.from(f as Map))
              .toList();
      expect(fields.map((f) => f['label']), ['Q-B', 'Q-C', 'Q-D']);
      expect(fields.map((f) => f['id']).toSet(), hasLength(3));
    });

    testWidgets('an inspection is created for a lease with a type', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const InspectionFormPage(),
        size: const Size(480, 2400),
      );
      await tester.tap(
        find.widgetWithText(DropdownButtonFormField<int>, 'Property'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 BHK Sector 51').last);
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(DropdownButtonFormField<int>, 'Lease'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Meera Nair').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move-out'));
      await tester.pumpAndSettle();
      final create = _button('Create inspection');
      await tester.ensureVisible(create.last);
      await tester.pumpAndSettle();
      await tester.tap(create.last);
      await tester.pumpAndSettle();

      final sent = body(app, 'POST', '/pm/inspections');
      expect(sent['lease_id'], 31);
      expect(sent['inspection_type'], 'move_out');
      expect(sent.keys, isNot(contains('title')));
      expect(sent.keys, isNot(contains('tenant_id')));
    });

    testWidgets('an application decision sends the decision and notes', (
      tester,
    ) async {
      final inbox = loadFixture('applications')['inbox_page']! as Map;
      final applicant = (inbox['items']! as List).first as Object;
      final app = await _open(
        tester,
        const ApplicationInboxDetailPage(applicationId: '301'),
        replies: {'GET /pm/applications/{application_id}': applicant},
      );
      await tester.ensureVisible(_button('Approve'));
      await tester.pumpAndSettle();
      await tester.tap(_button('Approve').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, ' Good fit ');
      await tester.tap(_button('Approve').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final sent = body(app, 'POST', '/pm/applications/301/decision');
      expect(sent['decision'], 'approved');
      expect(sent['notes'], 'Good fit');
      expect(sent.keys, isNot(contains('status')));
    });

    testWidgets('a lease is terminated with a date, not terminated_at', (
      tester,
    ) async {
      final app = await _open(tester, const LeaseDetailPage(leaseId: '31'));
      await tester.tap(_button('Terminate'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Reason'),
        'Moved out',
      );
      await tester.tap(_button('Terminate').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final sent = body(app, 'POST', '/pm/leases/31/terminate');
      expect(sent['reason'], 'Moved out');
      expect(sent['termination_date'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(sent.keys, isNot(contains('terminated_at')));
    });

    testWidgets('a lease renew sends the new dates', (tester) async {
      final app = await _open(tester, const LeaseDetailPage(leaseId: '31'));
      // The Renew button of the screen opens the dialog; the dialog's own
      // Renew button sends the request.
      await tester.tap(_button('Renew'));
      await tester.pumpAndSettle();
      await tester.tap(_button('Renew').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final sent = body(app, 'POST', '/pm/leases/31/renew');
      expect(sent['start_date'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(sent['end_date'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(sent['monthly_rent'], 32000);
    });
  });

  group('lease form', () {
    testWidgets('the lease form creates a lease with the backend keys', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const LeaseFormPage(),
        size: const Size(480, 2200),
      );
      await tester.tap(find.text('Property *'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 BHK Sector 51').last);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tenant name'),
        'Meera Nair',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tenant user ID (optional)'),
        '52',
      );
      // Start today, end on the 15th of next month.
      await tester.tap(find.text('Start date *'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End date *'), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Due day'),
        '5',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Grace days'),
        '3',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Late fee (flat)'),
        '500',
      );
      final create = find.widgetWithText(FilledButton, 'Create lease');
      await tester.ensureVisible(create);
      await tester.pumpAndSettle();
      await tester.tap(create);
      await tester.pumpAndSettle();

      final post = app.adapter.requests.singleWhere(
        (o) => o.method == 'POST' && o.path == '/pm/leases',
      );
      final body = Map<String, dynamic>.from(post.data as Map);
      expect(body['property_id'], 1);
      expect(body['tenant_user_id'], 52);
      expect(body['tenant_name'], 'Meera Nair');
      // The rent and the deposit start from the property.
      expect(body['monthly_rent'], 32000);
      expect(body['security_deposit'], 64000);
      expect(body['payment_due_day'], 5);
      expect(body['grace_period_days'], 3);
      expect(body['late_fee_amount'], 500);
      expect(body['status'], 'draft');
      expect(body['start_date'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(body.keys, isNot(contains('rent_amount')));
      expect(body.keys, isNot(contains('tenant_id')));
    });
  });

  group('property wizard', () {
    testWidgets('the property wizard creates a managed property', (
      tester,
    ) async {
      final app = await _open(
        tester,
        const PropertyFormPage(),
        size: const Size(480, 1100),
      );

      Future<void> next() async {
        await tester.tap(find.text('Next'), warnIfMissed: false);
        await tester.pumpAndSettle();
      }

      // Step 1: name and type (the backend property types).
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Property name *'),
        'Green Villa',
      );
      await tester.tap(find.text('Property type *'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Commercial'), findsNothing);
      expect(find.text('Land'), findsNothing);
      await tester.tap(find.text('Apartment').last);
      await tester.pumpAndSettle();
      await next();

      // Step 2: the city is required.
      await tester.tap(find.text('Next'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Enter a city'), findsOneWidget);
      await _dismissSnackBar(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'City *'),
        'Pune',
      );
      await next();

      // Step 3 has no required field. Step 4: the rent is required.
      await next();
      await tester.tap(find.text('Next'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Enter the monthly rent'), findsOneWidget);
      await _dismissSnackBar(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Monthly rent (\u20B9) *'),
        '25000',
      );
      await next();

      // Step 5: save.
      await tester.tap(find.text('Create property'), warnIfMissed: false);
      await tester.pumpAndSettle();

      final post = app.adapter.requests.singleWhere(
        (o) => o.method == 'POST' && o.path == '/pm/properties',
      );
      final body = Map<String, dynamic>.from(post.data as Map);
      expect(body['title'], 'Green Villa');
      expect(body['property_type'], 'apartment');
      expect(body['purpose'], 'rent');
      expect(body['monthly_rent'], 25000);
      expect(body['base_price'], 25000);
      expect(body['management_status'], 'active');
      expect(body['payment_due_day'], 1);
      expect(body['grace_period_days'], 5);
      expect(body['amenity_ids'], isEmpty);
      expect(body.keys, isNot(contains('monthly_rent_inr')));
      expect(body.keys, isNot(contains('name')));
      // No query parameters: they moved into the body.
      expect(post.queryParameters, isEmpty);
    });
  });

  group('owner scope and sign-out', () {
    testWidgets('an owner never sees the owner picker or sends owner_id', (
      tester,
    ) async {
      final app = await _open(tester, const MorePage());
      expect(find.text('Choose an owner'), findsNothing);
      await _open(tester, const PropertiesPage());
      expect(
        app.adapter.requests.where(
          (o) => o.queryParameters.containsKey('owner_id'),
        ),
        isEmpty,
      );
    });

    testWidgets('an agent picks an owner, and lists carry owner_id', (
      tester,
    ) async {
      final app = await _open(tester, const MorePage(), role: UserRole.agent);
      expect(find.text('Choose an owner'), findsOneWidget);

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '7');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Managing owner #7'), findsOneWidget);
      final container = app.container();
      expect(
        container.read(ownerScopeProvider),
        const OwnerScope(ownerId: 7, requiresOwner: true),
      );
      // The pick is kept for this account.
      expect(app.prefs.getInt(ownerPrefKey(7)), 7);
    });

    testWidgets('a stored owner is restored for an agent', (tester) async {
      final app = await _open(
        tester,
        const PropertiesPage(),
        role: UserRole.agent,
        ownerId: 9,
      );
      await tester.pumpAndSettle();
      final lists = app.adapter.requests.where(
        (o) => o.method == 'GET' && o.path == '/pm/properties',
      );
      expect(lists, isNotEmpty);
      expect(lists.last.queryParameters['owner_id'], 9);
    });

    testWidgets('sign-out drops the cache and the owner scope', (tester) async {
      final app = await _open(
        tester,
        const HomePage(),
        role: UserRole.agent,
        ownerId: 7,
      );
      final container = app.container();
      final cache = container.read(cacheStoreProvider);
      expect(cache.account, '7');
      expect(cache.get<Object>('dashboard:overview'), isNotNull);
      expect(container.read(accountScopeProvider), '7:7');

      // The token goes away: the session ended (sign-out or a 401).
      await container.read(authTokenStorageProvider).clear();
      await tester.pumpAndSettle();

      // The store is unbound from the account and the owner is dropped. (A page
      // that is still mounted may read again under the signed-out scope, so
      // the old entry is checked through the account it belonged to.)
      expect(cache.account, '');
      expect(container.read(ownerScopeProvider), OwnerScope.none);
      expect(container.read(accountScopeProvider), isNull);
      expect(
        container.read(authControllerProvider).status,
        AuthStatus.unauthenticated,
      );
      cache.bindAccount('7');
      expect(cache.get<Object>('dashboard:overview'), isNull);
    });
  });
}
