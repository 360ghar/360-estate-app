import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Centralized analytics service for tracking user behavior and app events.
///
/// Integrates with Firebase Analytics for production analytics tracking.
/// Falls back to console logging in development or when analytics is disabled.
final class AnalyticsService {
  AnalyticsService({required AppConfig config})
      : _enabled = config.enableAnalytics,
        _analytics =
            config.enableAnalytics ? _safeAnalyticsInstance() : null;

  static FirebaseAnalytics? _safeAnalyticsInstance() {
    try {
      return FirebaseAnalytics.instance;
    } catch (e, st) {
      AppLogger.w('Firebase Analytics not available', error: e, stackTrace: st);
      return null;
    }
  }

  final bool _enabled;
  final FirebaseAnalytics? _analytics;

  // Singleton pattern
  static AnalyticsService? _instance;

  static AnalyticsService get instance {
    return _instance!;
  }

  static void initialize({required AppConfig config}) {
    _instance ??= AnalyticsService(config: config);
    AppLogger.d(
      'AnalyticsService initialized (enabled: ${config.enableAnalytics})',
    );
  }

  /// Track a screen view
  Future<void> trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_enabled) return;
    
    try {
      await _analytics?.logScreenView(
        screenName: screenName,
        parameters: parameters?.map((k, v) => MapEntry(k, v as Object)),
      );
      AppLogger.d(
        'Screen view: $screenName ${parameters != null ? "[$parameters]" : ""}',
      );
    } catch (e) {
      AppLogger.w('Failed to track screen view', error: e);
    }
  }

  /// Track a user action/event
  Future<void> trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_enabled) return;
    
    try {
      await _analytics?.logEvent(
        name: eventName,
        parameters: parameters?.map((k, v) => MapEntry(k, v as Object)),
      );
      AppLogger.d(
        'Event: $eventName ${parameters != null ? "[$parameters]" : ""}',
      );
    } catch (e) {
      AppLogger.w('Failed to track event', error: e);
    }
  }

  /// Track an error
  Future<void> trackError({
    required String error,
    String? stackTrace,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_enabled) return;
    
    try {
      await _analytics?.logEvent(
        name: 'app_error',
        parameters: {
          'error_message': error,
          if (stackTrace != null) 'stack_trace': stackTrace,
          ...?parameters,
        },
      );
      AppLogger.e(
        'Error: $error ${parameters != null ? "[$parameters]" : ""}',
      );
    } catch (e) {
      AppLogger.w('Failed to track error', error: e);
    }
  }

  /// Track user property
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    if (!_enabled) return;
    
    try {
      await _analytics?.setUserProperty(name: name, value: value);
      AppLogger.d('User property: $name = $value');
    } catch (e) {
      AppLogger.w('Failed to set user property', error: e);
    }
  }

  /// Set user ID for analytics
  Future<void> setUserId(String? userId) async {
    if (!_enabled) return;
    
    try {
      await _analytics?.setUserId(id: userId);
      AppLogger.d('User ID: $userId');
    } catch (e) {
      AppLogger.w('Failed to set user ID', error: e);
    }
  }

  // Common event tracking methods

  /// Track property created
  Future<void> trackPropertyCreated({required String propertyId}) async {
    await trackEvent(
      eventName: 'property_created',
      parameters: {'property_id': propertyId},
    );
  }

  /// Track property viewed
  Future<void> trackPropertyViewed({required String propertyId}) async {
    await trackEvent(
      eventName: 'property_viewed',
      parameters: {'property_id': propertyId},
    );
  }

  /// Track tenant created
  Future<void> trackTenantCreated({required String tenantId}) async {
    await trackEvent(
      eventName: 'tenant_created',
      parameters: {'tenant_id': tenantId},
    );
  }

  /// Track payment recorded
  Future<void> trackPaymentRecorded({
    required String chargeId,
    required double amount,
  }) async {
    await trackEvent(
      eventName: 'payment_recorded',
      parameters: {
        'charge_id': chargeId,
        'amount': amount,
      },
    );
  }

  /// Track search performed
  Future<void> trackSearch({
    required String query,
    required int resultCount,
  }) async {
    await trackEvent(
      eventName: 'search_performed',
      parameters: {
        'query': query,
        'result_count': resultCount,
      },
    );
  }

  /// Track lease created
  Future<void> trackLeaseCreated({required String leaseId}) async {
    await trackEvent(
      eventName: 'lease_created',
      parameters: {'lease_id': leaseId},
    );
  }

  /// Track expense created
  Future<void> trackExpenseCreated({
    required String expenseId,
    required double amount,
  }) async {
    await trackEvent(
      eventName: 'expense_created',
      parameters: {
        'expense_id': expenseId,
        'amount': amount,
      },
    );
  }

  /// Track login
  Future<void> trackLogin({required String method}) async {
    await _analytics?.logLogin(loginMethod: method);
  }

  /// Track sign up
  Future<void> trackSignUp({required String method}) async {
    await _analytics?.logSignUp(signUpMethod: method);
  }

  /// Track search
  Future<void> trackFirebaseSearch({
    required String query,
    int? resultCount,
  }) async {
    await _analytics?.logSearch(searchTerm: query);
  }
}
