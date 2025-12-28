import 'package:estate_app/features/reports/domain/entities/report.dart';

abstract interface class ReportsRepository {
  /// Get rent roll report - current rent status for all properties
  Future<RentRollReport> getRentRollReport();

  /// Get income report for date range
  Future<IncomeReport> getIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get expenses report for date range
  Future<ExpensesReport> getExpensesReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get profit & loss report for date range
  Future<ProfitAndLossReport> getProfitAndLossReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get occupancy report - vacancy rates
  Future<OccupancyReport> getOccupancyReport();

  /// Get maintenance report - maintenance costs and completion rates
  Future<MaintenanceReport> getMaintenanceReport();
}
