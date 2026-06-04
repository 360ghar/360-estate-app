import 'dart:async';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_progress_bar.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/core/presentation/widgets/app_segmented_button.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Professional B2B Properties page with:
/// - AppSearchBar with filter chips
/// - List/Grid view toggle
/// - Enhanced property cards with status accent and occupancy
class PropertiesPage extends ConsumerStatefulWidget {
  const PropertiesPage({super.key});

  @override
  ConsumerState<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends ConsumerState<PropertiesPage> {
  bool _isGridView = false;
  PropertyFilter _selectedFilter = PropertyFilter.all;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _setFilter(PropertyFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
    // TODO: Apply filter to provider
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertiesPagedProvider);
    final controller = ref.read(propertiesPagedProvider.notifier);

    return AppScaffold(
      appBar: _buildAppBar(context),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/properties/create'),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('Add Property'),
      ),
      body: Column(
        children: [
          // Search bar and filters using AppSearchBar
          AppSearchBar(
            hintText: 'Search properties...',
            controller: _searchController,
            onFilterTap: () => _showFilterSheet(context),
            filterChips: PropertyFilter.values.map((filter) {
              final isSelected = filter == _selectedFilter;
              final scheme = Theme.of(context).colorScheme;
              return FilterChip(
                label: Text(filter.label),
                selected: isSelected,
                onSelected: (_) => _setFilter(filter),
                backgroundColor: Colors.transparent,
                selectedColor: scheme.primary.withValues(alpha: 0.12),
                checkmarkColor: scheme.primary,
                labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected ? scheme.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.md,
                  side: BorderSide(
                    color: isSelected ? scheme.primary : scheme.outlineVariant,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
              );
            }).toList(),
          ),
          const Divider(height: 1),

          // Property list/grid
          Expanded(
            child: _isGridView
                ? _PropertyGridView(
                    state: state,
                    onLoadMore: controller.loadMore,
                    onRefresh: controller.refresh,
                    onRetry: controller.loadInitial,
                  )
                : PagedListView<Property>(
                    state: state,
                    emptyTitle: 'No properties yet',
                    emptyMessage: 'Create your first property to get started.',
                    onLoadMore: controller.loadMore,
                    onRefresh: controller.refresh,
                    onRetry: controller.loadInitial,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    separatorSpacing: AppSpacing.sm,
                    itemBuilder: (context, property) =>
                        _PropertyListCard(property: property),
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Properties'),
      actions: [
        AppSegmentedButton<ViewMode>(
          segments: const [
            AppSegment(value: ViewMode.list, label: 'List', icon: Icons.view_list),
            AppSegment(value: ViewMode.grid, label: 'Grid', icon: Icons.grid_view),
          ],
          selected: _isGridView ? ViewMode.grid : ViewMode.list,
          onSelected: (mode) {
            if (mode != null) _toggleView();
          },
          style: AppSegmentedStyle.rect,
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Properties',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FilterOption(
                    icon: Icons.check_circle_outline,
                    title: 'Status',
                    options: const ['All', 'Active', 'Inactive'],
                    selected: 'All',
                    onTap: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FilterOption(
                    icon: Icons.home_outlined,
                    title: 'Property Type',
                    options: const ['All', 'PG', '1BHK', '2BHK', '3BHK', 'Commercial'],
                    selected: 'All',
                    onTap: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}

/// Filter option widget for bottom sheet.
class _FilterOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onTap;

  const _FilterOption({
    required this.icon,
    required this.title,
    required this.options,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: options.map((option) {
            final isSelected = option == selected;
            final scheme = Theme.of(context).colorScheme;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onTap(option),
              backgroundColor: Colors.transparent,
              selectedColor: scheme.primary.withValues(alpha: 0.12),
              labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? scheme.primary : AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.md,
                side: BorderSide(
                  color: isSelected ? scheme.primary : scheme.outlineVariant,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Grid view for properties.
class _PropertyGridView extends StatelessWidget {
  const _PropertyGridView({
    required this.state,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onRetry,
  });

  final PagedListState<Property> state;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) {
      return const AppLoadingShimmer();
    }

    if (state.error != null && state.items.isEmpty) {
      return AppErrorView(
        title: 'Unable to load properties',
        message: state.error?.message ?? 'Please check your connection and try again.',
        onRetry: onRetry,
        retryLabel: 'Retry',
      );
    }

    if (state.items.isEmpty) {
      return const AppEmptyView(
        title: 'No properties yet',
        message: 'Create your first property to get started.',
      );
    }

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
    final childAspectRatio = width >= 900 ? 1.1 : (width >= 600 ? 1.0 : 0.95);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 200) {
            onLoadMore();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: childAspectRatio,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final property = state.items[index];
                    return _PropertyGridCard(property: property);
                  },
                  childCount: state.items.length + (state.isLoadingMore ? 1 : 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Enhanced property list card with AppCard, status accent border,
/// scale press feedback, and occupancy bar.
class _PropertyListCard extends StatelessWidget {
  const _PropertyListCard({required this.property});

  final Property property;

  Color? _statusAccentColor() {
    final status = property.managementStatus?.toLowerCase();
    if (status == 'active') return AppColors.success;
    if (status == 'inactive') return AppColors.textTertiary;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '\u0192,1',
      decimalDigits: 0,
    );
    final title = _propertyTitle(property);
    final subtitle = _propertySubtitle(property);
    final statusBadge = _buildStatusBadge(context);
    final typeLabel = _propertyTypeLabel(property);
    final occupancyLabel = _propertyOccupancyLabel(property);
    final unitsLabel = occupancyLabel == null ? _propertyUnitsLabel(property) : null;
    final rentLabel = property.monthlyRentInr != null
        ? formatter.format(property.monthlyRentInr!)
        : null;
    final hasOccupancy = _hasOccupancyData(property);
    final metaChips = <Widget>[
      if (typeLabel != null)
        _StatChip(
          icon: Icons.home_outlined,
          label: typeLabel,
        ),
      if (unitsLabel != null)
        _StatChip(
          icon: Icons.door_front_door_outlined,
          label: unitsLabel,
        ),
      if (occupancyLabel != null)
        _StatChip(
          icon: Icons.people_outline,
          label: occupancyLabel,
        ),
      if (rentLabel != null)
        _StatChip(
          icon: Icons.currency_rupee_outlined,
          label: rentLabel,
        ),
    ];
    final visibleChips = metaChips.take(3).toList();
    final imageUrl =
        property.images != null && property.images!.isNotEmpty
            ? property.images!.first
            : null;

    return AppCard(
      headerColor: _statusAccentColor(),
      onTap: () => context.go('/properties/${property.id}'),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image/placeholder with building icon
          ClipRRect(
            borderRadius: AppRadii.md,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: AppRadii.md,
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Center(
                        child: Icon(
                          _getPropertyIcon(property.type),
                          size: 28,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        _getPropertyIcon(property.type),
                        size: 28,
                        color: AppColors.textTertiary,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Property details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (statusBadge != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      statusBadge,
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (visibleChips.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: visibleChips,
                  ),
                ],
                if (hasOccupancy) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppOccupancyBar(
                    occupancy: property.occupancyRate,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget? _buildStatusBadge(BuildContext context) {
    final label = _propertyStatusLabel(property);
    final status = property.managementStatus?.trim();
    if (label == null || status == null || status.isEmpty) return null;

    return AppStatusBadge(
      label: label.toUpperCase(),
      type: _propertyStatusType(status),
      variant: AppStatusVariant.subtle,
    );
  }
}

/// Property grid card with image header and AppCard.
class _PropertyGridCard extends StatelessWidget {
  const _PropertyGridCard({required this.property});

  final Property property;

  Color? _statusAccentColor() {
    final status = property.managementStatus?.toLowerCase();
    if (status == 'active') return AppColors.success;
    if (status == 'inactive') return AppColors.textTertiary;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '\u0192,1',
      decimalDigits: 0,
    );
    final scheme = Theme.of(context).colorScheme;
    final title = _propertyTitle(property);
    final subtitle = _propertySubtitle(property);
    final statusBadge = _buildStatusBadge(context);
    final typeLabel = _propertyTypeLabel(property);
    final unitsLabel = _propertyUnitsLabel(property);
    final rentLabel = property.monthlyRentInr != null
        ? formatter.format(property.monthlyRentInr!)
        : null;
    final hasOccupancy = _hasOccupancyData(property);
    final metaChips = <Widget>[
      if (typeLabel != null)
        _StatChip(
          icon: Icons.home_outlined,
          label: typeLabel,
        ),
      if (unitsLabel != null)
        _StatChip(
          icon: Icons.door_front_door_outlined,
          label: unitsLabel,
        ),
      if (rentLabel != null)
        _StatChip(
          icon: Icons.currency_rupee_outlined,
          label: rentLabel,
        ),
    ];
    final visibleChips = metaChips.take(3).toList();
    final imageUrl =
        property.images != null && property.images!.isNotEmpty
            ? property.images!.first
            : null;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.go('/properties/${property.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status accent strip
          if (_statusAccentColor() != null)
            Container(height: 3, color: _statusAccentColor()),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: scheme.surfaceContainerHighest,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Center(
                            child: Icon(
                              _getPropertyIcon(property.type),
                              size: 44,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            _getPropertyIcon(property.type),
                            size: 44,
                            color: AppColors.textTertiary,
                          ),
                        ),
                ),
                if (statusBadge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: statusBadge,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                if (visibleChips.isNotEmpty)
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: visibleChips,
                  ),
                if (hasOccupancy) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppOccupancyBar(
                    occupancy: property.occupancyRate,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildStatusBadge(BuildContext context) {
    final label = _propertyStatusLabel(property);
    final status = property.managementStatus?.trim();
    if (label == null || status == null || status.isEmpty) return null;

    return AppStatusBadge(
      label: label.toUpperCase(),
      type: _propertyStatusType(status),
    );
  }
}

/// Small stat chip for property cards.
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSecondary : AppColors.surfaceSecondary,
        borderRadius: AppRadii.sm,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Property filter options.
enum PropertyFilter {
  all('All'),
  active('Active'),
  occupied('Occupied'),
  vacant('Vacant'),
  pg('PG'),
  flat('Flat');

  final String label;
  const PropertyFilter(this.label);
}

/// View mode for list/grid toggle.
enum ViewMode { list, grid }

/// Get property icon based on type.
IconData _getPropertyIcon(String? type) {
  switch (type?.toLowerCase()) {
    case 'pg':
      return Icons.bed_outlined;
    case '1bhk':
    case '2bhk':
    case '3bhk':
    case '1rk':
      return Icons.apartment_outlined;
    case 'commercial':
      return Icons.business_outlined;
    case 'land':
      return Icons.landscape_outlined;
    default:
      return Icons.home_outlined;
  }
}

String _propertyTitle(Property property) {
  final name = _trimOrNull(property.name) ?? _trimOrNull(property.propertyName);
  final hasName = name != null && !_looksLikeId(name, property);
  if (hasName) return name;
  final address = _trimOrNull(property.address);
  if (address != null) return address;
  final city = _trimOrNull(property.city);
  if (city != null) return city;
  return 'Property';
}

String? _propertySubtitle(Property property) {
  final name = _trimOrNull(property.name) ?? _trimOrNull(property.propertyName);
  final hasName = name != null && !_looksLikeId(name, property);
  if (hasName) {
    return _joinParts([
      property.address,
      property.city,
      property.state,
      property.pincode,
    ]);
  }
  final address = _trimOrNull(property.address);
  if (address != null) {
    return _joinParts([property.city, property.state, property.pincode]);
  }
  final city = _trimOrNull(property.city);
  if (city != null) {
    return _joinParts([property.state, property.pincode]);
  }
  return null;
}

bool _looksLikeId(String value, Property property) {
  final trimmed = value.trim();
  final id = property.id?.toString();
  if (id != null && trimmed == id) return true;
  if (RegExp(r'^[0-9]+$').hasMatch(trimmed)) return true;
  if (RegExp(r'^(prop|property)[-_ ]?\d+$', caseSensitive: false)
      .hasMatch(trimmed)) {
    return true;
  }
  return false;
}

String? _trimOrNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

String? _joinParts(List<String?> parts) {
  final items = parts
      .map(_trimOrNull)
      .where((value) => value != null)
      .cast<String>()
      .toList();
  if (items.isEmpty) return null;
  return items.join(', ');
}

String? _propertyTypeLabel(Property property) {
  final raw = property.type?.trim();
  if (raw == null || raw.isEmpty) return null;
  switch (raw.toLowerCase()) {
    case '1rk':
      return '1RK';
    case '1bhk':
      return '1BHK';
    case '2bhk':
      return '2BHK';
    case '3bhk':
      return '3BHK';
    case 'pg':
      return 'PG';
    case 'commercial':
      return 'Commercial';
    default:
      return raw.toUpperCase();
  }
}

String? _propertyUnitsLabel(Property property) {
  final unitCount = property.unitCount;
  if (unitCount == null) return null;
  return '$unitCount units';
}

String? _propertyOccupancyLabel(Property property) {
  final unitCount = property.unitCount;
  final occupied = property.occupiedUnits;
  if (unitCount == null || unitCount == 0 || occupied == null) return null;
  return '$occupied/$unitCount occupied';
}

bool _hasOccupancyData(Property property) {
  final unitCount = property.unitCount;
  return unitCount != null && unitCount > 0 && property.occupiedUnits != null;
}

String? _propertyStatusLabel(Property property) {
  final status = property.managementStatus?.trim();
  if (status == null || status.isEmpty) return null;
  switch (status.toLowerCase()) {
    case 'active':
      return 'Active';
    case 'inactive':
      return 'Inactive';
    case 'sold':
      return 'Sold';
    default:
      return status;
  }
}

AppStatusType _propertyStatusType(String status) {
  switch (status.toLowerCase()) {
    case 'active':
      return AppStatusType.success;
    case 'inactive':
      return AppStatusType.neutral;
    case 'sold':
      return AppStatusType.danger;
    default:
      return AppStatusType.neutral;
  }
}
