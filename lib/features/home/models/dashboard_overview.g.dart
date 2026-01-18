// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardOverviewImpl _$$DashboardOverviewImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardOverviewImpl(
  propertiesCount: parseInt(json['properties']),
  tenantsCount: parseInt(json['tenants']),
  chargesDue: parseInt(json['charges_due']),
  chargesOverdue: parseInt(json['charges_overdue']),
  maintenanceOpen: parseInt(json['maintenance_open']),
  rentCollected: parseDouble(json['rent_collected']),
  occupancyRate: parseDouble(json['occupancy_rate']),
);

Map<String, dynamic> _$$DashboardOverviewImplToJson(
  _$DashboardOverviewImpl instance,
) => <String, dynamic>{
  'properties': instance.propertiesCount,
  'tenants': instance.tenantsCount,
  'charges_due': instance.chargesDue,
  'charges_overdue': instance.chargesOverdue,
  'maintenance_open': instance.maintenanceOpen,
  'rent_collected': instance.rentCollected,
  'occupancy_rate': instance.occupancyRate,
};
