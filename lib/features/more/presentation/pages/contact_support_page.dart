import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/feedback/data/feedback_repository.dart';
import 'package:estate_app/features/feedback/feedback_providers.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A message to support: a topic, who you are, and what happened.
class ContactSupportPage extends ConsumerStatefulWidget {
  const ContactSupportPage({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  ConsumerState<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends ConsumerState<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'general';
  bool _isSubmitting = false;

  static const _categories = ['general', 'technical', 'billing', 'feature'];

  @override
  void initState() {
    super.initState();
    // 'report' is the older name of 'technical'.
    final initial = widget.initialCategory == 'report'
        ? 'technical'
        : widget.initialCategory;
    if (_categories.contains(initial)) _selectedCategory = initial!;
    final user = ref.read(authControllerProvider).user;
    _nameController.text = user?.fullName ?? '';
    _emailController.text = user?.email ?? '';
  }

  static String _categoryLabel(AppLocalizations l10n, String value) =>
      switch (value) {
        'technical' => l10n.contactCatTechnical,
        'billing' => l10n.contactCatBilling,
        'feature' => l10n.contactCatFeature,
        _ => l10n.contactCatGeneral,
      };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Maps the selected support category to the backend `bug_type` value.
  BugType _bugTypeForCategory(String category) {
    switch (category) {
      case 'feature':
        return BugType.featureRequest;
      case 'technical':
      case 'report':
        return BugType.functionalityBug;
      case 'general':
      case 'billing':
      default:
        return BugType.other;
    }
  }

  Future<void> _submitSupport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    // The backend identifies the user via the Supabase JWT, so fold the
    // submitted name/email into the description for context.
    final description = StringBuffer()
      ..writeln(message)
      ..writeln()
      ..write('From: $name <$email>');

    final payload = BugReportPayload(
      bugType: _bugTypeForCategory(_selectedCategory),
      title: subject,
      description: description.toString(),
      tags: const ['estate'],
    );

    try {
      await ref.read(feedbackRepositoryProvider).submitBugReport(payload);
      if (!mounted) return;
      context.showSnack(context.l10n.contactSent);
      context.pop();
    } on Failure catch (failure) {
      if (!mounted) return;
      context.showSnack(failure.localizedMessage(context.l10n));
    } catch (_) {
      if (!mounted) return;
      context.showSnack(context.l10n.errorSomethingWentWrong);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreContact)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Text(l10n.howCanWeHelp, style: context.text.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.supportResponseTime,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppSectionCard(
              title: l10n.contactTopic,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    for (final value in _categories)
                      ChoiceChip(
                        label: Text(_categoryLabel(l10n, value)),
                        selected: _selectedCategory == value,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = value),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppSectionCard(
              title: l10n.profileDetailsTitle,
              children: [
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.contactName),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.validationNameRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.profileEmail),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return l10n.validationEmailRequired;
                    return value.contains('@')
                        ? null
                        : l10n.validationEmailInvalid;
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppSectionCard(
              title: l10n.contactMessageTitle,
              children: [
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: l10n.contactSubject),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.validationSubjectRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: l10n.message,
                    helperText: l10n.contactMessageHelper,
                    alignLabelWithHint: true,
                  ),
                  minLines: 4,
                  maxLines: 8,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return l10n.validationMessageRequired;
                    return value.length < 10
                        ? l10n.validationMessageTooShort
                        : null;
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submitSupport,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(l10n.contactSend),
            ),
            const SizedBox(height: AppSpacing.lg),
            SelectableText(
              l10n.contactEmailDirect(kSupportEmail),
              textAlign: TextAlign.center,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The support inbox (the same address the account deletion email goes to).
const kSupportEmail = 'info@360ghar.com';
