import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_gradients.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/features/more/expenses/expenses_providers.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Maps expense category to icon and color.
({IconData icon, Color color}) _categoryVisual(String? category) {
  final cat = (category ?? '').toLowerCase();
  if (cat.contains('repair') || cat.contains('maintenance')) {
    return (icon: Icons.build_rounded, color: const Color(0xFFF59E0B));
  }
  if (cat.contains('utility') || cat.contains('electric') || cat.contains('water')) {
    return (icon: Icons.bolt_rounded, color: const Color(0xFF3B82F6));
  }
  if (cat.contains('tax')) {
    return (icon: Icons.account_balance_rounded, color: const Color(0xFF8B5CF6));
  }
  if (cat.contains('insurance')) {
    return (icon: Icons.shield_rounded, color: const Color(0xFF0284C7));
  }
  if (cat.contains('salary') || cat.contains('staff') || cat.contains('labour')) {
    return (icon: Icons.people_rounded, color: const Color(0xFF059669));
  }
  if (cat.contains('legal') || cat.contains('registration')) {
    return (icon: Icons.gavel_rounded, color: const Color(0xFFDC2626));
  }
  if (cat.contains('furnish') || cat.contains('furniture')) {
    return (icon: Icons.chair_rounded, color: const Color(0xFF14B8A6));
  }
  if (cat.contains('travel') || cat.contains('transport')) {
    return (icon: Icons.directions_car_rounded, color: const Color(0xFF6366F1));
  }
  return (icon: Icons.receipt_long_rounded, color: AppColors.textSecondary);
}

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  String _query = '';
  String? _selectedCategory;

  List<Expense> _applyFilters(List<Expense> items) {
    var filtered = items;
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      filtered = filtered
          .where((e) =>
              (e.title ?? '').toLowerCase().contains(q) ||
              (e.category ?? '').toLowerCase().contains(q) ||
              (e.propertyName ?? '').toLowerCase().contains(q))
          .toList();
    }
    if (_selectedCategory != null) {
      filtered =
          filtered.where((e) => e.category == _selectedCategory).toList();
    }
    return filtered;
  }

  Set<String> _categories(List<Expense> items) {
    return items
        .map((e) => e.category)
        .whereType<String>()
        .where((c) => c.isNotEmpty)
        .toSet();
  }

  double _monthlyTotal(List<Expense> items) {
    final now = DateTime.now();
    return items
        .where((e) =>
            e.date != null &&
            e.date!.year == now.year &&
            e.date!.month == now.month)
        .fold<double>(0, (sum, e) => sum + (e.amount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
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

          final categories = _categories(items);
          final filtered = _applyFilters(items);
          final total = _monthlyTotal(items);

          return Column(
            children: [
              // Monthly summary card
              _MonthlySummaryCard(total: total),

              // Search + filter
              AppSearchBar(
                hintText: 'Search expenses...',
                onChanged: (value) => setState(() => _query = value),
                filterChips: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = null),
                  ),
                  ...categories.map((cat) => FilterChip(
                        label: Text(cat),
                        selected: _selectedCategory == cat,
                        onSelected: (_) => setState(
                          () => _selectedCategory =
                              _selectedCategory == cat ? null : cat,
                        ),
                      )),
                ],
              ),

              // Expense list
              Expanded(
                child: filtered.isEmpty
                    ? const AppEmptyView(
                        title: 'No matches',
                        message: 'Try adjusting your search or filters.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.xxxl * 2,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return _ExpenseTile(expense: filtered[index]);
                        },
                      ),
              ),
            ],
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

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final formatter = NumberFormat.currency(symbol: '\u20B9', decimalDigits: 0);
    final monthName = DateFormat('MMMM yyyy').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppGradients.primarySubtle,
          color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 0.5,
          ),
          boxShadow: AppShadows.cardResting,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  monthName,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              formatter.format(total),
              style: AppTextStyles.currencyLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Total expenses this month',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    final formatter = NumberFormat.currency(symbol: '\u20B9', decimalDigits: 0);
    final date = expense.date == null
        ? null
        : DateFormat('dd MMM yyyy').format(expense.date!);
    final visual = _categoryVisual(expense.category);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.lg,
        child: InkWell(
          borderRadius: AppRadii.lg,
          onTap: () => context.go('/more/expenses/${expense.id}/edit'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Category icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: visual.color.withValues(alpha: isDark ? 0.15 : 0.1),
                    borderRadius: AppRadii.md,
                  ),
                  child: Icon(
                    visual.icon,
                    size: 22,
                    color: visual.color,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Title + metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title ?? 'Expense',
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          if (expense.propertyName != null &&
                              expense.propertyName!.isNotEmpty) ...[
                            Flexible(
                              child: Text(
                                expense.propertyName!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (date != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xs),
                                child: Text(
                                  '\u2022',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                          ],
                          if (date != null)
                            Text(
                              date,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Amount - bold, right-aligned, tabular figures
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatter.format(expense.amount ?? 0),
                      style: AppTextStyles.currencyXSmall.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    if (expense.category != null &&
                        expense.category!.isNotEmpty)
                      Text(
                        expense.category!,
                        style: textTheme.labelSmall?.copyWith(
                          color: visual.color,
                        ),
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
