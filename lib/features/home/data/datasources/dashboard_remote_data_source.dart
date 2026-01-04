import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/home/data/models/dashboard_overview_dto.dart';
import 'package:estate_app/features/home/data/models/activity_item_dto.dart';

/// Remote data source for dashboard data.
/// NOTE: The PM dashboard endpoints do not yet exist in the backend.
abstract interface class DashboardRemoteDataSource {
  Future<DashboardOverviewDto> getOverview();

  Future<List<ActivityItemDto>> getRecentActivity({required int limit});
}

/// Stub implementation that returns placeholder data since PM dashboard endpoints
/// are not available in the current backend.
final class ApiDashboardRemoteDataSource implements DashboardRemoteDataSource {
  ApiDashboardRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DashboardOverviewDto> getOverview() async {
    print('[DASHBOARD] WARNING: PM dashboard endpoint not available');
    // Return a placeholder with zeros
    return DashboardOverviewDto.fromJson(const {
      'total_properties': 0,
      'occupied_units': 0,
      'vacant_units': 0,
      'active_leases': 0,
      'pending_applications': 0,
      'open_maintenance_requests': 0,
      'total_rent_collected': 0.0,
      'total_outstanding': 0.0,
    });
  }

  @override
  Future<List<ActivityItemDto>> getRecentActivity({required int limit}) async {
    print('[DASHBOARD] WARNING: PM dashboard endpoint not available');
    return [];
  }
}

