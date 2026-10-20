import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/theme/app_theme.dart';
import 'package:estate_app/features/home/home_providers.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:estate_app/features/home/presentation/home_page.dart';
import 'package:estate_app/features/inspections/presentation/inspection_form_page.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/more/expenses/presentation/expense_form_page.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:estate_app/features/tasks/presentation/task_create_page.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a screen with fake data providers. It proves the screens build and
/// that the pickers hold the backend choices. No network call is made.
Widget _app(Widget page, List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: page,
    ),
  );
}

const _properties = [
  Property(id: 1, title: '2 BHK Sector 51'),
  Property(id: 2, title: '1 BHK Sector 52'),
];

final _propertyOverride = propertiesListProvider.overrideWith(
  (ref) async => _properties,
);

void main() {
  testWidgets('expense form lists the property picker and every category', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const ExpenseFormPage(), [_propertyOverride]));
    await tester.pumpAndSettle();

    expect(find.text('Property'), findsWidgets);
    for (final category in ExpenseCategory.values) {
      expect(find.byType(ChoiceChip), findsWidgets);
      expect(
        find.text(switch (category) {
          ExpenseCategory.maintenance => 'Maintenance',
          ExpenseCategory.repairs => 'Repairs',
          ExpenseCategory.insurance => 'Insurance',
          ExpenseCategory.propertyTax => 'Property tax',
          ExpenseCategory.hoa => 'HOA',
          ExpenseCategory.utilities => 'Utilities',
          ExpenseCategory.marketing => 'Marketing',
          ExpenseCategory.legal => 'Legal',
          ExpenseCategory.other => 'Other',
        }),
        findsOneWidget,
      );
    }
    // The old label-only categories are gone.
    expect(find.text('Tax'), findsNothing);
    expect(find.text('Staff'), findsNothing);
    expect(find.text('Travel'), findsNothing);
  });

  testWidgets('expense form asks for a property before it saves', (
    tester,
  ) async {
    // A tall screen keeps the save button on screen.
    tester.view.physicalSize = const Size(900, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(const ExpenseFormPage(), [_propertyOverride]));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '500');
    await tester.pump();
    await tester.tap(find.text('Create expense'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a property.'), findsOneWidget);
  });

  testWidgets('inspection form picks a property, then one of its leases', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const InspectionFormPage(), [
        _propertyOverride,
        leasesListProvider.overrideWith(
          (ref, filter) async => [
            Lease(
              id: 31,
              propertyId: filter.propertyId,
              tenantName: 'Meera Nair',
              status: LeaseStatus.active,
            ),
          ],
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose a property to see its leases.'), findsOneWidget);
    for (final label in ['Move-in', 'Move-out', 'Routine']) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text('Property'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 BHK Sector 51').last);
    await tester.pumpAndSettle();
    expect(find.text('Lease'), findsWidgets);
  });

  testWidgets('task form offers urgency, not priority', (tester) async {
    await tester.pumpWidget(
      _app(const TaskCreatePage(), [
        _propertyOverride,
        assignedAgentProvider.overrideWith(
          (ref) async => (id: 12, name: 'Ravi Kumar'),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Urgency'), findsOneWidget);
    for (final label in ['Low', 'Medium', 'High', 'Emergency']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Priority'), findsNothing);
    expect(find.text('Assign to Ravi Kumar'), findsOneWidget);
  });

  testWidgets('home shows the dashboard figures the backend sends', (
    tester,
  ) async {
    // A tall screen builds the whole list (a ListView builds what is visible).
    tester.view.physicalSize = const Size(900, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _app(const HomePage(), [
        dashboardOverviewProvider.overrideWith(
          (ref) async => const DashboardOverview(
            totalProperties: 12,
            occupiedProperties: 9,
            vacantProperties: 2,
            underMaintenanceProperties: 1,
            monthlyRevenueCurrent: 284500.5,
            monthlyRevenuePrevious: 261000,
            outstandingRentTotal: 48000,
            upcomingExpensesTotal: 15300.25,
          ),
        ),
        dashboardActivityProvider.overrideWith(
          (ref) async => [
            DashboardActivityItem(
              type: ActivityType.rentPayment,
              at: DateTime.utc(2026, 10, 1, 10),
              title: 'Rent received',
              description: 'Rs 32,000 from Meera Nair',
            ),
          ],
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Properties'), findsWidgets);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('Rent received'), findsOneWidget);
    expect(find.text('Rs 32,000 from Meera Nair'), findsOneWidget);
    expect(find.textContaining('rent outstanding'), findsOneWidget);
    // The empty state shows only when there is no data.
    expect(find.text('No dashboard data yet'), findsNothing);
  });
}
