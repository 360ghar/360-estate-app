// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardOverviewImpl _$$DashboardOverviewImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardOverviewImpl(
  totalProperties: parseInt(json['total_properties']),
  occupiedProperties: parseInt(json['occupied_properties']),
  vacantProperties: parseInt(json['vacant_properties']),
  underMaintenanceProperties: parseInt(json['under_maintenance_properties']),
  monthlyRevenueCurrent: parseDouble(json['monthly_revenue_current']),
  monthlyRevenuePrevious: parseDouble(json['monthly_revenue_previous']),
  outstandingRentTotal: parseDouble(json['outstanding_rent_total']),
  upcomingExpensesTotal: parseDouble(json['upcoming_expenses_total']),
);

Map<String, dynamic> _$$DashboardOverviewImplToJson(
  _$DashboardOverviewImpl instance,
) => <String, dynamic>{
  'total_properties': instance.totalProperties,
  'occupied_properties': instance.occupiedProperties,
  'vacant_properties': instance.vacantProperties,
  'under_maintenance_properties': instance.underMaintenanceProperties,
  'monthly_revenue_current': instance.monthlyRevenueCurrent,
  'monthly_revenue_previous': instance.monthlyRevenuePrevious,
  'outstanding_rent_total': instance.outstandingRentTotal,
  'upcoming_expenses_total': instance.upcomingExpensesTotal,
};
