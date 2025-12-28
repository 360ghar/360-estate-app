import 'package:estate_app/features/reports/data/datasources/reports_remote_data_source.dart';
import 'package:estate_app/features/reports/domain/entities/report.dart';
import 'package:estate_app/features/reports/domain/repositories/reports_repository.dart';

final class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl({required ReportsRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final ReportsRemoteDataSource _dataSource;

  @override
  Future<RentRollReport> getRentRollReport() async {
    final dto = await _dataSource.getRentRollReport();
    return dto.toEntity();
  }

  @override
  Future<IncomeReport> getIncomeReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dto = await _dataSource.getIncomeReport(
      startDate: startDate,
      endDate: endDate,
    );
    return dto.toEntity();
  }

  @override
  Future<ExpensesReport> getExpensesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dto = await _dataSource.getExpensesReport(
      startDate: startDate,
      endDate: endDate,
    );
    return dto.toEntity();
  }

  @override
  Future<ProfitAndLossReport> getProfitAndLossReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dto = await _dataSource.getProfitAndLossReport(
      startDate: startDate,
      endDate: endDate,
    );
    return dto.toEntity();
  }

  @override
  Future<OccupancyReport> getOccupancyReport() async {
    final dto = await _dataSource.getOccupancyReport();
    return dto.toEntity();
  }

  @override
  Future<MaintenanceReport> getMaintenanceReport() async {
    final dto = await _dataSource.getMaintenanceReport();
    return dto.toEntity();
  }
}
