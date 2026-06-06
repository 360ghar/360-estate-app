import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/pages/property_map_page.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PropertyDetailPage extends ConsumerStatefulWidget {
  const PropertyDetailPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends ConsumerState<PropertyDetailPage> {
  bool _isDeleting = false;

  Future<void> _deleteProperty() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
          'Are you sure you want to delete this property? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    try {
      await ref.read(propertiesRepositoryProvider).delete(widget.propertyId);

      if (mounted) {
        // Invalidate all related providers
        ref.invalidate(propertiesListProvider);
        ref.invalidate(propertiesPagedProvider);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property deleted successfully')),
        );

        // Navigate back to properties list
        context.go('/properties');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete property: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyDetailProvider(widget.propertyId));

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Property details'),
        actions: [
          IconButton(
            onPressed: () => context.go('/properties/${widget.propertyId}/edit'),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit property',
          ),
          IconButton(
            onPressed: _isDeleting ? null : _deleteProperty,
            icon: _isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outlined),
            tooltip: 'Delete property',
          ),
        ],
      ),
      body: propertyAsync.when(
        data: (property) => _PropertyDetailContent(property: property),
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load property',
          message: error.toString(),
          onRetry: () => ref.invalidate(propertyDetailProvider(widget.propertyId)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _PropertyDetailContent extends StatefulWidget {
  const _PropertyDetailContent({required this.property});

  final Property property;

  @override
  State<_PropertyDetailContent> createState() => _PropertyDetailContentState();
}

class _PropertyDetailContentState extends State<_PropertyDetailContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Property header with large name + address hierarchy
        _PropertyHeader(property: widget.property),
        // Tabs
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.info_outline)),
            Tab(text: 'Lease', icon: Icon(Icons.assignment)),
            Tab(text: 'Rent', icon: Icon(Icons.payments)),
            Tab(text: 'Expenses', icon: Icon(Icons.receipt_long)),
            Tab(text: 'Maintenance', icon: Icon(Icons.build)),
            Tab(text: 'Documents', icon: Icon(Icons.folder)),
            Tab(text: 'Inspections', icon: Icon(Icons.fact_check)),
          ],
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(property: widget.property),
              const _LeaseTab(),
              const _RentTab(),
              const _ExpensesTab(),
              const _MaintenanceTab(),
              const _DocumentsTab(),
              const _InspectionsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Premium property header with large name, secondary address, status badge,
