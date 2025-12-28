import 'package:estate_app/features/home/domain/entities/activity_item.dart';
import 'package:estate_app/features/home/domain/entities/dashboard_overview.dart';

abstract interface class DashboardRepository {
  Future<DashboardOverview> getOverview();
  Future<List<ActivityItem>> getRecentActivity({int limit = 20});
}
