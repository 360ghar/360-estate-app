import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CollectionsPage extends ConsumerStatefulWidget {
  const CollectionsPage({super.key, this.initialStatus});

  final String? initialStatus;

  @override
  ConsumerState<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends ConsumerState<CollectionsPage> {
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
            const _CollectionsSummaryCards(),
            const Divider(height: 1),
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
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        labelColor: scheme.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.3,
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
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateCharges(BuildContext context) async {
    try {
      await ref.read(rentRepositoryProvider).generateCharges();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Charges generated successfully.')),
        );
      }
      ref.invalidate(rentChargesProvider);
      ref.invalidate(rentChargesPagedProvider);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')));
      }
    }
  }
}

class _CollectionsSummaryCards extends ConsumerWidget {
  const _CollectionsSummaryCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueAsync = ref.watch<PagedListState<RentCharge>>(
      rentChargesPagedProvider('pending'),
    );
    final overdueAsync = ref.watch<PagedListState<RentCharge>>(
      rentChargesPagedProvider('overdue'),
    );
    final paidAsync = ref.watch<PagedListState<RentCharge>>(
      rentChargesPagedProvider('paid'),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              label: 'Due',
              amount: _calculateTotal(dueAsync),
              color: AppColors.warning,
              icon: Icons.schedule_rounded,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _SummaryCard(
              label: 'Overdue',
              amount: _calculateTotal(overdueAsync),
              color: AppColors.danger,
              icon: Icons.warning_amber_rounded,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _SummaryCard(
              label: 'Paid',
              amount: _calculateTotal(paidAsync),
              color: AppColors.success,
              icon: Icons.check_circle_outline_rounded,
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

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final amountStr = formatter.format(amount);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadii.lg,
        border: Border.all(color: color.withOpacity(0.25), width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: color.withOpacity(0.08),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(isDark ? 0.12 : 0.08),
            color.withOpacity(isDark ? 0.04 : 0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs + 1),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: AppRadii.sm,
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amountStr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ChargesList extends ConsumerWidget {
  const _ChargesList({required this.status});

  final String status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch<PagedListState<RentCharge>>(
      rentChargesPagedProvider(status),
    );
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
      itemBuilder: (context, charge) =>
          _ChargeTile(charge: charge, status: status),
    );
  }
}

class _ChargeTile extends StatelessWidget {
  const _ChargeTile({required this.charge, required this.status});

  final RentCharge charge;
  final String status;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final dueDate = charge.dueDate;
    final dateStr = dueDate == null
        ? 'Due date not set'
        : DateFormat('dd MMM yyyy').format(dueDate);

    final daysOverdue = dueDate == null
        ? 0
        : DateTime.now().difference(dueDate).inDays;

    final statusType = _getStatusType();
    final urgencyLevel = _getUrgencyLevel(daysOverdue);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = _getAccentColor(urgencyLevel);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: _getBorderColor(context, urgencyLevel),
          width: urgencyLevel == _UrgencyLevel.critical ? 1.5 : 1,
        ),
        boxShadow: isDark
            ? AppShadowsDark.sm
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              context.go('/collections/payments/new?chargeId=${charge.id}'),
          borderRadius: AppRadii.lg,
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: accentColor, width: 3.5)),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md - 2,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        charge.displayTenant,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ),
                    AppStatusBadge(
                      label: status.toUpperCase(),
                      type: statusType,
                      variant: AppStatusVariant.filled,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withOpacity(0.7),
                        borderRadius: AppRadii.xs,
                      ),
                      child: Icon(
                        Icons.apartment_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        charge.displayProperty,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: _getDueDateColor(urgencyLevel).withOpacity(0.1),
                        borderRadius: AppRadii.xs,
                      ),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: _getDueDateColor(urgencyLevel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        dateStr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getDueDateColor(urgencyLevel),
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (daysOverdue > 0) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs - 1,
                          ),
                          decoration: BoxDecoration(
                            color: _getUrgencyColor(
                              urgencyLevel,
                            ).withOpacity(0.12),
                            borderRadius: AppRadii.sm,
                            border: Border.all(
                              color: _getUrgencyColor(
                                urgencyLevel,
                              ).withOpacity(0.25),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            '$daysOverdue days overdue',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: _getUrgencyColor(urgencyLevel),
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Divider(
                    height: 1,
                    color: scheme.outlineVariant.withOpacity(0.5),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        formatter.format(charge.displayAmount),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QuickActionButton(
                          icon: Icons.sms_outlined,
                          label: 'Remind',
                          isPrimary: false,
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

  Color _getAccentColor(_UrgencyLevel level) {
    return switch (level) {
      _UrgencyLevel.critical => AppColors.danger,
      _UrgencyLevel.high => AppColors.danger.withOpacity(0.7),
      _UrgencyLevel.medium => AppColors.warning,
      _UrgencyLevel.low => AppColors.primary.withOpacity(0.5),
      _UrgencyLevel.none => AppColors.success.withOpacity(0.5),
    };
  }

  Color _getBorderColor(BuildContext context, _UrgencyLevel level) {
    if (level == _UrgencyLevel.critical) {
      return AppColors.danger.withOpacity(0.35);
    }
    if (level == _UrgencyLevel.high) {
      return AppColors.danger.withOpacity(0.2);
    }
    return Theme.of(context).colorScheme.outlineVariant.withOpacity(0.7);
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Payment reminder sent.')));
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (isPrimary) {
      return Material(
        color: scheme.primary.withOpacity(0.1),
        borderRadius: AppRadii.md,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.md,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm - 1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: scheme.primary),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.md,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm - 1,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.md,
            border: Border.all(color: scheme.outlineVariant, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
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