/// and quick-action row.
class _PropertyHeader extends StatelessWidget {
  const _PropertyHeader({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSecondary : AppColors.surfaceSecondary,
        boxShadow: AppShadows.sectionDivider,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Status row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.displayName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.fullAddress,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _buildStatusBadge(context),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Quick info chips
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _InfoChip(
                icon: Icons.apartment,
                label: property.typeDisplay,
              ),
              if (property.unitCount != null)
                _InfoChip(
                  icon: Icons.meeting_room,
                  label: '${property.unitCount} units',
                ),
              if (property.isOccupied)
                _InfoChip(
                  icon: Icons.person,
                  label: 'Occupied',
                  color: scheme.primary,
                ),
              if (property.monthlyRentInr != null)
                _InfoChip(
                  icon: Icons.currency_rupee,
                  label: '${property.monthlyRentInr!.toInt()}/mo',
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Action buttons row as small cards
          _QuickActionsRow(property: property),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final statusLower = property.managementStatus?.toLowerCase() ?? '';
    final statusType = switch (statusLower) {
      'active' => AppStatusType.success,
      'inactive' => AppStatusType.neutral,
      'sold' => AppStatusType.danger,
      _ => AppStatusType.neutral,
    };

    return AppStatusBadge(
      label: property.statusDisplay.toUpperCase(),
      type: statusType,
      variant: AppStatusVariant.subtle,
    );
  }
}

/// Row of quick-action small cards with icon + label.
class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        _ActionMiniCard(
          icon: Icons.payments_outlined,
          label: 'Collect',
          color: AppColors.success,
          onTap: () => context.go('/collections'),
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionMiniCard(
          icon: Icons.build_outlined,
          label: 'Tasks',
          color: AppColors.warning,
          onTap: () => context.go('/tasks'),
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionMiniCard(
          icon: Icons.folder_outlined,
          label: 'Docs',
          color: AppColors.info,
          onTap: () => context.go('/more/documents'),
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionMiniCard(
          icon: Icons.edit_outlined,
          label: 'Edit',
          color: scheme.primary,
          onTap: () => context.go('/properties/${property.id}/edit'),
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionMiniCard(
          icon: Icons.map_outlined,
          label: 'Map',
          color: AppColors.info,
          onTap: () {
            final markers = <PropertyMarker>[];
            if (property.latitude != null && property.longitude != null) {
              markers.add(PropertyMarker(
                id: property.id.toString(),
                label: property.displayName,
                latitude: property.latitude!,
                longitude: property.longitude!,
              ));
            }
            context.go('/properties/map', extra: markers);
          },
        ),
      ],
    );
  }
}

/// Small action card with icon and label.
class _ActionMiniCard extends StatelessWidget {
  const _ActionMiniCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.md,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.12 : 0.06),
              borderRadius: AppRadii.md,
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Overview Tab using AppSectionCard
class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images section
          if (property.images != null && property.images!.isNotEmpty) ...[
            AppSectionCard(
              title: 'Photos',
              icon: Icons.photo_library_outlined,
              contentPadding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg,
              ),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: property.images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < property.images!.length - 1
                            ? AppSpacing.md
                            : 0,
                      ),
                      child: ClipRRect(
                        borderRadius: AppRadii.md,
                        child: Image.network(
                          property.images![index],
                          width: 280,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 280,
                              height: 200,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Specifications
          AppSectionCard(
            title: 'Specifications',
            icon: Icons.list_alt_outlined,
            children: [
              _InfoRow(label: 'Property type', value: property.typeDisplay),
              if (property.floorAreaSqft != null)
                _InfoRow(
                  label: 'Floor area',
                  value: '${property.floorAreaSqft!.toInt()} sq ft',
                ),
              if (property.bedroomCount != null)
                _InfoRow(label: 'Bedrooms', value: '${property.bedroomCount}'),
              if (property.bathroomCount != null)
                _InfoRow(label: 'Bathrooms', value: '${property.bathroomCount}'),
              if (property.balconyCount != null)
                _InfoRow(label: 'Balconies', value: '${property.balconyCount}'),
              if (property.yearBuilt != null)
                _InfoRow(label: 'Year built', value: '${property.yearBuilt}'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Amenities
          if (property.amenities != null && property.amenities!.isNotEmpty) ...[
            AppSectionCard(
              title: 'Amenities',
              icon: Icons.check_circle_outline,
              iconColor: AppColors.success,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: property.amenities!
                    .map((amenity) => Chip(
                          label: Text(amenity),
                          avatar: Icon(Icons.check, size: 16, color: AppColors.success),
                          backgroundColor: AppColors.success.withValues(alpha: 0.06),
                          side: BorderSide(
                            color: AppColors.success.withValues(alpha: 0.15),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.md,
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Financial Information
          AppSectionCard(
            title: 'Financial Information',
            icon: Icons.account_balance_outlined,
            iconColor: AppColors.accent,
            children: [
              if (property.monthlyRentInr != null)
                _InfoRow(
                  label: 'Monthly rent',
                  value: '\u20B9${property.monthlyRentInr!.toInt()}',
                ),
              if (property.paymentDueDay != null)
                _InfoRow(
                  label: 'Payment due day',
                  value: 'Day ${property.paymentDueDay}',
                ),
              if (property.marketValue != null)
                _InfoRow(
                  label: 'Market value',
                  value: '\u20B9${property.marketValue!.toInt()}',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Legal & Documentation
          AppSectionCard(
            title: 'Legal & Documentation',
            icon: Icons.gavel_outlined,
            iconColor: AppColors.warning,
            children: [
              if (property.propertyTaxId != null)
                _InfoRow(label: 'Property Tax ID', value: property.propertyTaxId!),
              if (property.insurancePolicy != null)
                _InfoRow(label: 'Insurance', value: property.insurancePolicy!),
              if (property.hoaInfo != null)
                _InfoRow(label: 'HOA', value: property.hoaInfo!),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Management
          AppSectionCard(
            title: 'Management',
            icon: Icons.settings_outlined,
            children: [
              _InfoRow(label: 'Status', value: property.statusDisplay),
              if (property.assignedManagerId != null)
                _InfoRow(
                  label: 'Assigned manager ID',
                  value: '${property.assignedManagerId}',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Notes
          if (property.notes != null && property.notes!.isNotEmpty) ...[
            AppSectionCard(
              title: 'Notes',
              icon: Icons.note_outlined,
              child: Text(
                property.notes!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// Lease Tab - Placeholder with navigation to full leases list
class _LeaseTab extends StatelessWidget {
  const _LeaseTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('No active lease'),
          const SizedBox(height: AppSpacing.sm),
          const Text('Create a lease for this property'),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.go('/more/leases'),
            icon: const Icon(Icons.add),
            label: const Text('Create Lease'),
          ),
        ],
      ),
    );
  }
}

// Rent Tab - Placeholder with navigation to collections
class _RentTab extends StatelessWidget {
  const _RentTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Rent History'),
          const SizedBox(height: AppSpacing.sm),
          const Text('View all rent payments for this property'),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.go('/collections'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Go to Collections'),
          ),
        ],
      ),
    );
  }
}

// Expenses Tab - Placeholder with navigation to expenses
class _ExpensesTab extends StatelessWidget {
  const _ExpensesTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Property Expenses'),
          const SizedBox(height: AppSpacing.sm),
          const Text('Track expenses related to this property'),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.go('/more/expenses'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Go to Expenses'),
          ),
        ],
      ),
    );
  }
}

// Maintenance Tab - Placeholder with navigation to maintenance
class _MaintenanceTab extends StatelessWidget {
  const _MaintenanceTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Maintenance Requests'),
          const SizedBox(height: AppSpacing.sm),
          const Text('View all maintenance for this property'),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.go('/tasks'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Go to Tasks'),
          ),
        ],
      ),
    );
  }
}

// Documents Tab - Placeholder with navigation to documents
class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Property Documents'),
          const SizedBox(height: AppSpacing.sm),
          const Text('View all documents for this property'),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.go('/more/documents'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Go to Documents'),
          ),
        ],
      ),
    );
  }
}

// Inspections Tab - Placeholder with navigation to inspections
class _InspectionsTab extends StatelessWidget {
  const _InspectionsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fact_check_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Property Inspections'),
          const SizedBox(height: AppSpacing.sm),
          const Text('View all inspections for this property'),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.go('/more/inspections'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Go to Inspections'),
          ),
        ],
      ),
    );
  }
}

// Helper widgets
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: AppRadii.md,
        border: Border.all(
          color: effectiveColor.withValues(alpha: isDark ? 0.2 : 0.12),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: effectiveColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
