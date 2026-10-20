import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shown when the backend gate returns `stage: profile_completion`. Collects
/// the mandatory full name and date of birth, then moves on.
class ProfileCompletionPage extends ConsumerStatefulWidget {
  const ProfileCompletionPage({super.key});

  @override
  ConsumerState<ProfileCompletionPage> createState() =>
      _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends ConsumerState<ProfileCompletionPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: ref.read(authControllerProvider).user?.fullName ?? '',
  );
  final _dateController = TextEditingController();
  DateTime? _dateOfBirth;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: context.l10n.authDateOfBirth,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _dateOfBirth = picked;
      _dateController.text = shortDate(context, picked);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .updateProfile(
            UserProfileUpdate(
              fullName: _nameController.text.trim(),
              dateOfBirth: _dateOfBirth,
            ),
          );
      // The controller re-evaluates the gate after the update; the redirect
      // takes over from /home (onboarding or the app).
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        context.showSnack(
          userFacingMessage(e, fallback: context.l10n.authProfileSaveFailed),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScaffold(
      title: l10n.authProfileTitle,
      subtitle: Text(l10n.authProfileBody),
      card: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(
                labelText: l10n.authFullName,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator: (v) => (v?.trim().isEmpty ?? true)
                  ? l10n.authFullNameRequired
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                labelText: l10n.authDateOfBirth,
                hintText: l10n.authDateOfBirthHint,
                prefixIcon: const Icon(Icons.cake_outlined),
                suffixIcon: const Icon(Icons.calendar_month_outlined),
              ),
              validator: (_) =>
                  _dateOfBirth == null ? l10n.authDateOfBirthRequired : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            AuthPrimaryButton(
              label: l10n.commonContinue,
              busy: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
