import 'package:estate_app/core/logger/app_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Service that monitors app lifecycle and triggers refresh when app resumes.
/// This ensures fresh data is loaded whenever the user returns to the app.
class AppLifecycleService extends GetxService with WidgetsBindingObserver {
  /// Minimum duration between refreshes (prevents rapid refresh on quick resume)
  static const Duration _minRefreshInterval = Duration(seconds: 30);

  DateTime? _lastRefreshTime;

  /// Callbacks to be called when app resumes
  final List<VoidCallback> _refreshCallbacks = [];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _lastRefreshTime = DateTime.now();
    AppLogger.d(' AppLifecycleService initialized');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshCallbacks.clear();
    AppLogger.d(' AppLifecycleService closed');
    super.onClose();
  }

  /// Register a callback to be called when app resumes
  void registerRefreshCallback(VoidCallback callback) {
    if (!_refreshCallbacks.contains(callback)) {
      _refreshCallbacks.add(callback);
      AppLogger.d(
          ' Registered refresh callback (total: ${_refreshCallbacks.length})');
    }
  }

  /// Unregister a previously registered callback
  void unregisterRefreshCallback(VoidCallback callback) {
    _refreshCallbacks.remove(callback);
    AppLogger.d(
        ' Unregistered refresh callback (total: ${_refreshCallbacks.length})');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.d(' App state changed to: $state');

    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  void _onAppResumed() {
    final now = DateTime.now();

    // Check if enough time has passed since last refresh
    if (_lastRefreshTime != null) {
      final elapsed = now.difference(_lastRefreshTime!);
      if (elapsed < _minRefreshInterval) {
        AppLogger.d(
            ' Skipping refresh - only ${elapsed.inSeconds}s since last refresh');
        return;
      }
    }

    AppLogger.d(
        ' App resumed - triggering ${_refreshCallbacks.length} refresh callbacks');
    _lastRefreshTime = now;

    // Trigger all registered refresh callbacks
    for (final callback in _refreshCallbacks) {
      try {
        callback();
      } catch (e) {
        AppLogger.d(' Error in refresh callback: $e');
      }
    }
  }

  /// Force a refresh regardless of time elapsed (for manual pull-to-refresh)
  void forceRefresh() {
    AppLogger.d(' Force refresh triggered');
    _lastRefreshTime = DateTime.now();

    for (final callback in _refreshCallbacks) {
      try {
        callback();
      } catch (e) {
        AppLogger.d(' Error in refresh callback: $e');
      }
    }
  }
}
