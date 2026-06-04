import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ApplicationInboxDetailPage extends ConsumerStatefulWidget {
  const ApplicationInboxDetailPage({super.key, required this.applicationId});

  final String applicationId;

  @override
  ConsumerState<ApplicationInboxDetailPage> createState() =>
      _ApplicationInboxDetailPageState();
}

class _ApplicationInboxDetailPageState
    extends ConsumerState<ApplicationInboxDetailPage> {
  bool _isProcessing = false;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  Future<void> _submitDecision(String decision) async {
    final notesController = TextEditingController();
    final isApproval = decision == 'approved';
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (isApproval ? AppColors.success : AppColors.danger)
                    .withValues(alpha: 0.1),
                borderRadius: AppRadii.sm,
              ),
              child: Icon(
                isApproval
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: isApproval ? AppColors.success : AppColors.danger,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(isApproval ? 'Approve Application' : 'Reject Application'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isApproval
                  ? 'Are you sure you want to approve this application?'
                  : 'Are you sure you want to reject this application?',
              style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Add any comments about your decision...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isApproval ? AppColors.success : AppColors.danger,
            ),
            child: Text(isApproval ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );
    if (shouldProceed != true) return;

    setState(() => _isProcessing = true);
    try {
      final request = ApplicationDecisionRequest(
        decision: decision,
        notes: notesController.text.trim(),
      );
      await ref
          .read(applicationsRepositoryProvider)
          .decide(widget.applicationId, request);
      ref.invalidate(applicationInboxPagedProvider);
      ref.invalidate(applicationDetailProvider(widget.applicationId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application $decision.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationAsync =
        ref.watch(applicationDetailProvider(widget.applicationId));

    return AppScaffold(
      appBar: AppBar(title: const Text('Application details')),
      scrollable: true,
      body: applicationAsync.when(
        data: (submission) => _ApplicationDetail(
          submission: submission,
          formattedDate: _formatDate(submission.submittedAt),
          isProcessing: _isProcessing,
          onApprove: () => _submitDecision('approved'),
          onReject: () => _submitDecision('rejected'),
        ),
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load application',
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(applicationDetailProvider(widget.applicationId)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _ApplicationDetail extends StatelessWidget {
  const _ApplicationDetail({
    required this.submission,
    required this.formattedDate,
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  final ApplicationSubmission submission;
  final String formattedDate;
  final bool isProcessing;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'pending':
        return AppStatusType.info;
      case 'reviewed':
        return AppStatusType.warning;
      case 'approved':
        return AppStatusType.success;
      case 'rejected':
        return AppStatusType.danger;
      default:
        return AppStatusType.neutral;
    }
  }

  String _statusLabel(String status) {
    if (status.isEmpty) return 'New';
    return status[0].toUpperCase() + status.substring(1);
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final status = submission.status ?? 'pending';
    final applicant = submission.applicantName ?? 'Applicant';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Applicant Info Header ---
        AppCard(
          variant: AppCardVariant.tinted,
          tintColor: AppColors.accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary
                          .withValues(alpha: isDark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(applicant),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            Icon(
                              Icons.apartment_rounded,
                              size: 13,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Flexible(
                              child: Text(
                                submission.propertyName ?? 'Property',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppStatusBadge(
                    label: _statusLabel(status),
                    type: _statusType(status),
                    variant: AppStatusVariant.subtle,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _ContactRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: submission.applicantEmail ?? 'Not provided',
              ),
              const SizedBox(height: AppSpacing.sm),
              _ContactRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: submission.applicantPhone ?? 'Not provided',
              ),
              const SizedBox(height: AppSpacing.sm),
              _ContactRow(
                icon: Icons.schedule_rounded,
                label: 'Submitted',
                value: formattedDate,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // --- Responses Section ---
        AppSectionCard(
          title: 'Responses',
          icon: Icons.question_answer_outlined,
          children: [
            if (submission.customFieldResponses == null ||
                submission.customFieldResponses!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'No additional responses.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            if (submission.customFieldResponses != null &&
                submission.customFieldResponses!.isNotEmpty)
              ...submission.customFieldResponses!.entries
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final item = entry.value;
                final isLast =
                    entry.key ==
                    submission.customFieldResponses!.length - 1;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : AppSpacing.sm,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
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
                          item.key,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          item.value?.toString() ?? '-',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            if (submission.notes != null && submission.notes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
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
                      'Applicant Notes',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      submission.notes!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // --- Decision Notes (if already decided) ---
        if (submission.decisionNotes != null &&
            submission.decisionNotes!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: AppSectionCard(
              title: 'Decision Notes',
              icon: Icons.note_alt_outlined,
              children: [
                Text(
                  submission.decisionNotes!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),

        // --- Decision Buttons ---
        AppSectionCard(
          title: 'Decision',
          icon: Icons.gavel_outlined,
          children: [
            Text(
              'Review the application and make a decision.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: isProcessing ? null : onApprove,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Approve'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.md,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : onReject,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(
                          color: AppColors.danger,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.md,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
