import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_overview.freezed.dart';
part 'dashboard_overview.g.dart';

/// `GET /pm/dashboard/overview` (`DashboardOverview`). Money is a JSON number.
/// Revenue and outstanding rent count settled payments only.
@freezed
class DashboardOverview with _$DashboardOverview {
  const factory DashboardOverview({
    @JsonKey(name: 'total_properties', fromJson: parseInt) int? totalProperties,
    @JsonKey(name: 'occupied_properties', fromJson: parseInt)
    int? occupiedProperties,
    @JsonKey(name: 'vacant_properties', fromJson: parseInt)
    int? vacantProperties,
    @JsonKey(name: 'under_maintenance_properties', fromJson: parseInt)
    int? underMaintenanceProperties,
    @JsonKey(name: 'monthly_revenue_current', fromJson: parseDouble)
    double? monthlyRevenueCurrent,
    @JsonKey(name: 'monthly_revenue_previous', fromJson: parseDouble)
    double? monthlyRevenuePrevious,
    @JsonKey(name: 'outstanding_rent_total', fromJson: parseDouble)
    double? outstandingRentTotal,
    @JsonKey(name: 'upcoming_expenses_total', fromJson: parseDouble)
    double? upcomingExpensesTotal,
  }) = _DashboardOverview;

  factory DashboardOverview.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewFromJson(json);
}

extension DashboardOverviewX on DashboardOverview {
  int get properties => totalProperties ?? 0;
  int get occupied => occupiedProperties ?? 0;
  int get vacant => vacantProperties ?? 0;
  int get underMaintenance => underMaintenanceProperties ?? 0;
  double get revenueCurrent => monthlyRevenueCurrent ?? 0;
  double get revenuePrevious => monthlyRevenuePrevious ?? 0;
  double get outstanding => outstandingRentTotal ?? 0;
  double get upcomingExpenses => upcomingExpensesTotal ?? 0;

  /// Occupied share of all properties, 0 to 100.
  double get occupancyPercent =>
      properties == 0 ? 0 : occupied * 100 / properties;
}
