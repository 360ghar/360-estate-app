import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:estate_app/features/inspections/presentation/inspection_text.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InspectionsPage extends ConsumerWidget {
  const InspectionsPage({super.key, this.propertyId, this.leaseId});

  final int? propertyId;
  final int? leaseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = InspectionListFilter(
      propertyId: propertyId,
      leaseId: leaseId,
    );
    final inspections = ref.watch(inspectionsListProvider(filter));
    final propertyTitles =
        ref.watch(propertyTitlesProvider).valueOrNull ?? const <int, String>{};
    final isEmpty = inspections.valueOrNull?.isEmpty ?? false;

    Future<void> refresh() async {
      ref.invalidate(inspectionsListProvider(filter));
      await ref
          .read(inspectionsListProvider(filter).future)
          .catchError((_) => const <Inspection>[]);
    }

    void create() => context.go(Routes.inspectionsNew);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inspectionsTitle),
        actions: [
          IconButton(
            tooltip: l10n.inspectionsTemplatesAction,
            icon: const Icon(Icons.checklist_rounded),
            onPressed: () => context.go(Routes.inspectionTemplates),
          ),
        ],
      ),
      // The empty state carries the same action, so the button is not shown
      // twice.
      floatingActionButton: isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: create,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.inspectionsNew),
            ),
      body: inspections.when(
        loading: () => const AppLoadingShimmer(),
        error: (error, _) => RefreshIndicator(
          onRefresh: refresh,
          child: StateScrollView(
            child: AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: () => ref.invalidate(inspectionsListProvider(filter)),
            ),
          ),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: refresh,
          child: items.isEmpty
              ? StateScrollView(
                  child: AppEmptyView(
                    title: l10n.inspectionsEmptyTitle,
                    message: l10n.inspectionsEmptyBody,
                    icon: Icons.fact_check_outlined,
                    action: FilledButton.icon(
                      onPressed: create,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.inspectionsNew),
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Room under the last row for the floating button.
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    96,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) => RiseIn(
                    index: index,
                    child: _InspectionRow(
                      inspection: items[index],
                      propertyTitle: propertyTitles[items[index].propertyId],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _InspectionRow extends StatelessWidget {
  const _InspectionRow({required this.inspection, this.propertyTitle});

  final Inspection inspection;
  final String? propertyTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = inspection.signState;
    final conducted = inspection.conductedAt;
    final id = inspection.id;
    return AppListCard(
      leading: ExcludeSemantics(
        child: Icon(
          inspection.inspectionType?.icon ?? Icons.fact_check_outlined,
          color: context.colors.onSurfaceVariant,
        ),
      ),
      title: inspectionTitle(l10n, inspection),
      subtitle: propertyTitle,
      facts: [
        conducted == null
            ? l10n.inspectionsDateNotSet
            : shortDate(context, conducted),
      ],
      status: AppStatusBadge(label: state.text(l10n), type: state.statusType),
      onTap: id == null
          ? null
          : () => context.go(Routes.inspectionDetail('$id')),
    );
  }
}
