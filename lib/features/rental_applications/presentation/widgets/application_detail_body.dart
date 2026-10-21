import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';
import 'package:estate_app/features/rental_applications/presentation/application_field_type_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Who applied and how to reach them, what they answered, and the decision
/// (or the buttons to make it).
class ApplicationDetailBody extends ConsumerWidget {
  const ApplicationDetailBody({
    super.key,
    required this.submission,
    required this.deciding,
    required this.onApprove,
    required this.onReject,
  });

  final ApplicationSubmission submission;
  final bool deciding;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final status = submission.status;
    final name = submission.applicantFullName ?? l10n.applicationsApplicant;
    final submitted = submission.submittedAt;
    // The answers are keyed by the form field id; the form gives the labels.
    final formId = submission.formId;
    final form = formId == null
        ? null
        : ref.watch(applicationFormDetailProvider(formId)).valueOrNull;
    final labels = {
      for (final field in form?.fields ?? const <ApplicationFormField>[])
        field.key: field.label ?? field.key,
    };
    final answers = (submission.answers ?? const <String, dynamic>{}).entries
        .toList();
    final note = submission.notes;
    final decisionNotes = submission.decisionNotes?.trim() ?? '';
    final decidedAt = submission.decisionAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppAvatar(name: name, size: AppAvatarSize.lg),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: context.text.headlineSmall),
                  Text(
                    [
                      ?submission.propertyName,
                      if (submitted != null)
                        l10n.applicationsSubmittedOn(
                          shortDate(context, submitted),
                        ),
                    ].join('  ·  '),
                    style: muted,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppStatusBadge(
            label: status?.text(l10n) ?? l10n.applicationsStatusUnknown,
            type: status?.statusType ?? AppStatusType.neutral,
            variant: AppStatusVariant.filled,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              _ContactTile(
                icon: Icons.call_outlined,
                label: l10n.applicationDetailPhone,
                value: submission.applicantPhone,
                action: l10n.applicationDetailCall,
                scheme: 'tel',
              ),
              _ContactTile(
                icon: Icons.mail_outline_rounded,
                label: l10n.applicationDetailEmail,
                value: submission.applicantEmail,
                action: l10n.applicationDetailWrite,
                scheme: 'mailto',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppSectionCard(
          title: l10n.applicationDetailAnswers,
          children: [
            if (answers.isEmpty)
              Text(l10n.applicationDetailNoAnswers, style: muted),
            for (final (index, answer) in answers.indexed) ...[
              if (index > 0) const SizedBox(height: AppSpacing.md),
              Text(
                labels[answer.key] ?? answer.key,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                applicationAnswerText(l10n, answer.value),
                style: context.text.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppSectionCard(
            title: l10n.applicationDetailApplicantNote,
            children: [Text(note, style: context.text.bodyLarge)],
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (status == RentalApplicationStatus.applicant)
          AppSectionCard(
            title: l10n.applicationDetailYourDecision,
            children: [
              Text(l10n.applicationDetailDecisionHelp, style: muted),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: deciding ? null : onApprove,
                icon: deciding
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(l10n.applicationDetailApprove),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.error,
                ),
                onPressed: deciding ? null : onReject,
                icon: const Icon(Icons.close_rounded),
                label: Text(l10n.applicationDetailReject),
              ),
            ],
          )
        else if (decisionNotes.isNotEmpty || decidedAt != null)
          AppSectionCard(
            title: l10n.applicationDetailDecision,
            children: [
              if (decidedAt != null)
                Text(
                  l10n.applicationDetailDecidedOn(
                    shortDate(context, decidedAt),
                  ),
                  style: muted,
                ),
              if (decisionNotes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(decisionNotes, style: context.text.bodyLarge),
              ],
            ],
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// A phone number or email that opens the dialler or the mail app.
class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.action,
    required this.scheme,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String action;
  final String scheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final v = value?.trim() ?? '';
    return ListTile(
      leading: Icon(icon),
      title: v.isEmpty
          ? Text(
              l10n.applicationDetailNotGiven,
              style: TextStyle(color: context.colors.onSurfaceVariant),
            )
          : Text(v),
      subtitle: Text(label),
      trailing: v.isEmpty
          ? null
          : Icon(Icons.chevron_right_rounded, semanticLabel: action),
      onTap: v.isEmpty ? null : () => launchUrl(Uri(scheme: scheme, path: v)),
    );
  }
}
