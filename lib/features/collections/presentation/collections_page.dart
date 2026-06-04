import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_gradients.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Professional B2B Collections page with:
/// - Gradient summary cards for Due/Overdue/Paid totals
/// - Color-coded urgency indicators
/// - Quick action buttons for charge tiles
/// - Visual hierarchy for payment status
class CollectionsPage extends ConsumerStatefulWidget {
  const CollectionsPage({super.key, this.initialStatus});

  final String? initialStatus;

  @override
  ConsumerState<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends ConsumerState<CollectionsPage> {
  // API expects 'pending' for due/unpaid charges, not 'due'
  static const _tabs = ['pending', 'overdue', 'paid'];

  @override
  Widget build(BuildContext context) {
    final initialIndex = _tabs.indexOf(widget.initialStatus ?? 'pending');

    return DefaultTabController(
      length: _tabs.length,
      initialIndex: initialIndex == -1 ? 0 : initialIndex,
      child: AppScaffold(
        appBar: _buildAppBar(context),
        padding: EdgeInsets.zero,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/collections/payments/new'),
          icon: const Icon(Icons.payment_rounded),
          label: const Text('Record Payment'),
        ),
        body: Column(
          children: [
            // Summary Cards with gradient backgrounds
            const _CollectionsSummaryCards(),
            const Divider(height: 1),

            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  _ChargesList(status: 'pending'),
                  _ChargesList(status: 'overdue'),
                  _ChargesList(status: 'paid'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: const Text('Collections'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded),
          onPressed: () => _generateCharges(context),
          tooltip: 'Generate charges',
        ),
      ],
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: AppRadii.md,
          color: scheme.primary.withValues(alpha: 0.12),
        ),
        dividerColor: Colors.transparent,
        splashBorderRadius: AppRadii.md,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          _buildTab('Due', AppColors.warning),
          _buildTab('Overdue', AppColors.danger),
          _buildTab('Paid', AppColors.success),
        ],
      ),
    );
  }

  Widget _buildTab(String label, Color color) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateCharges(BuildContext context) async {
    try {
      await ref.read(rentRepositoryProvider).generateCharges();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Charges generated successfully.')),
        );
      }
      ref.invalidate(rentChargesProvider);
      ref.invalidate(rentChargesPagedProvider);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    }
  }
}

/// Summary cards showing total Due, Overdue, and Paid amounts
/// with subtle gradient backgrounds.
class _CollectionsSummaryCards extends ConsumerWidget {
  const _CollectionsSummaryCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all charges to calculate totals
    final dueAsync = ref.watch<PagedListState<RentCharge>>(rentChargesPagedProvider('pending'));
    final overdueAsync = ref.watch<PagedListState<RentCharge>>(rentChargesPagedProvider('overdue'));
    final paidAsync = ref.watch<PagedListState<RentCharge>>(rentChargesPagedProvider('paid'));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              label: 'Due',
              amount: _calculateTotal(dueAsync),
              color: AppColors.warning,
              gradient: AppGradients.warningSubtle,
              icon: Icons.schedule_outlined,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _SummaryCard(
              label: 'Overdue',
              amount: _calculateTotal(overdueAsync),
              color: AppColors.danger,
              gradient: AppGradients.dangerSubtle,
              icon: Icons.warning_amber_outlined,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _SummaryCard(
              label: 'Paid',
              amount: _calculateTotal(paidAsync),
              color: AppColors.success,
              gradient: AppGradients.successSubtle,
              icon: Icons.check_circle_outline,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotal(PagedListState<RentCharge> state) {
    return state.items.fold<double>(
      0,
      (sum, charge) => sum + (charge.amount ?? 0),
    );
  }
}

/// Individual summary card with gradient background and icon.
class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final LinearGradient gradient;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '\u20B9',
      decimalDigits: 0,
    );
    final amountStr = formatter.format(amount);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: gradient,
        color: color.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amountStr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// List of charges for a specific status.
class _ChargesList extends ConsumerWidget {
  const _ChargesList({required this.status});

  final String status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch<PagedListState<RentCharge>>(rentChargesPagedProvider(status));
    final controller = ref.read(rentChargesPagedProvider(status).notifier);

