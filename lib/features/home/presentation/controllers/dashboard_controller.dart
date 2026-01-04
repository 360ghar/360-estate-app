import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/home/domain/entities/activity_item.dart';
import 'package:estate_app/features/home/domain/entities/dashboard_overview.dart';
import 'package:estate_app/features/home/domain/usecases/get_dashboard_overview_usecase.dart';
import 'package:estate_app/features/home/domain/usecases/get_recent_activity_usecase.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  DashboardController({
    required GetDashboardOverviewUseCase getDashboardOverview,
    required GetRecentActivityUseCase getRecentActivity,
  })  : _getDashboardOverview = getDashboardOverview,
        _getRecentActivity = getRecentActivity;

  final GetDashboardOverviewUseCase _getDashboardOverview;
  final GetRecentActivityUseCase _getRecentActivity;

  final Rx<ViewState<DashboardOverview>> overviewState =
      const ViewState<DashboardOverview>.idle().obs;

  final Rx<ViewState<List<ActivityItem>>> activityState =
      const ViewState<List<ActivityItem>>.idle().obs;

  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadDashboard());
  }

  Future<void> loadDashboard() async {
    overviewState.value = const ViewState.loading();
    activityState.value = const ViewState.loading();

    await Future.wait([
      _loadOverview(),
      _loadActivity(),
    ]);
  }

  @override
  Future<void> refresh() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;

    await Future.wait([
      _loadOverview(),
      _loadActivity(),
    ]);

    isRefreshing.value = false;
  }

  Future<void> _loadOverview() async {
    try {
      final overview = await _getDashboardOverview();
      // Check if dashboard is empty (all zeros)
      if (overview.totalProperties == 0 &&
          overview.occupiedProperties == 0 &&
          overview.vacantProperties == 0 &&
          overview.monthlyRevenueCurrent == 0) {
        overviewState.value = const ViewState.empty();
      } else {
        overviewState.value = ViewState.success(overview);
      }
    } on Failure catch (f) {
      overviewState.value = ViewState.error(f);
    } catch (e) {
      overviewState.value = ViewState.error(
        UnknownFailure('Failed to load dashboard', cause: e),
      );
    }
  }

  Future<void> _loadActivity() async {
    try {
      final activities = await _getRecentActivity();
      if (activities.isEmpty) {
        activityState.value = const ViewState.empty();
      } else {
        activityState.value = ViewState.success(activities);
      }
    } on Failure catch (f) {
      activityState.value = ViewState.error(f);
    } catch (e) {
      activityState.value = ViewState.error(
        UnknownFailure('Failed to load activity', cause: e),
      );
    }
  }
}
