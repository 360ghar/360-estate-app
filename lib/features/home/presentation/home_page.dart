import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/features/collections/collections_providers.dart';
import 'package:estate_app/features/home/home_providers.dart';
import 'package:estate_app/features/home/models/dashboard_overview.dart';
import 'package:estate_app/features/home/presentation/widgets/activity_card.dart';
import 'package:estate_app/features/home/presentation/widgets/portfolio_card.dart';
import 'package:estate_app/features/home/presentation/widgets/rent_month_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The owner's day: this month's rent first, then the portfolio, then what
/// changed lately.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(dashboardOverviewProvider);
    final activity = ref.watch(dashboardActivityProvider);
    final charges = ref.watch(allRentChargesProvider);

    void reloadOverview() {
      // A refresh must reach the backend, not the cached figures.
      ref.read(dashboardRepositoryProvider).clearCache();
      ref.invalidate(dashboardOverviewProvider);
    }

    void reloadActivity() {
      ref.read(dashboardRepositoryProvider).clearCache();
      ref.invalidate(dashboardActivityProvider);
    }

    return Scaffold(
      appBar: _GreetingBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          reloadOverview();
          reloadActivity();
          ref.invalidate(allRentChargesProvider);
          await ref
              .read(dashboardOverviewProvider.future)
              .catchError((_) => const DashboardOverview());
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            ...overview.when(
              loading: () => [
                const AppLoadingShimmer(
                  itemCount: 2,
                  itemHeight: 220,
                  padding: EdgeInsets.zero,
                ),
              ],
              error: (error, _) => [
                AppErrorView(
                  title: context.l10n.commonLoadFailedTitle,
                  message: userFacingMessage(error),
                  onRetry: reloadOverview,
                ),
              ],
              data: (data) => _hasData(data)
                  ? [
                      RiseIn(
                        child: RentMonthCard(
                          overview: data,
                          charges: charges,
                          onRetryCharges: () =>
                              ref.invalidate(allRentChargesProvider),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RiseIn(index: 1, child: PortfolioCard(overview: data)),
                    ]
                  : [
                      AppEmptyView(
                        title: context.l10n.homeEmptyTitle,
                        message: context.l10n.homeEmptyBody,
                        icon: Icons.apartment_outlined,
                        action: FilledButton.icon(
                          onPressed: () => context.go('/properties/create'),
                          icon: const Icon(Icons.add_rounded),
                          label: Text(context.l10n.homeAddProperty),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: AppSpacing.md),
            RiseIn(
              index: 2,
              child: ActivityCard(activity: activity, onRetry: reloadActivity),
            ),
          ],
        ),
      ),
    );
  }

  /// A first-run account has no property: the totals are zero.
  static bool _hasData(DashboardOverview overview) =>
      (overview.totalProperties ?? 0) > 0 ||
      (overview.monthlyRevenueCurrent ?? 0) > 0 ||
      (overview.outstandingRentTotal ?? 0) > 0;
}

/// The greeting in the display face, with today's date under it.
class _GreetingBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? l10n.homeGreetingMorning
        : now.hour < 17
        ? l10n.homeGreetingAfternoon
        : l10n.homeGreetingEvening;
    final date = DateFormat.MMMMEEEEd(
      Localizations.localeOf(context).toString(),
    ).format(now);
    return AppBar(
      toolbarHeight: 76,
      titleSpacing: AppSpacing.lg,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting, style: context.text.headlineMedium),
          Text(
            date,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: l10n.notifications,
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () => context.go('/more/notifications'),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
