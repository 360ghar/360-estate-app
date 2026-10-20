import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/presentation/widgets/question_editor.dart';
import 'package:estate_app/features/rental_applications/presentation/widgets/question_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A new application form: which property, what it is called, until when it
/// takes applications, and the extra questions it asks.
class ApplicationFormCreatePage extends ConsumerStatefulWidget {
  const ApplicationFormCreatePage({super.key});

  @override
  ConsumerState<ApplicationFormCreatePage> createState() =>
      _ApplicationFormCreatePageState();
}

class _ApplicationFormCreatePageState
    extends ConsumerState<ApplicationFormCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();

  int? _propertyId;
  DateTime? _closesOn;
  bool _active = true;
  bool _saving = false;
  final List<ApplicationFormField> _fields = [];
  // Only grows, so a removed question never gives its id to a later one.
  int _fieldCounter = 0;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void _addField(ApplicationFormField field) => setState(
    // The id is the key of the answer: unique and stable for this form.
    () => _fields.add(field.copyWith(id: 'q${++_fieldCounter}')),
  );

  Future<void> _pickCloseDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _closesOn ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: DateTime(now.year + 3, 12, 31),
    );
    if (picked != null) setState(() => _closesOn = picked);
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(applicationsRepositoryProvider)
          .createForm(
            ApplicationFormCreateRequest(
              propertyId: _propertyId,
              title: _title.text,
              description: _description.text,
              isActive: _active,
              expiresAt: _closesOn,
              fields: List<ApplicationFormField>.from(_fields),
            ),
          );
      ref.invalidate(applicationFormsPagedProvider);
      if (!mounted) return;
      context.showSnack(l10n.applicationFormCreated);
      context.go(Routes.applications);
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final properties = ref.watch(propertiesListProvider);
    final closesOn = _closesOn;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.applicationFormCreateTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppSectionCard(
              title: l10n.applicationFormDetailsSection,
              children: [
                properties.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, _) =>
                      Text(userFacingMessage(error), style: muted),
                  data: (list) => DropdownButtonFormField<int>(
                    initialValue: list.any((p) => p.id == _propertyId)
                        ? _propertyId
                        : null,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.applicationFormProperty,
                    ),
                    items: [
                      for (final p in list)
                        if (p.id != null)
                          DropdownMenuItem<int>(
                            value: p.id,
                            child: Text(
                              p.displayName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                    ],
                    onChanged: (v) => setState(() => _propertyId = v),
                    validator: (v) =>
                        v == null ? l10n.applicationFormChooseProperty : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _title,
                  maxLength: 200,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.applicationFormTitleLabel,
                    hintText: l10n.applicationFormTitleHint,
                  ),
                  validator: (v) => (v ?? '').trim().isEmpty
                      ? l10n.applicationFormTitleRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _description,
                  minLines: 2,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.applicationFormDescription,
                    helperText: l10n.applicationFormDescriptionHelp,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                InkWell(
                  borderRadius: AppRadii.md,
                  onTap: _pickCloseDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.applicationFormCloses,
                      suffixIcon: closesOn == null
                          ? const Icon(Icons.calendar_today_outlined)
                          : IconButton(
                              tooltip: l10n.applicationFormClearDate,
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => setState(() => _closesOn = null),
                            ),
                    ),
                    child: Text(
                      closesOn == null
                          ? l10n.applicationsNoExpiry
                          : shortDate(context, closesOn),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.applicationFormAccepting),
                  subtitle: Text(l10n.applicationFormAcceptingHelp),
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppSectionCard(
              title: l10n.applicationFormQuestionsSection,
              children: [
                Text(l10n.applicationFormStandardQuestions, style: muted),
                const SizedBox(height: AppSpacing.md),
                for (final (index, field) in _fields.indexed)
                  QuestionRow(
                    field: field,
                    onRemove: () => setState(() => _fields.removeAt(index)),
                  ),
                if (_fields.isNotEmpty) const Divider(height: AppSpacing.xl),
                QuestionEditor(onAdd: _addField),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              label: Text(l10n.applicationFormCreate),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
