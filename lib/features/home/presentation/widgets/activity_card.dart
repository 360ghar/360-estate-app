import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/features/home/models/dashboard_activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// The latest payments, maintenance requests and lease events, in one card.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    required this.onRetry,
  });

  final AsyncValue<List<DashboardActivityItem>> activity;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xs,
            ),
            child: Semantics(
              header: true,
              child: Text(
                l10n.homeActivityTitle,
                style: context.text.titleLarge,
              ),
            ),
          ),
          activity.when(
            loading: () =>
                const AppLoadingShimmer(itemCount: 3, itemHeight: 52),
            error: (error, _) => AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: onRetry,
            ),
            data: (items) {
              final visible = items
                  .where((i) => i.title?.trim().isNotEmpty ?? false)
                  .toList();
              if (visible.isEmpty) {
                return AppEmptyView(
                  title: l10n.homeActivityEmptyTitle,
                  message: l10n.homeActivityEmptyBody,
                  icon: Icons.history_rounded,
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < visible.length; i++) ...[
                    if (i > 0)
                      const Divider(indent: 56, endIndent: AppSpacing.lg),
                    _ActivityRow(item: visible[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final DashboardActivityItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, color) = switch (item.type) {
      ActivityType.rentPayment => (
        Icons.payments_outlined,
        context.palette.success,
      ),
      ActivityType.maintenanceRequest => (
        Icons.handyman_outlined,
        context.palette.warning,
      ),
      ActivityType.lease => (Icons.description_outlined, colors.secondary),
      null => (Icons.notifications_none_rounded, colors.onSurfaceVariant),
    };
    final at = item.at;
    final time = at == null
        ? null
        : DateFormat(
            'd MMM, h:mm a',
            Localizations.localeOf(context).toString(),
          ).format(at.toLocal());
    final description = item.description;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(child: Icon(icon, color: color, size: 22)),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title!.trim(),
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (description != null && description.trim().isNotEmpty)
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (time != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              time,
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
