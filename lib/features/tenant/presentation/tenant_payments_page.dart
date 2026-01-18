import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/models/rent_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tenant Payments page with enhanced UI and large action buttons.
///
/// Features:
/// - Large, easy-to-tap Pay/Record buttons
/// - Status badges for charges
/// - Clean payment history
/// - Prominent amount display
class TenantPaymentsPage extends ConsumerStatefulWidget {
  const TenantPaymentsPage({super.key});

  @override
  ConsumerState<TenantPaymentsPage> createState() =>
      _TenantPaymentsPageState();
}

class _TenantPaymentsPageState extends ConsumerState<TenantPaymentsPage>
    with SingleTickerProviderStateMixin {
  bool _isPaying = false;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  TabController _ensureTabController() {
    return _tabController ??= TabController(length: 2, vsync: this);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  int? _daysUntilDue(DateTime? dueDate) {
    if (dueDate == null) return null;
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    return difference.inDays;
  }

  Future<void> _recordPayment(RentCharge charge) async {
    final tenantId = ref.read(authControllerProvider).user?.id?.toString();
    if (tenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to identify tenant.')),
      );
      return;
    }

    final input = await _PaymentInput.prompt(
      context,
      initialAmount: charge.amount ?? 0,
    );
    if (input == null) return;

    setState(() => _isPaying = true);
    try {
      final request = RentPaymentRequest(
        tenantId: tenantId,
        amount: input.amount,
        paidAt: DateTime.now(),
        method: input.method,
        notes: input.notes,
      );
      await ref.read(rentRepositoryProvider).recordPayment(request);
      ref.invalidate(rentChargesProvider);
      ref.invalidate(rentChargesPagedProvider);
      ref.invalidate(rentPaymentsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment recorded.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  Future<void> _startPaymentIntent(RentCharge charge) async {
    final chargeId = charge.id?.toString();
    if (chargeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid charge.')),
      );
      return;
    }

    setState(() => _isPaying = true);
    try {
      final intent = await ref
          .read(rentRepositoryProvider)
          .createTenantPaymentIntent(chargeId);
      final url = intent.paymentUrl;
      if (url != null && url.trim().isNotEmpty) {
        final uri = Uri.tryParse(url);
        if (uri != null && await launchUrl(uri)) {
          return;
        }
      }
      if (intent.paymentInstructions != null &&
          intent.paymentInstructions!.trim().isNotEmpty) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment instructions'),
            content: Text(intent.paymentInstructions!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment intent created.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabController = _ensureTabController();
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Charges'),
            Tab(text: 'History'),
          ],
        ),
      ),
      padding: EdgeInsets.zero,
      body: TabBarView(
        controller: tabController,
        children: [
          // Charges Tab
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(rentChargesPagedProvider(null));
              final controller =
                  ref.read(rentChargesPagedProvider(null).notifier);
              return PagedListView<RentCharge>(
                state: state,
                emptyTitle: 'No charges yet',
                emptyMessage: 'Your rent charges will appear here.',
                onLoadMore: controller.loadMore,
                onRefresh: controller.refresh,
                onRetry: controller.loadInitial,
                itemBuilder: (context, charge) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  child: _ChargeCard(
                    charge: charge,
                    isPaying: _isPaying,
                    onPayOnline: () => _startPaymentIntent(charge),
                    onRecord: () => _recordPayment(charge),
                    formatDate: _formatDate,
                    daysUntilDue: _daysUntilDue,
                  ),
                ),
              );
            },
          ),

          // History Tab
          Consumer(
            builder: (context, ref, _) {
              final paymentsAsync = ref.watch(rentPaymentsProvider);
              return paymentsAsync.when(
                data: (payments) {
                  if (payments.isEmpty) {
                    return const AppEmptyView(
                      title: 'No payments yet',
                      message: 'Your payment history will appear here.',
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: payments.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return _PaymentHistoryCard(
                        payment: payment,
                        formattedDate: _formatDate(payment.paidAt),
                      );
                    },
                  );
                },
                loading: () => const AppLoadingShimmer(itemCount: 2),
                error: (error, _) => AppErrorView(
                  title: 'Unable to load payments',
                  message: error.toString(),
                  onRetry: () => ref.invalidate(rentPaymentsProvider),
                  retryLabel: 'Try again',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Enhanced charge card with large action buttons.
class _ChargeCard extends StatelessWidget {
  final RentCharge charge;
  final bool isPaying;
  final VoidCallback onPayOnline;
  final VoidCallback onRecord;
  final String Function(DateTime?) formatDate;
  final int? Function(DateTime?) daysUntilDue;

  const _ChargeCard({
    required this.charge,
    required this.isPaying,
    required this.onPayOnline,
    required this.onRecord,
    required this.formatDate,
    required this.daysUntilDue,
  });

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    ).format(charge.displayAmount);

    final days = daysUntilDue(charge.dueDate);
    final statusType = switch (charge.status?.toLowerCase()) {
      'paid' => AppStatusType.success,
      'overdue' => AppStatusType.danger,
      'due' => AppStatusType.warning,
      'pending' => AppStatusType.info,
      _ => AppStatusType.neutral,
    };

    final isPaid = charge.status?.toLowerCase() == 'paid';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusType == AppStatusType.danger
              ? AppColors.danger.withOpacity(0.3)
              : Theme.of(context).colorScheme.outlineVariant,
          width: statusType == AppStatusType.danger ? 1.5 : 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with amount and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amount,
                        style: AppTextStyles.currencyMedium.copyWith(
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        'Due ${formatDate(charge.dueDate)}',
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

            if (!isPaid) ...[
              const SizedBox(height: AppSpacing.md),

              // Urgency indicator
              if (days != null && days < 7)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: days < 0
                        ? AppColors.danger.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        days < 0 ? Icons.warning_amber_rounded : Icons.schedule_rounded,
                        size: 14,
                        color: days < 0 ? AppColors.danger : AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        days < 0
                            ? '${days.abs()} days overdue'
                            : days == 0
                                ? 'Due today'
                                : 'Due in $days days',
                        style: AppTextStyles.labelSmall?.copyWith(
                          color: days < 0 ? AppColors.danger : AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Large action buttons
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: isPaying ? null : onPayOnline,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: isPaying
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'PAY ONLINE',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isPaying ? null : onRecord,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'RECORD',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Payment history card.
class _PaymentHistoryCard extends StatelessWidget {
  final RentPayment payment;
  final String formattedDate;

  const _PaymentHistoryCard({
    required this.payment,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    ).format(payment.amount ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Details
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
                    payment.method ?? 'Payment',
                    style: AppTextStyles.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Date
            Text(
              formattedDate,
              style: AppTextStyles.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Payment input dialog.
class _PaymentInput {
  const _PaymentInput({
    required this.amount,
    required this.method,
    this.notes,
  });

  final double amount;
  final String method;
  final String? notes;

  static Future<_PaymentInput?> prompt(
    BuildContext context, {
    required double initialAmount,
  }) {
    final amountController = TextEditingController(
      text: initialAmount > 0 ? initialAmount.toStringAsFixed(0) : '',
    );
    final notesController = TextEditingController();
    String method = 'UPI';

    return showDialog<_PaymentInput>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Record payment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹ ',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    value: method,
                    items: const [
                      DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                      DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                      DropdownMenuItem(
                        value: 'Bank Transfer',
                        child: Text('Bank Transfer'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => method = value ?? 'UPI');
                    },
                    decoration: const InputDecoration(labelText: 'Method'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final amount = double.tryParse(
                      amountController.text.trim(),
                    );
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter a valid amount.')),
                      );
                      return;
                    }
                    Navigator.of(context).pop(
                      _PaymentInput(
                        amount: amount,
                        method: method,
                        notes: notesController.text.trim(),
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
