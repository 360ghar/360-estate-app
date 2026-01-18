import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/features/properties/models/property.dart';
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
        // Property header
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.property.displayName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.property.fullAddress,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _PropertyStatusChip(status: widget.property.managementStatus),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _InfoChip(
                    icon: Icons.apartment,
                    label: widget.property.typeDisplay,
                  ),
                  if (widget.property.unitCount != null)
                    _InfoChip(
                      icon: Icons.meeting_room,
                      label: '${widget.property.unitCount} units',
                    ),
                  if (widget.property.isOccupied)
                    _InfoChip(
                      icon: Icons.person,
                      label: 'Occupied',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  if (widget.property.monthlyRentInr != null)
                    _InfoChip(
                      icon: Icons.currency_rupee,
                      label: '${widget.property.monthlyRentInr!.toInt()}/mo',
                    ),
                ],
              ),
            ],
          ),
        ),
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

// Overview Tab
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
            const SectionHeader(title: 'Photos'),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
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
                      borderRadius: BorderRadius.circular(8),
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
            const SizedBox(height: AppSpacing.xl),
          ],

          // Specifications
          const SectionHeader(title: 'Specifications'),
          const SizedBox(height: AppSpacing.md),
          _InfoCard(
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
            const SectionHeader(title: 'Amenities'),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: property.amenities!
                  .map((amenity) => Chip(
                        label: Text(amenity),
                        avatar: const Icon(Icons.check, size: 16),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Financial Information
          const SectionHeader(title: 'Financial Information'),
          const SizedBox(height: AppSpacing.md),
          _InfoCard(
            children: [
              if (property.monthlyRentInr != null)
                _InfoRow(
                  label: 'Monthly rent',
                  value: '₹${property.monthlyRentInr!.toInt()}',
                ),
              if (property.paymentDueDay != null)
                _InfoRow(
                  label: 'Payment due day',
                  value: 'Day ${property.paymentDueDay}',
                ),
              if (property.marketValue != null)
                _InfoRow(
                  label: 'Market value',
                  value: '₹${property.marketValue!.toInt()}',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Legal & Documentation
          const SectionHeader(title: 'Legal & Documentation'),
          const SizedBox(height: AppSpacing.md),
          _InfoCard(
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
          const SectionHeader(title: 'Management'),
          const SizedBox(height: AppSpacing.md),
          _InfoCard(
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
            const SectionHeader(title: 'Notes'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(property.notes!),
              ),
            ),
          ],
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
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

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
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
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
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: color ?? theme.colorScheme.onSurfaceVariant,
      ),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      backgroundColor: color?.withOpacity(0.1),
    );
  }
}

class _PropertyStatusChip extends StatelessWidget {
  const _PropertyStatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLower = status?.toLowerCase() ?? '';

    Color backgroundColor;
    Color foregroundColor;
    IconData icon;

    switch (statusLower) {
      case 'active':
        backgroundColor = theme.colorScheme.primaryContainer;
        foregroundColor = theme.colorScheme.onPrimaryContainer;
        icon = Icons.check_circle;
        break;
      case 'inactive':
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        foregroundColor = theme.colorScheme.onSurface;
        icon = Icons.pause_circle;
        break;
      case 'sold':
        backgroundColor = theme.colorScheme.errorContainer;
        foregroundColor = theme.colorScheme.onErrorContainer;
        icon = Icons.sell;
        break;
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        foregroundColor = theme.colorScheme.onSurface;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            status?.toUpperCase() ?? 'UNKNOWN',
            style: TextStyle(
              color: foregroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
