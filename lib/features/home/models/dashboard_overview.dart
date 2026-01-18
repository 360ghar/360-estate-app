import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_overview.freezed.dart';
part 'dashboard_overview.g.dart';

@freezed
class DashboardOverview with _$DashboardOverview {
  const factory DashboardOverview({
    @JsonKey(name: 'properties', fromJson: parseInt) int? propertiesCount,
    @JsonKey(name: 'tenants', fromJson: parseInt) int? tenantsCount,
    @JsonKey(name: 'charges_due', fromJson: parseInt) int? chargesDue,
    @JsonKey(name: 'charges_overdue', fromJson: parseInt) int? chargesOverdue,
    @JsonKey(name: 'maintenance_open', fromJson: parseInt) int? maintenanceOpen,
    @JsonKey(name: 'rent_collected', fromJson: parseDouble) double? rentCollected,
    @JsonKey(name: 'occupancy_rate', fromJson: parseDouble) double? occupancyRate,
  }) = _DashboardOverview;

  factory DashboardOverview.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewFromJson(json);
}

extension DashboardOverviewX on DashboardOverview {
  int get properties => propertiesCount ?? 0;
  int get tenants => tenantsCount ?? 0;
  int get due => chargesDue ?? 0;
  int get overdue => chargesOverdue ?? 0;
  int get maintenance => maintenanceOpen ?? 0;
  double get collected => rentCollected ?? 0;
  double get occupancy => occupancyRate ?? 0;
}
