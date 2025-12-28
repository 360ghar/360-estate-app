final class DashboardOverview {
  const DashboardOverview({
    required this.totalProperties,
    required this.occupiedProperties,
    required this.vacantProperties,
    required this.underMaintenanceProperties,
    required this.monthlyRevenueCurrent,
    required this.monthlyRevenuePrevious,
    required this.outstandingRentTotal,
    required this.upcomingExpensesTotal,
  });

  final int totalProperties;
  final int occupiedProperties;
  final int vacantProperties;
  final int underMaintenanceProperties;
  final double monthlyRevenueCurrent;
  final double monthlyRevenuePrevious;
  final double outstandingRentTotal;
  final double upcomingExpensesTotal;

  double get occupancyRate =>
      totalProperties > 0 ? occupiedProperties / totalProperties : 0;

  double get revenueChangePercent {
    if (monthlyRevenuePrevious == 0) return 0;
    return ((monthlyRevenueCurrent - monthlyRevenuePrevious) /
            monthlyRevenuePrevious) *
        100;
  }
}
