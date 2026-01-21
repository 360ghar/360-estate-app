import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key, this.phone});

  final String? phone;

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _prefilled = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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
              Text('Create account', style: authTitleStyle(context)),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Create your account with a phone number and password.',
                style: authSubtitleStyle(context),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const AuthSectionLabel(text: 'FULL NAME (OPTIONAL)'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                decoration: authInputDecoration(
                  context,
                  hintText: 'Your full name',
                ),
                style: authInputTextStyle(context),
              ),
              const SizedBox(height: AppSpacing.lg),
              const AuthSectionLabel(text: 'EMAIL (OPTIONAL)'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: authInputDecoration(
                  context,
                  hintText: 'you@example.com',
                ),
                style: authInputTextStyle(context),
              ),
              const SizedBox(height: AppSpacing.lg),
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
                textInputAction: TextInputAction.next,
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
                  if (text.length < 6) {
                    return 'Password must be 6+ characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const AuthSectionLabel(text: 'CONFIRM PASSWORD'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
                decoration: authInputDecoration(
                  context,
                  hintText: '******',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: authMuted,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),
                style: authInputTextStyle(context),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Confirm your password.';
                  if (text != _passwordController.text.trim()) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isBusy
                      ? null
                      : () async {
                          final router = GoRouter.of(context);
                          if (_formKey.currentState?.validate() ?? false) {
                            final phone = lockPhone
                                ? normalizedParam!
                                : normalizePhone(_phoneController.text);
                            final success =
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .signUpWithPassword(
                                      phone: phone,
                                      password:
                                          _passwordController.text.trim(),
                                      fullName:
                                          _fullNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                    );
                            if (!mounted || !success) return;
                            final encoded = Uri.encodeComponent(phone);
                            router.go('/otp?phone=$encoded&flow=signup');
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
                          'Create account',
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
                  Text(
                    'Already have an account?',
                    style: authFootnoteStyle(context),
                  ),
                  TextButton(
                    onPressed: state.isBusy
                        ? null
                        : () {
                            final encoded = normalizedParam == null
                                ? null
                                : Uri.encodeComponent(normalizedParam);
                            final target = (lockPhone && encoded != null)
                                ? '/login?phone=$encoded'
                                : '/login';
                            context.go(target);
                          },
                    style: TextButton.styleFrom(foregroundColor: authAccent),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
