import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  group('dashboard', () {
    test('overview reads the backend keys', () {
      final overview = DashboardOverview.fromJson(
        loadFixture('dashboard')['overview'] as Map<String, dynamic>,
      );
      expect(overview.totalProperties, 12);
      expect(overview.occupiedProperties, 9);
      expect(overview.vacantProperties, 2);
      expect(overview.underMaintenanceProperties, 1);
      expect(overview.monthlyRevenueCurrent, 284500.5);
      expect(overview.monthlyRevenuePrevious, 261000);
      expect(overview.outstandingRentTotal, 48000);
      expect(overview.upcomingExpensesTotal, 15300.25);
      expect(overview.occupancyPercent, 75);
    });

    test('activity reads at, title, description and type', () {
      final page = unwrapPage(loadPage('dashboard', 'activity_page'));
      final items = page.items
          .cast<Map<String, dynamic>>()
          .map(DashboardActivityItem.fromJson)
          .toList();
      expect(items[0].type, ActivityType.rentPayment);
      expect(items[0].title, 'Rent received');
      expect(items[0].description, 'Rs 32,000 from Meera Nair');
      expect(items[0].at, DateTime.utc(2026, 10, 1, 10, 15, 2));
      expect(items[0].amount, 32000);
      expect(items[1].type, ActivityType.maintenanceRequest);
      expect(items[1].description, isNull);
      expect(items[2].type, ActivityType.lease);
    });
  });

  group('reports', () {
    final fixtures = loadFixture('reports');

    test('rent roll reads the CursorPage items', () {
      final page = unwrapPage(loadPage('reports', 'rent_roll_page'));
      final rows = page.items
          .cast<Map<String, dynamic>>()
          .map(ReportRowMapper.rentRollItem)
          .toList();
      expect(rows, hasLength(2));
      expect(rows[0].label, '2 BHK Sector 51');
      expect(rows[0].amount, 32000);
      expect(rows[0].detail, startsWith('Occupied'));
      expect(rows[1].label, '1 BHK Sector 52');
      expect(rows[1].amount, isNull);
      expect(rows[1].value, 'Vacant');
      expect(loadPage('reports', 'rent_roll_page')['limit'], 100);
    });

    test('rent roll shows no status for an unknown occupancy value', () {
      final row = ReportRowMapper.rentRollItem({
        'title': 'Villa',
        'occupancy': 'under_renovation',
      });
      expect(row.value, isNull);
      expect(row.detail, isNull);
    });

    test('income, expenses and P&L become labelled money rows', () {
      final income = ReportRowMapper.income(
        fixtures['income'] as Map<String, dynamic>,
      );
      expect(income[0].label, 'Total income');
      expect(income[0].amount, 284500.5);
      expect(income[1].value, '1 Oct 2026 - 31 Oct 2026');

      final allTime = ReportRowMapper.income(
        fixtures['income_all_time'] as Map<String, dynamic>,
      );
      expect(allTime[1].value, 'All time');

      final expenses = ReportRowMapper.expenses(
        fixtures['expenses'] as Map<String, dynamic>,
      );
      expect(expenses[0].amount, 15300.25);

      final pnl = ReportRowMapper.pnl(fixtures['pnl'] as Map<String, dynamic>);
      expect(pnl.map((row) => row.label), [
        'Total income',
        'Total expenses',
        'Net income',
        'Period',
      ]);
      expect(pnl[2].amount, 269200.25);
    });

    test('occupancy and maintenance reports map their counts', () {
      final occupancy = ReportRowMapper.occupancy(
        fixtures['occupancy'] as Map<String, dynamic>,
      );
      expect(occupancy.map((row) => row.value), ['12', '9', '3', '75%']);

      final maintenance = ReportRowMapper.maintenance(
        fixtures['maintenance'] as Map<String, dynamic>,
      );
      expect(maintenance.single.value, '7');
    });
  });
}
