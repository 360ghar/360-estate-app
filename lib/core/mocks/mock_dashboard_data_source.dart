/// Mock implementation of DashboardRemoteDataSource for development/demo mode.
library;

import 'package:estate_app/core/mocks/mock_data_factory.dart';
import 'package:estate_app/features/home/data/datasources/dashboard_remote_data_source.dart';
import 'package:estate_app/features/home/data/models/activity_item_dto.dart';
import 'package:estate_app/features/home/data/models/dashboard_overview_dto.dart';

final class MockDashboardRemoteDataSource implements DashboardRemoteDataSource {
  MockDashboardRemoteDataSource();

  @override
  Future<DashboardOverviewDto> getOverview() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 250));

    final data = MockDataFactory.dashboardOverview;
    return DashboardOverviewDto.fromJson(data);
  }

  @override
  Future<List<ActivityItemDto>> getRecentActivity({int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final activities = MockDataFactory.recentActivities.take(limit).toList();

    return activities.map((a) {
      // Convert to DTO JSON format (ActivityItemDto.fromJson expects 'at' for timestamp)
      final json = <String, dynamic>{
        'id': a['id'] as int,
        'type': a['type'] as String,
        'at': a['timestamp'] as String,
        'title': a['title'] as String,
        'description': a['description'] as String,
        'property_id': a['property_id'] as int?,
        'property_name': a['property_title'] as String?,
      };
      return ActivityItemDto.fromJson(json);
    }).toList();
  }
}

