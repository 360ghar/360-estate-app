import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/config/feature_flags.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/feature_coming_soon.dart';
import 'package:estate_app/features/finance/domain/entities/expense.dart';
import 'package:estate_app/features/finance/domain/entities/rent_charge.dart';
import 'package:estate_app/features/finance/domain/entities/rent_payment.dart';
import 'package:estate_app/features/finance/presentation/controllers/expenses_controller.dart';
import 'package:estate_app/features/finance/presentation/controllers/rent_charges_controller.dart';
import 'package:estate_app/features/finance/presentation/controllers/rent_payments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show coming soon if feature is disabled
    if (!FeatureFlags.financeEnabled) {
      return Scaffold(
        appBar: AppBar(title: const Text('Finance')),
        body: const FeatureComingSoon(
          featureName: 'Finance Management',
          icon: Icons.account_balance_wallet,
          description: 'Track rent payments, generate charges, and manage property expenses.',
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Charges'),
            Tab(text: 'Payments'),
            Tab(text: 'Expenses'),
          ],
        ),
        actions: [
          Obx(() {
            final chargesController = Get.find<RentChargesController>();
            if (chargesController.isGenerating.value) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: 'Generate Rent Charges',
              onPressed: () => _showGenerateDialog(context),
            );
          }),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _RentChargesTab(),
          _RentPaymentsTab(),
          _ExpensesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'finance_fab',
        onPressed: () => _onFabPressed(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _onFabPressed(BuildContext context) {
    final currentTab = _tabController.index;
    if (currentTab == 2) {
      // Expenses tab - create new expense
      unawaited(Get.toNamed<Expense>(Routes.expenseCreate));
    } else if (currentTab == 0) {
      // Charges tab - show generate dialog
      _showGenerateDialog(context);
    }
  }

  void _showGenerateDialog(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Rent Charges'),
        content: const Text(
          'This will generate rent charges for all active leases for the current month. Charges that already exist will be skipped.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              unawaited(Get.find<RentChargesController>().generateCharges());
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    ),);
  }
}

class _RentChargesTab extends GetView<RentChargesController> {
  const _RentChargesTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status filter chips
        Obx(() => _buildStatusFilters(context)),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.failure.value != null && controller.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.failure.value!.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.loadCharges,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (controller.items.isEmpty) {
              return const Center(
                child: Text('No rent charges found'),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadCharges,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.items.length) {
                    unawaited(controller.loadMore());
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final charge = controller.items[index];
                  return _RentChargeCard(charge: charge);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatusFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: controller.filterStatus.value == null,
            onSelected: (_) => controller.setStatusFilter(null),
          ),
          const SizedBox(width: 8),
          ...RentChargeStatus.values.map((status) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(status.displayName),
                  selected: controller.filterStatus.value == status,
                  onSelected: (_) => controller.setStatusFilter(
                    controller.filterStatus.value == status ? null : status,
                  ),
                ),
              ),),
        ],
      ),
    );
  }
}

class _RentChargeCard extends StatelessWidget {
  const _RentChargeCard({required this.charge});

  final RentCharge charge;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _showChargeActions(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      charge.propertyTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _StatusBadge(status: charge.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                charge.tenantName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Period',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        Text(
                          charge.periodLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(charge.dueDate),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: charge.isOverdue ? Theme.of(context).colorScheme.error : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AmountInfo(
                    label: 'Total Due',
                    amount: currencyFormat.format(charge.totalDue),
                  ),
                  _AmountInfo(
                    label: 'Paid',
                    amount: currencyFormat.format(charge.amountPaid),
                    color: Colors.green,
                  ),
                  _AmountInfo(
                    label: 'Balance',
                    amount: currencyFormat.format(charge.balance),
                    color: charge.balance > 0 ? Colors.red : Colors.green,
                    isBold: true,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChargeActions(BuildContext context) {
    if (charge.balance <= 0) return;

    unawaited(showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Record Payment'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Get.toNamed<RentPayment>(
                  Routes.recordPayment,
                  arguments: charge,
                );
                if (result != null) {
                  unawaited(Get.find<RentChargesController>().loadCharges());
                  unawaited(Get.find<RentPaymentsController>().loadPayments());
                }
              },
            ),
          ],
        ),
      ),
    ),);
  }
}

class _AmountInfo extends StatelessWidget {
  const _AmountInfo({
    required this.label,
    required this.amount,
    this.color,
    this.isBold = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String label;
  final String amount;
  final Color? color;
  final bool isBold;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final RentChargeStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      RentChargeStatus.pending => (Colors.orange[700]!, Colors.orange[50]!),
      RentChargeStatus.paid => (Colors.green[700]!, Colors.green[50]!),
      RentChargeStatus.partiallyPaid => (Colors.blue[700]!, Colors.blue[50]!),
      RentChargeStatus.overdue => (Colors.red[700]!, Colors.red[50]!),
      RentChargeStatus.waived => (Colors.grey[700]!, Colors.grey[200]!),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _RentPaymentsTab extends GetView<RentPaymentsController> {
  const _RentPaymentsTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.failure.value != null && controller.items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.failure.value!.message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.loadPayments,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.items.isEmpty) {
        return const Center(
          child: Text('No payments recorded'),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadPayments,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount:
              controller.items.length + (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.items.length) {
              unawaited(controller.loadMore());
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final payment = controller.items[index];
            return _RentPaymentCard(payment: payment);
          },
        ),
      );
    });
  }
}

class _RentPaymentCard extends StatelessWidget {
  const _RentPaymentCard({required this.payment});

  final RentPayment payment;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currencyFormat.format(payment.amount),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.yMMMd().format(payment.paymentDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (payment.referenceNumber != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Ref: ${payment.referenceNumber}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                payment.paymentMethod.displayName,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesTab extends GetView<ExpensesController> {
  const _ExpensesTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category filter chips
        Obx(() => _buildCategoryFilters(context)),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.failure.value != null && controller.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.failure.value!.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.loadExpenses,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (controller.items.isEmpty) {
              return const Center(
                child: Text('No expenses recorded'),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadExpenses,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.items.length) {
                    unawaited(controller.loadMore());
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final expense = controller.items[index];
                  return _ExpenseCard(expense: expense);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: controller.filterCategory.value == null,
            onSelected: (_) => controller.setCategoryFilter(null),
          ),
          const SizedBox(width: 8),
          ...ExpenseCategory.values.take(5).map((category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category.displayName),
                  selected: controller.filterCategory.value == category,
                  onSelected: (_) => controller.setCategoryFilter(
                    controller.filterCategory.value == category
                        ? null
                        : category,
                  ),
                ),
               ),),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          final result = await Get.toNamed<Expense>(
            Routes.expenseCreate,
            arguments: expense,
          );
          if (result != null) {
            unawaited(Get.find<ExpensesController>().loadExpenses());
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: expense.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  expense.category.icon,
                  color: expense.category.color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.description,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      expense.category.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    if (expense.propertyTitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        expense.propertyTitle!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(expense.amount),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMd().format(expense.expenseDate),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
