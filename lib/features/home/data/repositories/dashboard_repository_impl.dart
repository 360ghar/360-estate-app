import 'package:estate_app/features/home/data/datasources/dashboard_remote_data_source.dart';
import 'package:estate_app/features/home/domain/entities/activity_item.dart';
import 'package:estate_app/features/home/domain/entities/dashboard_overview.dart';
import 'package:estate_app/features/home/domain/repositories/dashboard_repository.dart';

final class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required DashboardRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final DashboardRemoteDataSource _dataSource;

  @override
  Future<DashboardOverview> getOverview() async {
    final dto = await _dataSource.getOverview();
    return dto.toEntity();
  }

  @override
  Future<List<ActivityItem>> getRecentActivity({int limit = 20}) async {
    final dtos = await _dataSource.getRecentActivity(limit: limit);
    return dtos.map((d) => d.toEntity()).toList(growable: false);
  }
}
