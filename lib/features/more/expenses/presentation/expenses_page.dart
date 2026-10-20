import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/more/expenses/expenses_providers.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:estate_app/features/more/expenses/presentation/expense_category_visual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// What the owner spent: this month's total, then every expense, searchable
/// and filtered by category.
class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  String _query = '';
  ExpenseCategory? _category;

  bool _matches(Expense e) {
    if (_category != null && e.category != _category) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return (e.title ?? '').toLowerCase().contains(q) ||
        (e.category?.text(context.l10n) ?? '').toLowerCase().contains(q) ||
        (e.propertyName ?? '').toLowerCase().contains(q);
  }

  Future<void> _reload() async {
    ref.invalidate(expensesListProvider);
    await ref
        .read(expensesListProvider.future)
        .catchError((_) => const <Expense>[]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expenses = ref.watch(expensesListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.expensesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/expenses/new'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.expensesAdd),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: expenses.when(
          loading: () => const AppLoadingShimmer(),
          error: (error, _) => StateScrollView(
            child: AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: _reload,
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return StateScrollView(
                child: AppEmptyView(
                  title: l10n.expensesEmptyTitle,
                  message: l10n.expensesEmptyBody,
                  icon: Icons.receipt_long_outlined,
                ),
              );
            }
            final categories = {for (final e in items) ?e.category}.toList()
              ..sort((a, b) => a.index.compareTo(b.index));
            final shown = items.where(_matches).toList();
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              // Room at the foot so the last row clears the button.
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                _MonthSummary(items: items),
                AppSearchBar(
                  hintText: l10n.expensesSearchHint,
                  onChanged: (value) => setState(() => _query = value.trim()),
                  filterChips: [
                    FilterChip(
                      label: Text(l10n.tenantsFilterAll),
                      selected: _category == null,
                      onSelected: (_) => setState(() => _category = null),
                    ),
                    for (final c in categories)
                      FilterChip(
                        label: Text(c.text(l10n)),
                        selected: _category == c,
                        onSelected: (_) => setState(
                          () => _category = _category == c ? null : c,
                        ),
                      ),
                  ],
                ),
                if (shown.isEmpty)
                  AppEmptyView(
                    title: l10n.expensesNoMatchTitle,
                    message: l10n.expensesNoMatchBody,
                    icon: Icons.search_off_rounded,
                  ),
                for (var i = 0; i < shown.length; i++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xs,
                    ),
                    child: RiseIn(
                      index: i,
                      child: _ExpenseRow(expense: shown[i]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// This month's spend in the display face, with the count under it.
class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.items});

  final List<Expense> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final month = items
        .where((e) => e.date?.year == now.year && e.date?.month == now.month)
        .toList();
    final total = month.fold<double>(0, (sum, e) => sum + (e.amount ?? 0));
    final monthName = DateFormat.MMMM(
      Localizations.localeOf(context).toString(),
    ).format(now);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expensesSpentIn(monthName),
              style: context.text.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              rupees(total),
              style: AppTextStyles.currencyLarge.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            Text(
              l10n.expensesCountThisMonth(month.length),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final category = expense.category;
    final title = expense.title?.trim();
    final date = expense.date;
    return AppListCard(
      leading: ExcludeSemantics(
        child: Icon(
          category?.icon ?? Icons.receipt_long_outlined,
          color: context.colors.onSurfaceVariant,
        ),
      ),
      title: title != null && title.isNotEmpty
          ? title
          : category?.text(l10n) ?? l10n.expensesUntitled,
      subtitle: expense.propertyName,
      facts: [
        ?category?.text(l10n),
        if (date != null) shortDate(context, date),
      ],
      trailing: Text(
        rupees(expense.amount ?? 0),
        style: AppTextStyles.currencySmall.copyWith(
          color: context.colors.onSurface,
        ),
      ),
      onTap: expense.id == null
          ? null
          : () => context.go('/more/expenses/${expense.id}/edit'),
    );
  }
}
