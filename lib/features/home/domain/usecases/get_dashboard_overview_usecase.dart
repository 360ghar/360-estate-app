import 'package:estate_app/features/home/domain/entities/dashboard_overview.dart';
import 'package:estate_app/features/home/domain/repositories/dashboard_repository.dart';

final class GetDashboardOverviewUseCase {
  GetDashboardOverviewUseCase(this._repository);

  final DashboardRepository _repository;

  Future<DashboardOverview> call() {
    return _repository.getOverview();
  }
}
