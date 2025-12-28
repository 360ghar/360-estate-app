import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/reports/domain/entities/report.dart';
import 'package:estate_app/features/reports/domain/repositories/reports_repository.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  ReportsController({required ReportsRepository repository})
      : _repository = repository;

  final ReportsRepository _repository;

  // Current report type selection
  final selectedReportType = Rx<ReportType?>(null);

  // Date range for reports that require it
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // Report states
  final rentRollState = Rx<ViewState<RentRollReport>>(const ViewState.idle());
  final incomeState = Rx<ViewState<IncomeReport>>(const ViewState.idle());
  final expensesState = Rx<ViewState<ExpensesReport>>(const ViewState.idle());
  final pnlState = Rx<ViewState<ProfitAndLossReport>>(const ViewState.idle());
  final occupancyState = Rx<ViewState<OccupancyReport>>(const ViewState.idle());
  final maintenanceState =
      Rx<ViewState<MaintenanceReport>>(const ViewState.idle());

  @override
  void onInit() {
    super.onInit();
    // Set default date range to current month
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month + 1, 0);
  }

  void selectReportType(ReportType type) {
    selectedReportType.value = type;
  }

  void setDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
  }

  Future<void> loadReport(ReportType type) async {
    switch (type) {
      case ReportType.rentRoll:
        await loadRentRollReport();
      case ReportType.income:
        await loadIncomeReport();
      case ReportType.expenses:
        await loadExpensesReport();
      case ReportType.profitAndLoss:
        await loadProfitAndLossReport();
      case ReportType.occupancy:
        await loadOccupancyReport();
      case ReportType.maintenance:
        await loadMaintenanceReport();
    }
  }

  Future<void> loadRentRollReport() async {
    rentRollState.value = const ViewState.loading();
    try {
      final report = await _repository.getRentRollReport();
      rentRollState.value = ViewState.success(report);
    } on Failure catch (e) {
      rentRollState.value = ViewState.error(e);
    } catch (e) {
      rentRollState.value = ViewState.error(
        UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> loadIncomeReport() async {
    if (startDate.value == null || endDate.value == null) return;

    incomeState.value = const ViewState.loading();
    try {
      final report = await _repository.getIncomeReport(
        startDate: startDate.value!,
        endDate: endDate.value!,
      );
      incomeState.value = ViewState.success(report);
    } on Failure catch (e) {
      incomeState.value = ViewState.error(e);
    } catch (e) {
      incomeState.value = ViewState.error(
        UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> loadExpensesReport() async {
    if (startDate.value == null || endDate.value == null) return;

    expensesState.value = const ViewState.loading();
    try {
      final report = await _repository.getExpensesReport(
        startDate: startDate.value!,
        endDate: endDate.value!,
      );
      expensesState.value = ViewState.success(report);
    } on Failure catch (e) {
      expensesState.value = ViewState.error(e);
    } catch (e) {
      expensesState.value = ViewState.error(
        UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> loadProfitAndLossReport() async {
    if (startDate.value == null || endDate.value == null) return;

    pnlState.value = const ViewState.loading();
    try {
      final report = await _repository.getProfitAndLossReport(
        startDate: startDate.value!,
        endDate: endDate.value!,
      );
      pnlState.value = ViewState.success(report);
    } on Failure catch (e) {
      pnlState.value = ViewState.error(e);
    } catch (e) {
      pnlState.value = ViewState.error(
        UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> loadOccupancyReport() async {
    occupancyState.value = const ViewState.loading();
    try {
      final report = await _repository.getOccupancyReport();
      occupancyState.value = ViewState.success(report);
    } on Failure catch (e) {
      occupancyState.value = ViewState.error(e);
    } catch (e) {
      occupancyState.value = ViewState.error(
        UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> loadMaintenanceReport() async {
    maintenanceState.value = const ViewState.loading();
    try {
      final report = await _repository.getMaintenanceReport();
      maintenanceState.value = ViewState.success(report);
    } on Failure catch (e) {
      maintenanceState.value = ViewState.error(e);
    } catch (e) {
      maintenanceState.value = ViewState.error(
        UnknownFailure(e.toString()),
      );
    }
  }
}
