import 'package:dio/dio.dart';
import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/home/data/models/dashboard_overview_dto.dart';
import 'package:estate_app/features/home/data/models/activity_item_dto.dart';

/// Remote data source for dashboard data.
/// Uses /pm/dashboard/* endpoints from the backend.
abstract interface class DashboardRemoteDataSource {
  Future<DashboardOverviewDto> getOverview();

  Future<List<ActivityItemDto>> getRecentActivity({required int limit});
}

/// API implementation that fetches dashboard data from the PM module endpoints.
final class ApiDashboardRemoteDataSource implements DashboardRemoteDataSource {
  ApiDashboardRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<DashboardOverviewDto> getOverview() async {
    AppLogger.d(' Fetching dashboard overview from /pm/dashboard/overview');

    final response = await _apiClient.get<dynamic>(
      '/pm/dashboard/overview',
      options: Options(responseType: ResponseType.json),
    );

    final Object? data = response.data;
    if (data is Map<String, dynamic>) {
      AppLogger.d(' Dashboard overview fetched successfully');
      return DashboardOverviewDto.fromJson(data);
    } else if (data is Map<dynamic, dynamic>) {
      AppLogger.d(' Dashboard overview fetched successfully');
      return DashboardOverviewDto.fromJson(data.cast<String, dynamic>());
    }

    AppLogger.w(' Unexpected response format, returning empty dashboard');
    // Return default/empty dashboard if response is unexpected
    return DashboardOverviewDto.fromJson(const {
      'total_properties': 0,
      'occupied_properties': 0,
      'vacant_properties': 0,
      'under_maintenance_properties': 0,
      'monthly_revenue_current': 0.0,
      'monthly_revenue_previous': 0.0,
      'outstanding_rent_total': 0.0,
      'upcoming_expenses_total': 0.0,
    });
  }

  @override
  Future<List<ActivityItemDto>> getRecentActivity({required int limit}) async {
    AppLogger.d(' Fetching dashboard activity from /pm/dashboard/activity');

    final response = await _apiClient.get<dynamic>(
      '/pm/dashboard/activity',
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
      // Handle wrapped response format
      final itemsValue =
          data['activity'] ?? data['items'] ?? data['data'] ?? data['results'];
      rawItems = itemsValue is List<dynamic> ? itemsValue : <dynamic>[];
    } else {
      rawItems = <dynamic>[];
    }

    // Parse activity items from backend format
    // Backend returns: { type, at, id?, property_id?, lease_id?, amount?, status? }
    final items = <ActivityItemDto>[];
    var idCounter = 1;

    for (final item in rawItems) {
      if (item is Map<dynamic, dynamic>) {
        final json = item.cast<String, dynamic>();
        items.add(_parseActivityItem(json, idCounter++));
      }
    }

    AppLogger.d(' Fetched ${items.length} activity items');
    return items;
  }

  /// Parse activity item from backend response format
  /// Backend schema: { type, at, id?, property_id?, lease_id?, amount?, status? }
  ActivityItemDto _parseActivityItem(Map<String, dynamic> json, int fallbackId) {
    final type = json['type'] as String? ?? 'unknown';

    // Generate title and description based on activity type
    final String title;
    final String description;

    switch (type) {
      case 'payment_received':
        final amount = (json['amount'] as num?)?.toDouble() ?? 0;
        title = 'Payment Received';
        description = 'Rent payment of ₹${amount.toStringAsFixed(0)} received';
        break;
      case 'lease_created':
        title = 'New Lease Created';
        description = 'A new lease agreement was created';
        break;
      case 'lease_expiring':
        title = 'Lease Expiring Soon';
        description = 'A lease is expiring soon';
        break;
      case 'maintenance_request':
        final status = json['status'] as String?;
        title = 'Maintenance Request';
        description = status != null
            ? 'Maintenance request $status'
            : 'New maintenance request submitted';
        break;
      case 'rent_due':
        title = 'Rent Due';
        description = 'Rent payment is due';
        break;
      case 'rent_overdue':
        title = 'Rent Overdue';
        description = 'Rent payment is overdue';
        break;
      default:
        title = _formatActivityType(type);
        description = 'Activity recorded';
    }

    return ActivityItemDto(
      id: (json['id'] as num?)?.toInt() ?? fallbackId,
      type: type,
      timestamp: json['at'] != null
          ? DateTime.parse(json['at'] as String)
          : DateTime.now(),
      title: title,
      description: description,
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      leaseId: (json['lease_id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );
  }

  /// Convert snake_case type to a human-readable title
  String _formatActivityType(String type) {
    return type
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : word)
        .join(' ');
  }
}
