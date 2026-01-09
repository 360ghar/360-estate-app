import 'dart:async';
import 'package:estate_app/core/presentation/utils/search_history.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A reusable search bottom sheet with recent search history.
///
/// Provides a consistent search experience across the app with:
/// - Search input with debouncing
/// - Recent search history
/// - Clear and submit actions
class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({
    super.key,
    required this.query,
    required this.onQueryChanged,
    this.hintText = 'Search...',
    this.historyKey,
    this.onClear,
  });

  /// Initial search query
  final String query;

  /// Callback when search query changes
  final void Function(String query) onQueryChanged;

  /// Placeholder text for the search field
  final String hintText;

  /// Key for storing search history (from [SearchHistoryKeys])
  final String? historyKey;

  /// Optional callback when clearing search
  final VoidCallback? onClear;

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  late final TextEditingController _controller;
  late final SearchHistory? _history;
  final RxList<String> _recentSearches = <String>[].obs;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    
    if (widget.historyKey != null && Get.isRegistered<AppPreferences>()) {
      _history = SearchHistory(
        widget.historyKey!,
        Get.find<AppPreferences>(),
      );
      _loadRecentSearches();
    } else {
      _history = null;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await _history!.getHistory();
    _recentSearches.value = searches;
  }

  void _onQueryChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      widget.onQueryChanged(value);
    });
  }

  void _onSubmit(String value) {
    if (value.trim().isEmpty) return;
    
    _history?.addQuery(value.trim());
    widget.onQueryChanged(value.trim());
    Navigator.pop(context);
  }

  void _onClear() {
    _controller.clear();
    widget.onQueryChanged('');
    widget.onClear?.call();
  }

  void _onRecentSearchTap(String query) {
    _controller.text = query;
    _onSubmit(query);
  }

  Future<void> _onClearHistory() async {
    await _history?.clear();
    _recentSearches.value = [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Search',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_recentSearches.isNotEmpty)
                    TextButton(
                      onPressed: _onClearHistory,
                      child: const Text('Clear History'),
                    ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Search field
              SearchBar(
                controller: _controller,
                hintText: widget.hintText,
                leading: const Icon(Icons.search),
                trailing: [
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _onClear,
                    ),
                ],
                onChanged: _onQueryChanged,
                onSubmitted: _onSubmit,
                elevation: WidgetStateProperty.all(0),
                backgroundColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Recent searches (only show when query is empty)
              Obx(() {
                if (_controller.text.isNotEmpty || _recentSearches.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Searches',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      _recentSearches.length,
                      (index) => _RecentSearchItem(
                        query: _recentSearches[index],
                        onTap: () => _onRecentSearchTap(_recentSearches[index]),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSearchItem extends StatelessWidget {
  const _RecentSearchItem({
    required this.query,
    required this.onTap,
  });

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.north_west,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                query,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
