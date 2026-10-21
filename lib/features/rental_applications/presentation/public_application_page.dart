import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/presentation/widgets/answer_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The form a prospective tenant fills in from a shared link, signed out.
/// Short, welcoming, and it says what happens after.
class PublicApplicationPage extends ConsumerStatefulWidget {
  const PublicApplicationPage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<PublicApplicationPage> createState() =>
      _PublicApplicationPageState();
}

class _PublicApplicationPageState extends ConsumerState<PublicApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _notes = TextEditingController();
  final Map<String, TextEditingController> _text = {};
  final Map<String, Object?> _values = {};
  bool _submitting = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _notes, ..._text.values]) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(ApplicationFormField field) =>
      _text.putIfAbsent(field.key, TextEditingController.new);

  /// The answers, keyed by field id. A question left empty is not sent; a
  /// yes/no question is always sent.
  Map<String, dynamic> _answers(List<ApplicationFormField> fields) => {
    for (final field in fields)
      ...switch (field.fieldType) {
        ApplicationFieldType.boolean => {
          field.key: _values[field.key] as bool? ?? false,
        },
        // A select without options is shown as a text field: use its text.
        ApplicationFieldType.select => {
          if ((_values[field.key] is String &&
                      (_values[field.key]! as String).isNotEmpty
                  ? _values[field.key]! as String
                  : _controllerFor(field).text.trim())
              case final String v when v.isNotEmpty)
            field.key: v,
        },
        ApplicationFieldType.date => {
          if (_values[field.key] case final DateTime d)
            field.key: DateFormat('yyyy-MM-dd').format(d),
        },
        ApplicationFieldType.number => {
          if (num.tryParse(_controllerFor(field).text.trim()) case final num n)
            field.key: n,
        },
        _ => {
          if (_controllerFor(field).text.trim() case final String t
              when t.isNotEmpty)
            field.key: t,
        },
      },
  };

  Future<void> _submit(ApplicationForm form) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(applicationsRepositoryProvider)
          .submitPublicForm(
            widget.slug,
            PublicApplicationSubmitRequest(
              applicantFullName: _name.text,
              applicantEmail: _email.text,
              applicantPhone: _phone.text,
              answers: _answers(form.fields ?? const []),
              notes: _notes.text,
            ),
          );
      TextInput.finishAutofillContext();
      if (mounted) context.go(Routes.publicApplicationSuccess(widget.slug));
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appBar = AppBar(title: Text(l10n.publicApplyTitle));
    if (!ref.watch(appConfigProvider).featureFlags.enablePublicApplications) {
      return Scaffold(
        appBar: appBar,
        body: AppEmptyView(
          title: l10n.publicApplyClosedTitle,
          message: l10n.publicApplyClosedBody,
          icon: Icons.lock_clock_outlined,
        ),
      );
    }
    final form = ref.watch(publicApplicationFormProvider(widget.slug));
    return Scaffold(
      appBar: appBar,
      body: form.when(
        loading: () => const AppLoadingShimmer(itemCount: 3, itemHeight: 160),
        error: (error, _) => AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: userFacingMessage(error),
          onRetry: () =>
              ref.invalidate(publicApplicationFormProvider(widget.slug)),
        ),
        data: (data) => _buildForm(data),
      ),
    );
  }

  Widget _buildForm(ApplicationForm form) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final fields = form.fields ?? const <ApplicationFormField>[];
    final address = form.propertyAddress?.trim() ?? '';
    final description = form.description?.trim() ?? '';
    final fee = form.applicationFeeAmount;
    final name = form.propertyName?.trim() ?? '';
    final facts = [
      if (name.isNotEmpty) name,
      if (address.isNotEmpty) address,
      if (fee != null && fee > 0) l10n.publicApplyFee(rupees(fee)),
    ];

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            form.title ?? l10n.applicationFormDefaultTitle,
            style: context.text.headlineMedium,
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(description, style: context.text.bodyLarge),
          ],
          if (facts.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(facts.join('  ·  '), style: muted),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(l10n.publicApplyIntro, style: muted),
          const SizedBox(height: AppSpacing.lg),
          AutofillGroup(
            child: AppSectionCard(
              title: l10n.publicApplyAboutYou,
              children: [
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(labelText: l10n.publicApplyName),
                  validator: (v) => (v ?? '').trim().isEmpty
                      ? l10n.publicApplyNameRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: InputDecoration(labelText: l10n.publicApplyPhone),
                  validator: (v) {
                    final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                    if (digits.isEmpty) return l10n.publicApplyPhoneRequired;
                    return digits.length < 10
                        ? l10n.publicApplyPhoneInvalid
                        : null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.publicApplyEmail),
                  validator: (v) {
                    final email = (v ?? '').trim();
                    if (email.isEmpty) return l10n.publicApplyEmailRequired;
                    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
                        ? null
                        : l10n.publicApplyEmailInvalid;
                  },
                ),
              ],
            ),
          ),
          if (fields.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            AppSectionCard(
              title: l10n.publicApplyQuestions,
              children: [
                // A yes/no question always has an answer, so it shows no *.
                if (fields.any(
                  (f) =>
                      f.isRequired == true &&
                      f.fieldType != ApplicationFieldType.boolean,
                )) ...[
                  Text(l10n.publicApplyRequiredNote, style: muted),
                  const SizedBox(height: AppSpacing.md),
                ],
                for (final (index, field) in fields.indexed) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.lg),
                  AnswerField(
                    field: field,
                    controller: _controllerFor(field),
                    value: _values[field.key],
                    onChanged: (v) => setState(() => _values[field.key] = v),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppSectionCard(
            children: [
              TextFormField(
                controller: _notes,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.publicApplyNotes,
                  helperText: l10n.publicApplyNotesHelp,
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _submitting ? null : () => _submit(form),
            icon: _submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(l10n.publicApplySubmit),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
