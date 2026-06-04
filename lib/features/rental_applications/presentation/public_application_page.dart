import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PublicApplicationPage extends ConsumerStatefulWidget {
  const PublicApplicationPage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<PublicApplicationPage> createState() =>
      _PublicApplicationPageState();
}

class _PublicApplicationPageState
    extends ConsumerState<PublicApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  final Map<String, TextEditingController> _fieldControllers = {};
  final Map<String, String?> _selectValues = {};
  final Map<String, bool> _checkboxValues = {};

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _fieldKey(ApplicationFormField field) {
    return field.id?.toString() ?? (field.label ?? 'field');
  }

  TextEditingController _controllerFor(ApplicationFormField field) {
    final key = _fieldKey(field);
    return _fieldControllers.putIfAbsent(key, () => TextEditingController());
  }

  Future<void> _submit(ApplicationForm form) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final missing = _validateRequiredFields(form.fields ?? const []);
    if (missing != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill "$missing".')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final responses = <String, dynamic>{};
      for (final field in form.fields ?? const <ApplicationFormField>[]) {
        final key = _fieldKey(field);
        final type = field.fieldType ?? 'text';
        if (type == 'select') {
          responses[key] = _selectValues[key];
        } else if (type == 'checkbox') {
          responses[key] = _checkboxValues[key] ?? false;
        } else {
          responses[key] = _controllerFor(field).text.trim();
        }
      }

      final request = PublicApplicationSubmitRequest(
        applicantName: _nameController.text.trim(),
        applicantEmail: _emailController.text.trim(),
        applicantPhone: _phoneController.text.trim(),
        responses: responses,
        notes: _notesController.text.trim(),
      );
      await ref
          .read(applicationsRepositoryProvider)
          .submitPublicForm(widget.slug, request);
      if (mounted) {
        context.go('/public/applications/${widget.slug}/success');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _validateRequiredFields(List<ApplicationFormField> fields) {
    for (final field in fields) {
      if (field.isRequired != true) continue;
      final key = _fieldKey(field);
      final type = field.fieldType ?? 'text';
      if (type == 'checkbox') {
        if (_checkboxValues[key] != true) return field.label ?? 'field';
      } else if (type == 'select') {
        if ((_selectValues[key] ?? '').trim().isEmpty) {
          return field.label ?? 'field';
        }
      } else {
        if (_controllerFor(field).text.trim().isEmpty) {
          return field.label ?? 'field';
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final flags = ref.watch(appConfigProvider).featureFlags;
    if (!flags.enablePublicApplications) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Applications')),
        body: const AppEmptyView(
          title: 'Applications disabled',
          message: 'This form is currently unavailable.',
        ),
      );
    }

    final formAsync = ref.watch(publicApplicationFormProvider(widget.slug));

    return AppScaffold(
      appBar: AppBar(title: const Text('Rental application')),
      scrollable: true,
      body: formAsync.when(
        data: (form) => _buildForm(context, form),
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load form',
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(publicApplicationFormProvider(widget.slug)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ApplicationForm form) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Property Header ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
              borderRadius: AppRadii.lg,
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (form.propertyName != null &&
                    form.propertyName!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.apartment_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          form.propertyName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(
                  form.title ?? 'Application Form',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (form.description != null &&
                    form.description!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    form.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // --- Applicant Details ---
          AppSectionCard(
            title: 'Your Details',
            icon: Icons.person_outline_rounded,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your name.'
                        : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your email.'
                        : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your phone number.'
                        : null,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // --- Additional Info ---
          AppSectionCard(
            title: 'Additional Information',
            icon: Icons.assignment_outlined,
            children: [
              ..._buildFieldInputs(form.fields ?? const []),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // --- Submit Button ---
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : () => _submit(form),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                _isSubmitting ? 'Submitting...' : 'Submit Application',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  List<Widget> _buildFieldInputs(List<ApplicationFormField> fields) {
    if (fields.isEmpty) {
      return [
        Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'No extra fields required for this application.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ];
    }

    return fields.map((field) {
      final key = _fieldKey(field);
      final type = field.fieldType ?? 'text';
      if (type == 'select' && (field.options?.isNotEmpty ?? false)) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: DropdownButtonFormField<String>(
            initialValue: _selectValues[key],
            items: field.options!
                .map(
                  (option) =>
                      DropdownMenuItem(value: option, child: Text(option)),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectValues[key] = value),
            decoration: InputDecoration(
              labelText: field.label ?? 'Select',
              prefixIcon: const Icon(Icons.list_outlined),
            ),
          ),
        );
      }

      if (type == 'checkbox') {
        final value = _checkboxValues[key] ?? false;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceSecondary
                  : AppColors.surfaceSecondary,
              borderRadius: AppRadii.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    field.label ?? 'Checkbox',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: (updated) =>
                      setState(() => _checkboxValues[key] = updated),
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: TextFormField(
          controller: _controllerFor(field),
          keyboardType: type == 'number'
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(
            labelText: field.label ?? 'Field',
            hintText: type == 'date' ? 'YYYY-MM-DD' : null,
          ),
        ),
      );
    }).toList();
  }
}
