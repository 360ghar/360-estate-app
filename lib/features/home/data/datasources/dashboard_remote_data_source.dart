import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/home/data/models/activity_item_dto.dart';
import 'package:estate_app/features/home/data/models/dashboard_overview_dto.dart';

abstract interface class DashboardRemoteDataSource {
  Future<DashboardOverviewDto> getOverview();
  Future<List<ActivityItemDto>> getRecentActivity({int limit = 20});
}

final class ApiDashboardRemoteDataSource implements DashboardRemoteDataSource {
  ApiDashboardRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<DashboardOverviewDto> getOverview() async {
    final response = await _client.get<dynamic>(
      '/api/v1/pm/dashboard/overview',
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    if (data is Map<String, dynamic>) {
      return DashboardOverviewDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      return DashboardOverviewDto.fromJson(data.cast<String, dynamic>());
    }

    return const DashboardOverviewDto(
      totalProperties: 0,
      occupiedProperties: 0,
      vacantProperties: 0,
      underMaintenanceProperties: 0,
      monthlyRevenueCurrent: 0,
      monthlyRevenuePrevious: 0,
      outstandingRentTotal: 0,
      upcomingExpensesTotal: 0,
    );
  }

  @override
  Future<List<ActivityItemDto>> getRecentActivity({int limit = 20}) async {
    final response = await _client.get<dynamic>(
      '/api/v1/pm/dashboard/activity',
      queryParameters: <String, dynamic>{
        'limit': limit,
      },
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;

    final List<dynamic> rawItems;

    if (data is List<dynamic>) {
      rawItems = data;
    } else if (data is Map<String, dynamic>) {
      final itemsValue = data['items'] ?? data['data'] ?? data['activities'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];
    } else if (data is Map<dynamic, dynamic>) {
      final map = data.cast<String, dynamic>();
      final itemsValue = map['items'] ?? map['data'] ?? map['activities'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];
    } else {
      rawItems = <dynamic>[];
    }

    return rawItems
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => m.cast<String, dynamic>())
        .map(ActivityItemDto.fromJson)
        .toList(growable: false);
  }
}
