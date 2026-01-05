import 'package:estate_app/features/home/domain/entities/dashboard_overview.dart';

final class DashboardOverviewDto {
  const DashboardOverviewDto({
    required this.totalProperties,
    required this.occupiedProperties,
    required this.vacantProperties,
    required this.underMaintenanceProperties,
    required this.monthlyRevenueCurrent,
    required this.monthlyRevenuePrevious,
    required this.outstandingRentTotal,
    required this.upcomingExpensesTotal,
  });

  factory DashboardOverviewDto.fromJson(Map<String, dynamic> json) {
    // Handle backend PM API format:
    // { total_properties, occupied_units, vacant_units, outstanding_rent, monthly_revenue, upcoming_expenses }
    return DashboardOverviewDto(
      totalProperties: (json['total_properties'] as num?)?.toInt() ?? 0,
      occupiedProperties: (json['occupied_units'] as num?)?.toInt() ??
          (json['occupied_properties'] as num?)?.toInt() ??
          0,
      vacantProperties: (json['vacant_units'] as num?)?.toInt() ??
          (json['vacant_properties'] as num?)?.toInt() ??
          0,
      underMaintenanceProperties:
          (json['under_maintenance_properties'] as num?)?.toInt() ?? 0,
      monthlyRevenueCurrent: (json['monthly_revenue'] as num?)?.toDouble() ??
          (json['monthly_revenue_current'] as num?)?.toDouble() ??
          0,
      monthlyRevenuePrevious:
          (json['monthly_revenue_previous'] as num?)?.toDouble() ?? 0,
      outstandingRentTotal: (json['outstanding_rent'] as num?)?.toDouble() ??
          (json['outstanding_rent_total'] as num?)?.toDouble() ??
          0,
      upcomingExpensesTotal: (json['upcoming_expenses'] as num?)?.toDouble() ??
          (json['upcoming_expenses_total'] as num?)?.toDouble() ??
          0,
    );
  }

  final int totalProperties;
  final int occupiedProperties;
  final int vacantProperties;
  final int underMaintenanceProperties;
  final double monthlyRevenueCurrent;
  final double monthlyRevenuePrevious;
  final double outstandingRentTotal;
  final double upcomingExpensesTotal;

  DashboardOverview toEntity() {
    return DashboardOverview(
      totalProperties: totalProperties,
      occupiedProperties: occupiedProperties,
      vacantProperties: vacantProperties,
      underMaintenanceProperties: underMaintenanceProperties,
      monthlyRevenueCurrent: monthlyRevenueCurrent,
      monthlyRevenuePrevious: monthlyRevenuePrevious,
      outstandingRentTotal: outstandingRentTotal,
      upcomingExpensesTotal: upcomingExpensesTotal,
    );
  }
}
