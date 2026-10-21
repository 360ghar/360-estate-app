import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/with_text_controller.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/presentation/widgets/application_detail_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationInboxDetailPage extends ConsumerStatefulWidget {
  const ApplicationInboxDetailPage({super.key, required this.applicationId});

  final String applicationId;

  @override
  ConsumerState<ApplicationInboxDetailPage> createState() =>
      _ApplicationInboxDetailPageState();
}

class _ApplicationInboxDetailPageState
    extends ConsumerState<ApplicationInboxDetailPage> {
  bool _deciding = false;

  int? get _id => int.tryParse(widget.applicationId);

  Future<void> _decide(ApplicationDecision decision) async {
    final id = _id;
    if (id == null) return;
    final l10n = context.l10n;
    final approve = decision == ApplicationDecision.approved;
    // The dialog gives back the notes typed, or null for Cancel.
    final notes = await showDialog<String>(
      context: context,
      builder: (_) => WithTextController(
        builder: (context, notesController) => AlertDialog(
          title: Text(
            approve
                ? l10n.applicationDetailApproveTitle
                : l10n.applicationDetailRejectTitle,
          ),
          content: TextField(
            controller: notesController,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.applicationDetailDecisionNotes,
              helperText: l10n.applicationDetailDecisionNotesHelp,
              alignLabelWithHint: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              style: approve
                  ? null
                  : FilledButton.styleFrom(
                      backgroundColor: context.colors.error,
                      foregroundColor: context.colors.onError,
                    ),
              onPressed: () =>
                  Navigator.of(context).pop(notesController.text.trim()),
              child: Text(
                approve
                    ? l10n.applicationDetailApprove
                    : l10n.applicationDetailReject,
              ),
            ),
          ],
        ),
      ),
    );
    if (notes == null || !mounted) return;

    setState(() => _deciding = true);
    try {
      await ref
          .read(applicationsRepositoryProvider)
          .decide(
            id,
            ApplicationDecisionRequest(decision: decision, notes: notes),
          );
      ref
        ..invalidate(applicationInboxPagedProvider)
        ..invalidate(applicationDetailProvider(id));
      if (mounted) {
        context.showSnack(
          approve
              ? l10n.applicationDetailApproved
              : l10n.applicationDetailRejected,
        );
      }
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _deciding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appBar = AppBar(title: Text(l10n.applicationDetailTitle));
    final id = _id;
    if (id == null) {
      return Scaffold(
        appBar: appBar,
        body: AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: l10n.applicationDetailInvalidLink,
        ),
      );
    }
    final application = ref.watch(applicationDetailProvider(id));

    Future<void> refresh() async {
      ref.invalidate(applicationDetailProvider(id));
      await ref
          .read(applicationDetailProvider(id).future)
          .then<void>((_) {}, onError: (_) {});
    }

    return Scaffold(
      appBar: appBar,
      body: application.when(
        loading: () => const AppLoadingShimmer(itemCount: 3, itemHeight: 120),
        error: (error, _) => RefreshIndicator(
          onRefresh: refresh,
          child: StateScrollView(
            child: AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: () => ref.invalidate(applicationDetailProvider(id)),
            ),
          ),
        ),
        data: (submission) => RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              ApplicationDetailBody(
                submission: submission,
                deciding: _deciding,
                onApprove: () => _decide(ApplicationDecision.approved),
                onReject: () => _decide(ApplicationDecision.rejected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
