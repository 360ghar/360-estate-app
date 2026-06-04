import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Change password page with validation and strength indicator
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
  void initState() {
    super.initState();
    _newPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Calculate password strength (0.0 to 1.0)
  double get _passwordStrength {
    final password = _newPasswordController.text;
    if (password.isEmpty) return 0.0;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;
    if (password.length >= 12) score++;

    return (score / 6).clamp(0.0, 1.0);
  }

  Color get _strengthColor {
    final strength = _passwordStrength;
    if (strength <= 0.33) return AppColors.danger;
    if (strength <= 0.66) return AppColors.warning;
    return AppColors.success;
  }

  String get _strengthLabel {
    final strength = _passwordStrength;
    if (strength == 0) return '';
    if (strength <= 0.33) return 'Weak';
    if (strength <= 0.66) return 'Fair';
    return 'Strong';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final password = _newPasswordController.text;

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
            // Info banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
                borderRadius: AppRadii.md,
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      context.l10n?.passwordChangeInfo ??
                          'Enter your current password and a new password to update your credentials.',
                      style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Current password section
            AppSectionCard(
              title: 'Current Password',
              icon: Icons.lock_outline,
              iconColor: const Color(0xFF3B82F6),
              children: [
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
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // New password section with strength indicator
            AppSectionCard(
              title: 'New Password',
              icon: Icons.vpn_key_outlined,
              iconColor: const Color(0xFF8B5CF6),
              children: [
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

                // Password strength indicator bar
                if (password.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: AppRadii.pill,
                          child: Stack(
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurfaceSecondary
                                      : AppColors.surfaceSecondary,
                                  borderRadius: AppRadii.pill,
                                ),
                              ),
                              AnimatedContainer(
                                duration: AppDurations.medium,
                                curve: AppDurations.defaultCurve,
                                height: 4,
                                width: MediaQuery.of(context).size.width * _passwordStrength * 0.6,
                                decoration: BoxDecoration(
                                  color: _strengthColor,
                                  borderRadius: AppRadii.pill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _strengthLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _strengthColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

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

                const SizedBox(height: AppSpacing.lg),

                // Password requirements checklist
                Text(
                  context.l10n?.passwordRequirements ?? 'Password Requirements:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _PasswordRequirement(
                  label: context.l10n?.requirementMinLength ?? 'At least 8 characters',
                  met: password.length >= 8,
                ),
                _PasswordRequirement(
                  label: context.l10n?.requirementUppercase ?? 'At least one uppercase letter',
                  met: password.contains(RegExp(r'[A-Z]')),
                ),
                _PasswordRequirement(
                  label: context.l10n?.requirementLowercase ?? 'At least one lowercase letter',
                  met: password.contains(RegExp(r'[a-z]')),
                ),
                _PasswordRequirement(
                  label: context.l10n?.requirementNumber ?? 'At least one number',
                  met: password.contains(RegExp(r'[0-9]')),
                ),
              ],
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppDurations.defaultCurve,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: met
                  ? AppColors.success.withValues(alpha: 0.08)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              met ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: met ? AppColors.success : AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: met ? AppColors.success : AppColors.textTertiary,
                  fontWeight: met ? FontWeight.w500 : FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
