import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_alert_banner.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Tenant Home page with payment-first design.
///
/// Features:
/// - Prominent next payment card at top
/// - Large, easy-to-tap action buttons
/// - Urgency-based color coding
/// - Quick actions for maintenance, documents
/// - Overdue alerts
class TenantHomePage extends ConsumerWidget {
  const TenantHomePage({super.key});

  RentCharge? _nextDue(List<RentCharge> charges) {
    final due = charges.where((c) => c.dueDate != null).toList();
    due.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return due.isNotEmpty ? due.first : null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueState = ref.watch(rentChargesPagedProvider('pending'));
    final overdueState = ref.watch(rentChargesPagedProvider('overdue'));
    final dueController = ref.read(rentChargesPagedProvider('pending').notifier);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/tenant/notifications'),
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting
            Text(
              'Good ${_getGreeting()}',
              style: AppTextStyles.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Here\'s your rent overview',
              style: AppTextStyles.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Next Payment Card (Prominent)
            if (dueState.isInitialLoading)
              const _NextPaymentShimmer()
            else if (dueState.error != null && dueState.items.isEmpty)
              AppErrorView(
                title: 'Unable to load charges',
                message: dueState.error?.message ?? 'Something went wrong.',
                onRetry: dueController.loadInitial,
                retryLabel: 'Try again',
              )
            else if (dueState.items.isEmpty)
              _NoPaymentCard(onRefresh: dueController.refresh)
            else
              _NextPaymentCard(
                charge: _nextDue(dueState.items) ?? dueState.items.first,
              ),

            const SizedBox(height: AppSpacing.lg),

            // Overdue Alert (if any)
            if (!overdueState.isInitialLoading &&
                overdueState.error == null &&
                overdueState.items.isNotEmpty)
              _OverdueAlertCard(count: overdueState.items.length),

            if (!overdueState.isInitialLoading &&
                overdueState.error == null &&
                overdueState.items.isNotEmpty)
              const SizedBox(height: AppSpacing.lg),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTextStyles.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.build_outlined,
                    label: 'Maintenance',
                    onTap: () => context.go('/tenant/requests'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.description_outlined,
                    label: 'Documents',
                    onTap: () => context.go('/tenant/documents'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.payment_outlined,
                    label: 'Payments',
                    onTap: () => context.go('/tenant/payments'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Recent Charges Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Charges',
                  style: AppTextStyles.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/tenant/payments'),
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            if (dueState.isInitialLoading)
              const AppLoadingShimmer(itemCount: 2)
            else if (dueState.items.isEmpty)
              const SizedBox.shrink()
            else
              ...dueState.items.take(2).map((charge) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _ChargeSummaryCard(charge: charge),
                  )),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

/// Prominent next payment card with urgency indicators.
class _NextPaymentCard extends StatelessWidget {
  final RentCharge charge;

  const _NextPaymentCard({required this.charge});

  int? _daysUntilDue(DateTime? dueDate) {
    if (dueDate == null) return null;
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    return difference.inDays;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysUntilDue(charge.dueDate);
    final amount = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    ).format(charge.displayAmount);

    // Determine urgency
    final String urgencyMessage;
    final Color urgencyColor;

    if (days == null) {
      urgencyMessage = 'Due date pending';
      urgencyColor = AppColors.info;
    } else if (days < 0) {
      urgencyMessage = '${days.abs()} days overdue';
      urgencyColor = AppColors.danger;
    } else if (days == 0) {
      urgencyMessage = 'Due today';
      urgencyColor = AppColors.warning;
    } else if (days <= 3) {
      urgencyMessage = 'Due in $days days';
      urgencyColor = AppColors.warning;
    } else {
      urgencyMessage = 'Due in $days days';
      urgencyColor = AppColors.info;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.lg,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/tenant/payments'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NEXT PAYMENT',
                      style: AppTextStyles.labelSmall?.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: urgencyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: urgencyColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            days != null && days < 0
                                ? Icons.warning_amber_rounded
                                : Icons.schedule_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            urgencyMessage,
                            style: AppTextStyles.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Amount
                Text(
                  amount,
                  style: AppTextStyles.currencyLarge.copyWith(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 4),

                // Due date
                Text(
                  'Due ${_formatDate(charge.dueDate)}',
                  style: AppTextStyles.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.go('/tenant/payments'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          days != null && days <= 0 ? 'PAY NOW' : 'PAY RENT',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    OutlinedButton(
                      onPressed: () => context.go('/tenant/payments'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: 14,
                        ),
                      ),
                      child: const Text('Details'),
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
}

/// Shimmer placeholder for next payment card.
class _NextPaymentShimmer extends StatelessWidget {
  const _NextPaymentShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Card shown when there are no pending payments.
class _NoPaymentCard extends StatelessWidget {
  final VoidCallback onRefresh;

  const _NoPaymentCard({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 40,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'All Caught Up!',
            style: AppTextStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You have no pending rent payments.',
            style: AppTextStyles.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Overdue alert card.
class _OverdueAlertCard extends StatelessWidget {
  final int count;

  const _OverdueAlertCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return AppAlertBanner(
      title: '$count Overdue Payment${count > 1 ? "s" : ""}',
      message: 'Please clear your dues to avoid late fees.',
      type: AppAlertType.danger,
      actionLabel: 'Pay Now',
      onAction: () => context.go('/tenant/payments'),
    );
  }
}

/// Quick action card for tenant actions.
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact charge summary card.
class _ChargeSummaryCard extends StatelessWidget {
  final RentCharge charge;

  const _ChargeSummaryCard({required this.charge});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    ).format(charge.displayAmount);

    final statusType = switch (charge.status?.toLowerCase()) {
      'paid' => AppStatusType.success,
      'overdue' => AppStatusType.danger,
      'due' => AppStatusType.warning,
      'pending' => AppStatusType.info,
      _ => AppStatusType.neutral,
    };

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/tenant/payments'),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amount,
                        style: AppTextStyles.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Due ${_formatDate(charge.dueDate)}',
                        style: AppTextStyles.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppStatusBadge(
                  label: charge.status?.toUpperCase() ?? 'DUE',
                  type: statusType,
                  variant: AppStatusVariant.subtle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
