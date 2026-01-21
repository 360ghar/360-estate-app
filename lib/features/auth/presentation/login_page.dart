import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.phone});

  final String? phone;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _prefilled = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final phoneParam = widget.phone?.trim();
    final normalizedParam =
        phoneParam == null ? null : normalizePhone(phoneParam);
    final lockPhone = normalizedParam != null && normalizedParam.isNotEmpty;

    if (lockPhone && !_prefilled) {
      _phoneController.text = normalizedParam!;
      _prefilled = true;
    }

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.errorMessage != next.errorMessage &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return AppScaffold(
      padding: EdgeInsets.zero,
      body: AuthPageLayout(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTopBar(
                onBack: () => context.go('/enter-phone'),
                stepIndex: 1,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Sign in', style: authTitleStyle(context)),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Use your phone number and password to sign in.',
                style: authSubtitleStyle(context),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const AuthSectionLabel(text: 'MOBILE NUMBER'),
              const SizedBox(height: AppSpacing.sm),
              if (lockPhone)
                AuthPillContainer(
                  child: Row(
                    children: [
                      Text(
                        normalizedParam!,
                        style: authInputTextStyle(context)?.copyWith(
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: state.isBusy
                            ? null
                            : () => context.go('/enter-phone'),
                        style: TextButton.styleFrom(
                          foregroundColor: authAccent,
                        ),
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                )
              else
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    const AuthPhoneNumberFormatter(),
                  ],
                  decoration: authInputDecoration(
                    context,
                    hintText: '00000 00000',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16, right: 12),
                      child: AuthCountryPrefix(),
                    ),
                  ),
                  style: authInputTextStyle(context)?.copyWith(
                    letterSpacing: 1.5,
                  ),
                  validator: (value) {
                    if (!isValidPhone(value ?? '')) {
                      return 'Enter a valid phone number.';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
              const AuthSectionLabel(text: 'PASSWORD'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: authInputDecoration(
                  context,
                  hintText: '******',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: authMuted,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                style: authInputTextStyle(context),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.length < 6) return 'Enter a valid password.';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: state.isBusy
                      ? null
                      : () async {
                          final prefill = _prefillPhone(
                            lockPhone ? normalizedParam : _phoneController.text,
                          );
                          final phone = await _promptForgotPasswordPhone(
                            prefill: prefill,
                          );
                          if (phone == null || phone.isEmpty) return;
                          await ref
                              .read(authControllerProvider.notifier)
                              .requestOtp(phone);
                          if (!mounted) return;
                          if (ref.read(authControllerProvider).errorMessage !=
                              null) {
                            return;
                          }
                          final encoded = Uri.encodeComponent(phone);
                          context.go('/otp?phone=$encoded');
                        },
                  style: TextButton.styleFrom(foregroundColor: authAccent),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isBusy
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref
                                .read(authControllerProvider.notifier)
                                .signInWithPassword(
                                  phone: lockPhone
                                      ? normalizedParam!
                                      : normalizePhone(_phoneController.text),
                                  password: _passwordController.text.trim(),
                                );
                          }
                        },
                  style: authPrimaryButtonStyle(),
                  child: state.isBusy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New here?', style: authFootnoteStyle(context)),
                  TextButton(
                    onPressed: state.isBusy
                        ? null
                        : () {
                            final encoded = normalizedParam == null
                                ? null
                                : Uri.encodeComponent(normalizedParam);
                            final target = (lockPhone && encoded != null)
                                ? '/signup?phone=$encoded'
                                : '/signup';
                            context.go(target);
                          },
                    style: TextButton.styleFrom(foregroundColor: authAccent),
                    child: const Text('Create account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _prefillPhone(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 10) {
      return digits.substring(digits.length - 10);
    }
    return digits;
  }

  Future<String?> _promptForgotPasswordPhone({String? prefill}) async {
    final controller = TextEditingController(text: prefill ?? '');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset password'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
                const AuthPhoneNumberFormatter(),
              ],
              decoration: authInputDecoration(
                dialogContext,
                hintText: '00000 00000',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 12),
                  child: AuthCountryPrefix(),
                ),
              ),
              style: authInputTextStyle(dialogContext)?.copyWith(
                letterSpacing: 1.5,
              ),
              validator: (value) {
                if (!isValidPhone(value ?? '')) {
                  return 'Enter a valid phone number.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                final normalized = normalizePhone(controller.text);
                Navigator.pop(dialogContext, normalized);
              },
              child: const Text('Send OTP'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }
}
