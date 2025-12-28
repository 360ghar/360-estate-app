import 'package:estate_app/features/home/domain/entities/activity_item.dart';
import 'package:estate_app/features/home/domain/repositories/dashboard_repository.dart';

final class GetRecentActivityUseCase {
  GetRecentActivityUseCase(this._repository);

  final DashboardRepository _repository;

  Future<List<ActivityItem>> call({int limit = 20}) {
    return _repository.getRecentActivity(limit: limit);
  }
}
