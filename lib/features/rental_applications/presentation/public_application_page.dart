import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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
        data: (form) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                form.title ?? 'Application form',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(form.description ?? 'Fill the form to apply.'),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Applicant details'),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your name.'
                        : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your email.'
                        : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your phone number.'
                        : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Additional info'),
              const SizedBox(height: AppSpacing.md),
              ..._buildFieldInputs(form.fields ?? const []),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : () => _submit(form),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit application'),
                ),
              ),
            ],
          ),
        ),
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

  List<Widget> _buildFieldInputs(List<ApplicationFormField> fields) {
    if (fields.isEmpty) {
      return [
        const Text('No extra fields required for this application.'),
      ];
    }

    return fields.map((field) {
      final key = _fieldKey(field);
      final type = field.fieldType ?? 'text';
      if (type == 'select' && (field.options?.isNotEmpty ?? false)) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: DropdownButtonFormField<String>(
            value: _selectValues[key],
            items: field.options!
                .map(
                  (option) =>
                      DropdownMenuItem(value: option, child: Text(option)),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectValues[key] = value),
            decoration: InputDecoration(labelText: field.label ?? 'Select'),
          ),
        );
      }

      if (type == 'checkbox') {
        final value = _checkboxValues[key] ?? false;
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(field.label ?? 'Checkbox'),
          value: value,
          onChanged: (updated) =>
              setState(() => _checkboxValues[key] = updated),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
