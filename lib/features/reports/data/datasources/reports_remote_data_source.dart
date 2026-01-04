import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/reports/data/models/report_dto.dart';

/// Remote data source for reports and analytics.
/// NOTE: The PM reports endpoints (/pm/reports/*) do not yet exist in the backend.
abstract interface class ReportsRemoteDataSource {
  Future<RentRollReportDto> getRentRollReport();

  Future<IncomeReportDto> getIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<ExpensesReportDto> getExpensesReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<ProfitAndLossReportDto> getProfitAndLossReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<OccupancyReportDto> getOccupancyReport();

  Future<MaintenanceReportDto> getMaintenanceReport();
}

/// Stub implementation that returns empty data since PM reports endpoints
/// are not available in the current backend.
final class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  ReportsRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<RentRollReportDto> getRentRollReport() async {
    print('[REPORTS] WARNING: PM reports endpoint not available');
    return RentRollReportDto.empty();
  }

  @override
  Future<IncomeReportDto> getIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    print('[REPORTS] WARNING: PM reports endpoint not available');
    return IncomeReportDto.empty();
  }

  @override
  Future<ExpensesReportDto> getExpensesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    print('[REPORTS] WARNING: PM reports endpoint not available');
    return ExpensesReportDto.empty();
  }

  @override
  Future<ProfitAndLossReportDto> getProfitAndLossReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    print('[REPORTS] WARNING: PM reports endpoint not available');
    return ProfitAndLossReportDto.empty();
  }

  @override
  Future<OccupancyReportDto> getOccupancyReport() async {
    print('[REPORTS] WARNING: PM reports endpoint not available');
    return OccupancyReportDto.empty();
  }

  @override
  Future<MaintenanceReportDto> getMaintenanceReport() async {
    print('[REPORTS] WARNING: PM reports endpoint not available');
    return MaintenanceReportDto.empty();
  }
}

