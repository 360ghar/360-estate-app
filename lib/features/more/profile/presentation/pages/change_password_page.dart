import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Change password page with validation
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscureCurrent = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(authControllerProvider.notifier).changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n?.passwordChanged ?? 'Password changed successfully'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final message = ref.read(authControllerProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message ??
                  context.l10n?.passwordChangeFailed ??
                  'Failed to change password',
            ),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.changePassword ?? 'Change Password'),
      ),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info text
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      context.l10n?.passwordChangeInfo ??
                          'Enter your current password and a new password to update your credentials.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Current password field
            TextFormField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: context.l10n?.currentPassword ?? 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureCurrent ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureCurrent = !_isObscureCurrent;
                    });
                  },
                ),
              ),
              obscureText: _isObscureCurrent,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n?.validationCurrentPasswordRequired ??
                      'Current password is required';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            // New password field
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: context.l10n?.newPassword ?? 'New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureNew ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureNew = !_isObscureNew;
                    });
                  },
                ),
              ),
              obscureText: _isObscureNew,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n?.validationNewPasswordRequired ??
                      'New password is required';
                }
                if (value.length < 8) {
                  return context.l10n?.validationPasswordTooShort ??
                      'Password must be at least 8 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            // Confirm password field
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: context.l10n?.confirmNewPassword ?? 'Confirm New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureConfirm = !_isObscureConfirm;
                    });
                  },
                ),
              ),
              obscureText: _isObscureConfirm,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n?.validationConfirmPasswordRequired ??
                      'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return context.l10n?.validationPasswordsDoNotMatch ??
                      'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Password requirements
            Text(
              context.l10n?.passwordRequirements ?? 'Password Requirements:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            _PasswordRequirement(
              label: context.l10n?.requirementMinLength ?? 'At least 8 characters',
              met: _newPasswordController.text.length >= 8,
            ),
            _PasswordRequirement(
              label: context.l10n?.requirementUppercase ?? 'At least one uppercase letter',
              met: _newPasswordController.text.contains(RegExp(r'[A-Z]')),
            ),
            _PasswordRequirement(
              label: context.l10n?.requirementLowercase ?? 'At least one lowercase letter',
              met: _newPasswordController.text.contains(RegExp(r'[a-z]')),
            ),
            _PasswordRequirement(
              label: context.l10n?.requirementNumber ?? 'At least one number',
              met: _newPasswordController.text.contains(RegExp(r'[0-9]')),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _changePassword,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n?.changePassword ?? 'Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordRequirement extends StatelessWidget {
  const _PasswordRequirement({
    required this.label,
    required this.met,
  });

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: met ? AppColors.success : AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: met ? AppColors.success : AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }
}
