import 'dart:async';

import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/core/presentation/widgets/app_segmented_button.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/auth/presentation/widgets/owner_scope_card.dart';
import 'package:estate_app/features/properties/data/models/location_result.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_cards.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_grid.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Every property, as a list or a grid, with search, a place filter and
/// filter chips.
class PropertiesPage extends ConsumerStatefulWidget {
  const PropertiesPage({super.key});

  @override
  ConsumerState<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends ConsumerState<PropertiesPage> {
  bool _isGridView = false;
  PropertyFilter _filter = PropertyFilter.all;
  final TextEditingController _searchController = TextEditingController();
  LocationResult? _location;

  /// The search text the server filters on (`q`). It follows the search box
  /// after a short pause, so a request is not sent for every key.
  String _query = '';
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  /// A place picked on the location screen searches the addresses for its
  /// name.
  Future<void> _openLocationSearch() async {
    final result = await context.push<LocationResult>('/location-search');
    if (result == null || !mounted) return;
    _searchDebounce?.cancel();
    setState(() {
      _location = result;
      _searchController.text = result.name;
      _query = result.name.trim();
    });
  }

  void _clearLocation() {
    _searchDebounce?.cancel();
    setState(() {
      _location = null;
      _query = '';
      _searchController.clear();
    });
  }

  /// Occupied and vacant are filtered by the backend (an occupying lease makes
  /// a property occupied). The other chips filter the loaded page.
  OccupancyFilter? get _occupancy => switch (_filter) {
    PropertyFilter.occupied => OccupancyFilter.occupied,
    PropertyFilter.vacant => OccupancyFilter.vacant,
    _ => null,
  };

  List<Property> _applyFilter(List<Property> items) => switch (_filter) {
    PropertyFilter.all ||
    PropertyFilter.occupied ||
    PropertyFilter.vacant => items,
    PropertyFilter.active => items.where((p) => p.isActive).toList(),
    PropertyFilter.pg =>
      items.where((p) => p.propertyType == PropertyType.pg).toList(),
    PropertyFilter.flat =>
      items.where((p) => p.propertyType == PropertyType.apartment).toList(),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final listQuery = (
      occupancy: _occupancy,
      q: _query.isEmpty ? null : _query,
    );
    final state = ref.watch(propertiesPagedProvider(listQuery));
    final controller = ref.read(propertiesPagedProvider(listQuery).notifier);
    final filtered = state.copyWith(items: _applyFilter(state.items));
    final narrowed = _filter != PropertyFilter.all || _query.isNotEmpty;

    // A chip that filters the loaded page can empty it while more pages wait
    // on the server: offer to load them instead of a dead end.
    final waitingForMore =
        filtered.items.isEmpty && state.hasMore && state.items.isNotEmpty;
    final emptyTitle = narrowed
        ? l10n.propertiesNoResultsTitle
        : l10n.propertiesEmptyTitle;
    final emptyMessage = waitingForMore
        ? l10n.propertiesNoMatchYetBody
        : narrowed
        ? l10n.propertiesNoResultsBody
        : l10n.propertiesEmptyBody;
    final emptyAction = waitingForMore
        ? FilledButton(
            onPressed: controller.loadMore,
            child: Text(l10n.propertiesLoadMore),
          )
        : narrowed
        ? null
        : FilledButton.icon(
            onPressed: () => context.go('/properties/create'),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.homeAddProperty),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.propertiesTitle),
        actions: [
          IconButton(
            onPressed: _openLocationSearch,
            icon: const Icon(Icons.travel_explore_rounded),
            tooltip: l10n.propertiesSearchByLocation,
          ),
          AppSegmentedButton<ViewMode>(
            showLabels: false,
            segments: [
              AppSegment(
                value: ViewMode.list,
                label: l10n.propertiesViewList,
                icon: Icons.view_agenda_outlined,
              ),
              AppSegment(
                value: ViewMode.grid,
                label: l10n.propertiesViewGrid,
                icon: Icons.grid_view_outlined,
              ),
            ],
            selected: _isGridView ? ViewMode.grid : ViewMode.list,
            onSelected: (mode) =>
                setState(() => _isGridView = mode == ViewMode.grid),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/properties/create'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.homeAddProperty),
      ),
      body: Column(
        children: [
          // Agents and admins pick the owner whose properties they manage.
          const Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 0),
            child: OwnerScopeCard(),
          ),
          AppSearchBar(
            hintText: l10n.propertiesSearchHint,
            controller: _searchController,
            onChanged: _onSearchChanged,
            filterChips: [
              if (_location != null)
                InputChip(
                  avatar: const Icon(Icons.place_outlined, size: 18),
                  label: Text(_location!.name),
                  onDeleted: _clearLocation,
                  deleteButtonTooltipMessage: l10n.propertiesClearLocation,
                ),
              for (final filter in PropertyFilter.values)
                FilterChip(
                  label: Text(filter.text(context)),
                  selected: filter == _filter,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
            ],
          ),
          Expanded(
            child: _isGridView
                ? PropertyGrid(
                    state: filtered,
                    onLoadMore: controller.loadMore,
                    onRefresh: controller.refresh,
                    onRetry: controller.loadInitial,
                    emptyTitle: emptyTitle,
                    emptyMessage: emptyMessage,
                    emptyAction: emptyAction,
                  )
                : PagedListView<Property>(
                    state: filtered,
                    emptyTitle: emptyTitle,
                    emptyMessage: emptyMessage,
                    emptyIcon: Icons.apartment_outlined,
                    emptyAction: emptyAction,
                    onLoadMore: controller.loadMore,
                    onRefresh: controller.refresh,
                    onRetry: controller.loadInitial,
                    onLoadMoreRetry: controller.retryLoadMore,
                    // Room at the foot so the last row clears the button.
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      96,
                    ),
                    itemBuilder: (context, property) => PropertyListCard(
                      key: ValueKey(property.id),
                      property: property,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

enum PropertyFilter {
  all,
  active,
  occupied,
  vacant,
  pg,
  flat;

  String text(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      PropertyFilter.all => l10n.propertiesFilterAll,
      PropertyFilter.active => l10n.propertiesFilterActive,
      PropertyFilter.occupied => l10n.propertiesFilterOccupied,
      PropertyFilter.vacant => l10n.propertiesFilterVacant,
      PropertyFilter.pg => l10n.propertiesFilterPg,
      PropertyFilter.flat => l10n.propertiesFilterFlat,
    };
  }
}

enum ViewMode { list, grid }
