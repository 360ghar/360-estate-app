import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(decision == 'approved' ? 'Approve' : 'Reject'),
        content: TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
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

  @override
  Widget build(BuildContext context) {
    final status = submission.status ?? 'pending';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          submission.applicantName ?? 'Applicant',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('${submission.propertyName ?? 'Property'} | $formattedDate'),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Contact'),
        const SizedBox(height: AppSpacing.md),
        _InfoRow(label: 'Email', value: submission.applicantEmail ?? 'Not set'),
        _InfoRow(label: 'Phone', value: submission.applicantPhone ?? 'Not set'),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Responses'),
        const SizedBox(height: AppSpacing.md),
        if (submission.customFieldResponses == null ||
            submission.customFieldResponses!.isEmpty)
          const Text('No additional responses.'),
        if (submission.customFieldResponses != null &&
            submission.customFieldResponses!.isNotEmpty)
          Column(
            children: submission.customFieldResponses!.entries
                .map(
                  (entry) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.key),
                    subtitle: Text(entry.value?.toString() ?? '-'),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Decision'),
        const SizedBox(height: AppSpacing.md),
        Text('Current status: $status'),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            FilledButton(
              onPressed: isProcessing ? null : onApprove,
              child: const Text('Approve'),
            ),
            OutlinedButton(
              onPressed: isProcessing ? null : onReject,
              child: const Text('Reject'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