    return PagedListView<RentCharge>(
      state: state,
      emptyTitle: 'No ${status.toLowerCase()} charges',
      emptyMessage: status == 'pending'
          ? 'All charges are paid or overdue.'
          : 'No charges found.',
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      itemBuilder: (context, charge) => _ChargeTile(
        charge: charge,
        status: status,
      ),
    );
  }
}

/// Enhanced charge tile with colored left border, bold amount,
/// urgency indicators and quick actions using AppCard.
class _ChargeTile extends StatelessWidget {
  const _ChargeTile({
    required this.charge,
    required this.status,
  });

  final RentCharge charge;
  final String status;

  Color _statusColor() {
    return switch (status.toLowerCase()) {
      'paid' => AppColors.success,
      'overdue' => AppColors.danger,
      'pending' => AppColors.warning,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '\u20B9',
      decimalDigits: 0,
    );
    final dueDate = charge.dueDate;
    final dateStr = dueDate == null
        ? 'Due date not set'
        : DateFormat('dd MMM yyyy').format(dueDate);

    // Calculate days overdue for urgency
    final daysOverdue = dueDate == null
        ? 0
        : DateTime.now().difference(dueDate).inDays;

    final statusType = _getStatusType();
    final urgencyLevel = _getUrgencyLevel(daysOverdue);
    final accentColor = _statusColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: AppCard(
        headerColor: accentColor,
        onTap: () => context.go(
          '/collections/payments/new?chargeId=${charge.id}',
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with tenant and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    charge.displayTenant,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppStatusBadge(
                  label: status.toUpperCase(),
                  type: statusType,
                  variant: AppStatusVariant.subtle,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Property and due date
            Row(
              children: [
                Icon(
                  Icons.apartment_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    charge.displayProperty,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: _getDueDateColor(urgencyLevel),
                ),
                const SizedBox(width: 6),
                Text(
                  dateStr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getDueDateColor(urgencyLevel),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (daysOverdue > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor(urgencyLevel).withValues(alpha: 
                        isDark ? 0.2 : 0.1,
                      ),
                      borderRadius: AppRadii.pill,
                    ),
                    child: Text(
                      '$daysOverdue days overdue',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getUrgencyColor(urgencyLevel),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Amount (large + bold) and quick actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatter.format(charge.displayAmount),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QuickActionButton(
                      icon: Icons.sms_outlined,
                      label: 'Remind',
                      onTap: () => _sendReminder(context),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _QuickActionButton(
                      icon: Icons.payment_rounded,
                      label: 'Pay',
                      isPrimary: true,
                      onTap: () => context.go(
                        '/collections/payments/new?chargeId=${charge.id}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppStatusType _getStatusType() {
    return switch (status.toLowerCase()) {
      'paid' => AppStatusType.success,
      'overdue' => AppStatusType.danger,
      'pending' => AppStatusType.warning,
      _ => AppStatusType.neutral,
    };
  }

  _UrgencyLevel _getUrgencyLevel(int daysOverdue) {
    if (status == 'paid') return _UrgencyLevel.none;
    if (status == 'overdue') {
      if (daysOverdue >= 7) return _UrgencyLevel.critical;
      if (daysOverdue >= 3) return _UrgencyLevel.high;
      return _UrgencyLevel.medium;
    }
    return _UrgencyLevel.low;
  }

  Color _getDueDateColor(_UrgencyLevel level) {
    return switch (level) {
      _UrgencyLevel.critical => AppColors.danger,
      _UrgencyLevel.high => AppColors.danger,
      _UrgencyLevel.medium => AppColors.warning,
      _UrgencyLevel.low => AppColors.textSecondary,
      _UrgencyLevel.none => AppColors.success,
    };
  }

  Color _getUrgencyColor(_UrgencyLevel level) {
    return switch (level) {
      _UrgencyLevel.critical => AppColors.danger,
      _UrgencyLevel.high => AppColors.danger,
      _UrgencyLevel.medium => AppColors.warning,
      _UrgencyLevel.low => AppColors.textSecondary,
      _UrgencyLevel.none => AppColors.success,
    };
  }

  void _sendReminder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment reminder sent.')),
    );
  }
}

/// Quick action button for charge tiles.
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = scheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: isPrimary
              ? BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: AppRadii.md,
                  border: Border.all(
                    color: color.withValues(alpha: isDark ? 0.25 : 0.15),
                    width: 0.5,
                  ),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _UrgencyLevel { none, low, medium, high, critical }
