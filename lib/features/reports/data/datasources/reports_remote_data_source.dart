import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/reports/data/models/report_dto.dart';
import 'package:intl/intl.dart';

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

final class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  ReportsRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Future<RentRollReportDto> getRentRollReport() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/reports/rent-roll',
    );
    return RentRollReportDto.fromJson(response.data!);
  }

  @override
  Future<IncomeReportDto> getIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/reports/income',
      queryParameters: {
        'start': _dateFormat.format(startDate),
        'end': _dateFormat.format(endDate),
      },
    );
    return IncomeReportDto.fromJson(response.data!);
  }

  @override
  Future<ExpensesReportDto> getExpensesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/reports/expenses',
      queryParameters: {
        'start': _dateFormat.format(startDate),
        'end': _dateFormat.format(endDate),
      },
    );
    return ExpensesReportDto.fromJson(response.data!);
  }

  @override
  Future<ProfitAndLossReportDto> getProfitAndLossReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/reports/pnl',
      queryParameters: {
        'start': _dateFormat.format(startDate),
        'end': _dateFormat.format(endDate),
      },
    );
    return ProfitAndLossReportDto.fromJson(response.data!);
  }

  @override
  Future<OccupancyReportDto> getOccupancyReport() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/reports/occupancy',
    );
    return OccupancyReportDto.fromJson(response.data!);
  }

  @override
  Future<MaintenanceReportDto> getMaintenanceReport() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/pm/reports/maintenance',
    );
    return MaintenanceReportDto.fromJson(response.data!);
  }
}
