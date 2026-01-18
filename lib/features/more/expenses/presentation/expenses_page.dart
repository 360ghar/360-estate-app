import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/more/expenses/expenses_providers.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesListProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Expenses')),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/expenses/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: expensesAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyView(
              title: 'No expenses yet',
              message: 'Track repair, utility, and vendor expenses here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _ExpenseTile(expense: items[index]);
            },
          );
        },
        loading: () => const AppLoadingShimmer(),
        error: (error, _) => AppErrorView(
          title: 'Unable to load expenses',
          message: error.toString(),
          onRetry: () => ref.invalidate(expensesListProvider),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: 'INR ');
    final date = expense.date == null
        ? 'Date not set'
        : DateFormat('dd MMM yyyy').format(expense.date!);
    return Card(
      child: ListTile(
        title: Text(expense.title ?? 'Expense'),
        subtitle: Text(expense.propertyName ?? date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatter.format(expense.amount ?? 0)),
            Text(expense.category ?? date),
          ],
        ),
        onTap: () => context.go('/more/expenses/${expense.id}/edit'),
      ),
    );
  }
}
