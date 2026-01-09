import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:get/get.dart';

/// Manages search history for a specific search type.
///
/// Provides functionality to add, retrieve, and clear search history
/// items. History is persisted using [AppPreferences].
class SearchHistory {
  SearchHistory(this._key, this._preferences);

  final String _key;
  final AppPreferences _preferences;

  static const int _maxHistoryItems = 10;

  /// Get the search history for this key.
  Future<List<String>> getHistory() async {
    return _preferences.getStringList(_key) ?? [];
  }

  /// Add a search query to history.
  ///
  /// The query will be added to the top of the list and duplicates
  /// will be removed. The list is limited to [_maxHistoryItems].
  Future<void> addQuery(String query) async {
    if (query.trim().isEmpty) return;

    final history = await getHistory();
    
    // Remove if already exists (to move to top)
    history.remove(query);
    
    // Add to front
    history.insert(0, query);
    
    // Limit to max items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }
    
    await _preferences.setStringList(_key, history);
  }

  /// Clear all search history for this key.
  Future<void> clear() async {
    await _preferences.remove(_key);
  }

  /// Remove a specific query from history.
  Future<void> removeQuery(String query) async {
    final history = await getHistory();
    history.remove(query);
    await _preferences.setStringList(_key, history);
  }
}

/// Keys for search history.
abstract final class SearchHistoryKeys {
  static const String properties = 'search_history_properties';
  static const String tenants = 'search_history_tenants';
  static const String leases = 'search_history_leases';
  static const String finance = 'search_history_finance';
  static const String maintenance = 'search_history_maintenance';
}

/// Helper to create SearchHistory instances.
class SearchHistoryFactory {
  static SearchHistory propertiesSearch() {
    return SearchHistory(
      SearchHistoryKeys.properties,
      Get.find<AppPreferences>(),
    );
  }

  static SearchHistory tenantsSearch() {
    return SearchHistory(
      SearchHistoryKeys.tenants,
      Get.find<AppPreferences>(),
    );
  }

  static SearchHistory leasesSearch() {
    return SearchHistory(
      SearchHistoryKeys.leases,
      Get.find<AppPreferences>(),
    );
  }
}
