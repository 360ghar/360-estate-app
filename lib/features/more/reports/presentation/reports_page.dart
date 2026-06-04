import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/presentation/report_drilldown_page.dart';
import 'package:estate_app/features/more/reports/reports_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Visual metadata for each report type.
const _reportMeta = <ReportType, ({IconData icon, Color color, String description})>{
  ReportType.rentRoll: (
    icon: Icons.receipt_long_rounded,
    color: Color(0xFF1E3A5F),
    description: 'Current rent charges across all properties',
  ),
  ReportType.income: (
    icon: Icons.trending_up_rounded,
    color: Color(0xFF059669),
    description: 'Revenue collected from tenants',
  ),
  ReportType.expenses: (
    icon: Icons.trending_down_rounded,
    color: Color(0xFFDC2626),
    description: 'All outgoing expenses by category',
  ),
  ReportType.pnl: (
    icon: Icons.balance_rounded,
    color: Color(0xFF8B5CF6),
    description: 'Profit and loss summary',
  ),
  ReportType.occupancy: (
    icon: Icons.apartment_rounded,
    color: Color(0xFF3B82F6),
    description: 'Unit occupancy rates and vacancy',
  ),
  ReportType.maintenance: (
    icon: Icons.build_rounded,
    color: Color(0xFFF59E0B),
    description: 'Maintenance requests and status',
  ),
};

String _reportLabel(ReportType type) {
  return switch (type) {
    ReportType.rentRoll => 'Rent Roll',
    ReportType.income => 'Income',
    ReportType.expenses => 'Expenses',
    ReportType.pnl => 'P&L',
    ReportType.occupancy => 'Occupancy',
    ReportType.maintenance => 'Maintenance',
  };
}

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  ReportType _type = ReportType.rentRoll;
  DateTime? _from;
  DateTime? _to;
  ReportRequest? _request;

  Future<void> _pickFrom() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
      initialDate: _from ?? DateTime.now().subtract(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _from = picked);
    }
  }

  Future<void> _pickTo() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _to ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _to = picked);
    }
  }

  void _runReport() {
    setState(() {
      _request = ReportRequest(type: _type, from: _from, to: _to);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = _request;
    final reportAsync =
        request == null ? null : ref.watch(reportProvider(request));
    final dateFormat = DateFormat('dd MMM yyyy');
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('Reports')),
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Report type selector - visual cards
          Text(
            'Report type',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ReportTypeGrid(
            selectedType: _type,
            onTypeChanged: (type) => setState(() => _type = type),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Date range
          Text(
            'Date range',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: AppRadii.lg,
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                width: 0.5,
              ),
              boxShadow: AppShadows.cardResting,
            ),
            child: Row(
              children: [
                // From date
                Expanded(
                  child: InkWell(
                    borderRadius: AppRadii.md,
                    onTap: _pickFrom,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceSecondary
                            : AppColors.surfaceSecondary,
                        borderRadius: AppRadii.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: scheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                _from == null
                                    ? 'Any'
                                    : dateFormat.format(_from!),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ),

                // To date
                Expanded(
                  child: InkWell(
                    borderRadius: AppRadii.md,
                    onTap: _pickTo,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceSecondary
                            : AppColors.surfaceSecondary,
                        borderRadius: AppRadii.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: scheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                _to == null
                                    ? 'Any'
                                    : dateFormat.format(_to!),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Generate button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: _runReport,
              icon: const Icon(Icons.analytics_rounded),
              label: const Text('Generate report'),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Results
          if (reportAsync == null)
            const AppEmptyView(
              title: 'No report yet',
              message: 'Select a report type and generate.',
            )
          else
            reportAsync.when(
              data: (result) {
                if (result.rows.isEmpty) {
                  return const AppEmptyView(
                    title: 'No data',
                    message: 'There is nothing to show for this report.',
                  );
                }

                final formatter =
                    NumberFormat.currency(symbol: '\u20B9', decimalDigits: 0);
                final meta = _reportMeta[result.type];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Results header
                    Row(
                      children: [
                        if (meta != null) ...[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: meta.color
                                  .withValues(alpha: isDark ? 0.15 : 0.08),
                              borderRadius: AppRadii.sm,
                            ),
                            child: Icon(
                              meta.icon,
                              size: 18,
                              color: meta.color,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          '${_reportLabel(result.type)} Results',
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Result rows
                    ...result.rows.map((row) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: AppRadii.lg,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkCardBorder
                                : AppColors.cardBorder,
                            width: 0.5,
                          ),
                          boxShadow: AppShadows.cardResting,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: AppRadii.lg,
                          child: InkWell(
                            borderRadius: AppRadii.lg,
                            onTap: () => context.go(
                              '/more/reports/drilldown',
                              extra: ReportDrilldownArgs(
                                result: result,
                                row: row,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      row.label ?? 'Item',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Text(
                                    row.amount != null
                                        ? formatter.format(row.amount)
                                        : row.value ?? '-',
                                    style:
                                        AppTextStyles.currencyXSmall.copyWith(
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 18,
                                    color: AppColors.textTertiary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const AppLoadingShimmer(itemCount: 4),
              error: (error, _) => AppErrorView(
                title: 'Unable to load report',
                message: error.toString(),
                onRetry: _runReport,
                retryLabel: 'Try again',
              ),
            ),
        ],
      ),
    );
  }
}

/// 2-column grid of report type cards.
class _ReportTypeGrid extends StatelessWidget {
  const _ReportTypeGrid({
    required this.selectedType,
    required this.onTypeChanged,
  });

  final ReportType selectedType;
  final ValueChanged<ReportType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.45,
      children: ReportType.values.map((type) {
        final meta = _reportMeta[type]!;
        final isSelected = selectedType == type;

        return GestureDetector(
          onTap: () => onTypeChanged(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? meta.color.withValues(alpha: isDark ? 0.15 : 0.06)
                  : scheme.surface,
              borderRadius: AppRadii.lg,
              border: Border.all(
                color: isSelected
                    ? meta.color.withValues(alpha: 0.4)
                    : isDark
                        ? AppColors.darkCardBorder
                        : AppColors.cardBorder,
                width: isSelected ? 1.5 : 0.5,
              ),
              boxShadow: isSelected
                  ? AppShadows.cardHovered
                  : AppShadows.cardResting,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: meta.color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: AppRadii.sm,
                  ),
                  child: Icon(
                    meta.icon,
                    size: 20,
                    color: meta.color,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _reportLabel(type),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? meta.color : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  meta.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
