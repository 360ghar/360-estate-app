import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// How many properties, how full they are, and what is empty or under repair.
class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key, required this.overview});

  final DashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final label = context.text.bodySmall?.copyWith(
      color: colors.onSurfaceVariant,
    );
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.homePortfolioTitle,
                    style: context.text.titleLarge,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => context.go('/properties/create'),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.homeAddProperty),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => context.go('/properties'),
                  borderRadius: AppRadii.sm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${overview.properties}',
                                style: context.text.displaySmall,
                              ),
                              Text(l10n.homePropertiesLabel, style: label),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${overview.occupancyPercent.toStringAsFixed(0)}%',
                              style: context.text.headlineMedium?.copyWith(
                                color: colors.primary,
                              ),
                            ),
                            Text(l10n.homeOccupancyLabel, style: label),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ExcludeSemantics(child: _OccupancyBar(overview: overview)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.lg,
                  children: [
                    AppStatusBadge(
                      label: '${overview.occupied} ${l10n.homeOccupied}',
                      type: AppStatusType.success,
                    ),
                    AppStatusBadge(
                      label: '${overview.vacant} ${l10n.homeVacant}',
                      type: AppStatusType.info,
                    ),
                    if (overview.underMaintenance > 0)
                      AppStatusBadge(
                        label:
                            '${overview.underMaintenance} '
                            '${l10n.homeUnderMaintenance}',
                        type: AppStatusType.warning,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Occupied, under maintenance, then vacant, as one rounded bar.
class _OccupancyBar extends StatelessWidget {
  const _OccupancyBar({required this.overview});

  final DashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    final total = overview.properties;
    final parts = [
      (overview.occupied, context.palette.success),
      (overview.underMaintenance, context.palette.warning),
      (overview.vacant, context.colors.surfaceContainerHighest),
    ];
    return ClipRRect(
      borderRadius: AppRadii.xs,
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            for (final (count, color) in parts)
              if (count > 0 && total > 0)
                Expanded(
                  flex: count,
                  child: Container(color: color),
                ),
            if (total == 0)
              Expanded(
                child: Container(color: context.colors.surfaceContainerHighest),
              ),
          ],
        ),
      ),
    );
  }
}
