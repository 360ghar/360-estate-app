import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:estate_app/features/inspections/presentation/inspection_text.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InspectionDetailPage extends ConsumerStatefulWidget {
  const InspectionDetailPage({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  ConsumerState<InspectionDetailPage> createState() =>
      _InspectionDetailPageState();
}

class _InspectionDetailPageState extends ConsumerState<InspectionDetailPage> {
  bool _signing = false;

  int? get _id => int.tryParse(widget.inspectionId);

  Future<void> _sign(int id) async {
    final l10n = context.l10n;
    final ok = await context.confirm(
      title: l10n.inspectionDetailSignTitle,
      message: l10n.inspectionDetailSignBody,
      confirmLabel: l10n.inspectionDetailSignConfirm,
    );
    if (!ok || !mounted) return;
    setState(() => _signing = true);
    try {
      await ref.read(inspectionsRepositoryProvider).sign(id);
      ref
        ..invalidate(inspectionDetailProvider(id))
        ..invalidate(inspectionsListProvider);
      if (mounted) context.showSnack(l10n.inspectionDetailSigned);
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _signing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = _id;
    final appBar = AppBar(title: Text(l10n.inspectionDetailTitle));
    if (id == null) {
      return Scaffold(
        appBar: appBar,
        body: AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: l10n.inspectionDetailInvalidLink,
        ),
      );
    }
    final inspection = ref.watch(inspectionDetailProvider(id));
    final propertyTitles =
        ref.watch(propertyTitlesProvider).valueOrNull ?? const <int, String>{};

    Future<void> refresh() async {
      ref.invalidate(inspectionDetailProvider(id));
      await ref
          .read(inspectionDetailProvider(id).future)
          .then<void>((_) {}, onError: (_) {});
    }

    return Scaffold(
      appBar: appBar,
      body: inspection.when(
        loading: () => const AppLoadingShimmer(itemCount: 3, itemHeight: 120),
        error: (error, _) => RefreshIndicator(
          onRefresh: refresh,
          child: StateScrollView(
            child: AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: () => ref.invalidate(inspectionDetailProvider(id)),
            ),
          ),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: refresh,
          child: _InspectionBody(
            inspection: data,
            propertyTitle: propertyTitles[data.propertyId],
            signing: _signing,
            onSign: () => _sign(id),
          ),
        ),
      ),
    );
  }
}

class _InspectionBody extends StatelessWidget {
  const _InspectionBody({
    required this.inspection,
    required this.propertyTitle,
    required this.signing,
    required this.onSign,
  });

  final Inspection inspection;
  final String? propertyTitle;
  final bool signing;
  final VoidCallback onSign;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = inspection.signState;
    final notes = inspection.overallNotes?.trim() ?? '';
    final items = inspection.items;
    final conducted = inspection.conductedAt;
    final facts = [
      ?propertyTitle,
      conducted == null
          ? l10n.inspectionsDateNotSet
          : shortDate(context, conducted),
    ];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          inspectionTitle(l10n, inspection),
          style: context.text.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          facts.join('  ·  '),
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppStatusBadge(
            label: state.text(l10n),
            type: state.statusType,
            variant: AppStatusVariant.filled,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppSectionCard(
          title: l10n.inspectionDetailSignatures,
          children: [
            _SignatureRow(
              who: l10n.inspectionDetailOwner,
              at: inspection.signedByOwnerAt,
            ),
            const SizedBox(height: AppSpacing.md),
            _SignatureRow(
              who: l10n.inspectionDetailTenant,
              at: inspection.signedByTenantAt,
            ),
          ],
        ),
        if (notes.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          AppSectionCard(
            title: l10n.inspectionFormNotes,
            children: [Text(notes, style: context.text.bodyMedium)],
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppSectionCard(
          title: l10n.inspectionFormChecklistSection,
          children: [
            if (items.isEmpty)
              Text(
                l10n.inspectionDetailChecklistEmpty,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            for (final (index, item) in items.indexed) ...[
              if (index > 0) const Divider(height: AppSpacing.xl),
              _ChecklistItemRow(item: item),
            ],
          ],
        ),
        // The sign route records the signature of the caller's side.
        if (inspection.signedByOwnerAt == null) ...[
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: signing ? null : onSign,
            icon: signing
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.draw_outlined),
            label: Text(l10n.inspectionDetailSign),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _SignatureRow extends StatelessWidget {
  const _SignatureRow({required this.who, required this.at});

  final String who;
  final DateTime? at;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final signed = at;
    return Row(
      children: [
        Expanded(child: Text(who, style: context.text.bodyLarge)),
        AppStatusBadge(
          label: signed == null
              ? l10n.inspectionDetailNotSigned
              : l10n.inspectionDetailSignedOn(shortDate(context, signed)),
          type: signed == null ? AppStatusType.neutral : AppStatusType.success,
        ),
      ],
    );
  }
}

class _ChecklistItemRow extends StatelessWidget {
  const _ChecklistItemRow({required this.item});

  final InspectionItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = item.status?.trim() ?? '';
    final notes = item.notes?.trim() ?? '';
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final (label, type) = status.isEmpty
        ? (l10n.inspectionItemPending, AppStatusType.neutral)
        : inspectionItemStatus(l10n, status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title ?? l10n.inspectionFormChecklistSection,
                style: context.text.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (notes.isNotEmpty) Text(notes, style: muted),
              if (item.isRequired == true)
                Text(l10n.inspectionDetailRequired, style: muted),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        AppStatusBadge(label: label, type: type),
      ],
    );
  }
}
