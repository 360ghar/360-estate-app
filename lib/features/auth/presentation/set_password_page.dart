import 'dart:ui';
import 'package:estate_app/core/presentation/animations/premium/premium_animations.dart';
import 'package:estate_app/core/presentation/widgets/glass/glass_toast.dart';
import 'package:estate_app/core/presentation/widgets/glass/premium_glass_card.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart'
    show isEmailIdentifier;
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/premium_auth_background.dart'
    show SimplePremiumBackground;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mandatory (non-skippable) set-password step shown after an OTP-verified
/// login for an account that has no password yet (requirement 6), or after a
/// forgot/reset OTP verify. The user must set a password before entering the
/// app. Backing out signs them out.
class SetPasswordPage extends ConsumerStatefulWidget {
  const SetPasswordPage({super.key});

  @override
  ConsumerState<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends ConsumerState<SetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .completeSetPassword(_passwordController.text.trim());
    if (!mounted) return;
    if (!ok) {
      final msg = ref.read(authControllerProvider).errorMessage;
      if (msg != null) GlassToast.showError(context, msg);
    }
    // On success the router redirect moves to /home (or /add-phone, etc.).
  }

  Future<void> _confirmCancel() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Set a password to continue',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'A password is required to finish signing in. Leaving will sign you '
          'out. Continue?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      await ref.read(authControllerProvider.notifier).cancelSetPassword();
    }
  }

  /// Masks the account identifier (email or phone) currently being set, for
  /// display so the user can see which account this password is for.
  String? _maskedIdentifier(AuthState state) {
    final user = state.user;
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty && isEmailIdentifier(email)) {
      final at = email.indexOf('@');
      final head = at > 0 ? email[0] : '';
      return '$head•••${email.substring(at)}';
    }
    final phone = (user?.phone ?? state.phone)?.trim();
    if (phone != null && phone.isNotEmpty) {
      final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length >= 4) {
        return '•••••• ${digits.substring(digits.length - 4)}';
      }
      return '••••';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final isReset = ref
        .read(authControllerProvider.notifier)
        .setPasswordIsReset;
    final masked = _maskedIdentifier(state);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmCancel();
      },
      child: SimplePremiumBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: PremiumFadeTransition(
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHeader(isReset: isReset, masked: masked),
                          const SizedBox(height: 32),
                          PremiumGlassCard(
                            padding: const EdgeInsets.all(28),
                            borderRadius: 24,
                            opacity: 0.15,
                            child: Column(
                              children: [
                                _PasswordField(
                                  label: 'PASSWORD',
                                  hint: 'Create a password',
                                  controller: _passwordController,
                                  obscure: _obscurePassword,
                                  onToggle: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  validator: (value) {
                                    final text = value?.trim() ?? '';
                                    if (text.length < 6) {
                                      return 'Password must be 6+ characters.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _PasswordField(
                                  label: 'CONFIRM PASSWORD',
                                  hint: 'Re-enter password',
                                  controller: _confirmController,
                                  obscure: _obscureConfirm,
                                  onToggle: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                  onSubmitted: (_) => _submit(),
                                  validator: (value) {
                                    final text = value?.trim() ?? '';
                                    if (text.isEmpty) {
                                      return 'Confirm your password.';
                                    }
                                    if (text !=
                                        _passwordController.text.trim()) {
                                      return 'Passwords do not match.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                PremiumGlassButton(
                                  label: isReset
                                      ? 'Reset password & continue'
                                      : 'Set password & continue',
                                  onPressed: state.isBusy ? null : _submit,
                                  isLoading: state.isBusy,
                                  icon: Icons.lock_outline_rounded,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: state.isBusy ? null : _confirmCancel,
                            child: Text(
                              'Use a different account',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required bool isReset, String? masked}) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.password_rounded,
            size: 34,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isReset ? 'Reset your password' : 'Set your password',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isReset
              ? 'Choose a new password for your account.'
              : 'Create a password so you can sign in faster next time.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        if (masked != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              masked,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B82F6),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.validator,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isFocused
                        ? const Color(0xFF3B82F6)
                        : Colors.white.withValues(alpha: 0.1),
                    width: _isFocused ? 1.5 : 1,
                  ),
                ),
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.obscure,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: widget.onSubmitted != null
                      ? TextInputAction.done
                      : TextInputAction.next,
                  onFieldSubmitted: widget.onSubmitted,
                  validator: widget.validator,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  cursorColor: const Color(0xFF3B82F6),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: widget.onToggle,
                      child: Icon(
                        widget.obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    errorStyle: const TextStyle(
                      color: Color(0xFFFCA5A5),
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
