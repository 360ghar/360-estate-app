import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/home/data/dashboard_repository.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    ref.read(apiClientProvider),
    ref.read(cacheStoreProvider),
  );
});

final dashboardOverviewProvider = FutureProvider<DashboardOverview>((ref) {
  return ref.read(dashboardRepositoryProvider).fetchOverview();
});

final dashboardActivityProvider = FutureProvider<List<DashboardActivityItem>>(
  (ref) {
    return ref.read(dashboardRepositoryProvider).fetchActivity();
  },
);
