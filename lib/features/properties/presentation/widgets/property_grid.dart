import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_cards.dart';
import 'package:flutter/material.dart';

/// The grid view of the properties: two columns on a phone, more on wider
/// screens, with the same refresh, empty, error and load-more states as the
/// list.
class PropertyGrid extends StatelessWidget {
  const PropertyGrid({
    super.key,
    required this.state,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onRetry,
    required this.emptyTitle,
    required this.emptyMessage,
    this.emptyAction,
  });

  final PagedListState<Property> state;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final String emptyTitle;
  final String emptyMessage;
  final Widget? emptyAction;

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) return const AppLoadingShimmer();
    if (state.items.isEmpty) {
      final failure = state.error;
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: StateScrollView(
          child: failure != null
              ? AppErrorView(
                  title: context.l10n.commonLoadFailedTitle,
                  message: failure.localizedMessage(context.l10n),
                  onRetry: onRetry,
                )
              : AppEmptyView(
                  title: emptyTitle,
                  message: emptyMessage,
                  icon: Icons.apartment_outlined,
                  action: emptyAction,
                ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.md;
        final width = constraints.maxWidth - AppSpacing.lg * 2;
        // A card needs about 170 dp of text room; large text means fewer
        // columns, never squeezed ones.
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final columns = (width / (170 * scale)).floor().clamp(1, 4);
        final cardWidth = (width - gap * (columns - 1)) / columns;
        final extent =
            cardWidth * PropertyGridCard.panelRatio +
            PropertyGridCard.textHeight(MediaQuery.textScalerOf(context));
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (!state.isLoadingMore &&
                  state.hasMore &&
                  n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                onLoadMore();
              }
              return false;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    96,
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: gap,
                      crossAxisSpacing: gap,
                      mainAxisExtent: extent,
                    ),
                    itemCount: state.items.length,
                    itemBuilder: (context, i) => RiseIn(
                      index: i,
                      child: PropertyGridCard(
                        key: ValueKey(state.items[i].id),
                        property: state.items[i],
                      ),
                    ),
                  ),
                ),
                if (state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 96),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
