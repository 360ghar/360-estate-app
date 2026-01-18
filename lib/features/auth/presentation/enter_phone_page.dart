import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/utils/phone_utils.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EnterPhonePage extends ConsumerStatefulWidget {
  const EnterPhonePage({super.key});

  @override
  ConsumerState<EnterPhonePage> createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends ConsumerState<EnterPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (!isValidPhone(value ?? '')) return 'Enter a valid phone number.';
    return null;
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizePhone(_phoneController.text);

    setState(() => _isChecking = true);
    try {
      final exists =
          await ref
              .read(authControllerProvider.notifier)
              .checkPhoneRegistered(phone)
              .timeout(const Duration(seconds: 6), onTimeout: () => null);
      if (!mounted) return;

      final encoded = Uri.encodeComponent(phone);
      if (exists == false) {
        context.go('/signup?phone=$encoded');
        return;
      }
      context.go('/login?phone=$encoded');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    if (!config.isSupabaseConfigured) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Enter phone')),
        body: const AppErrorView(
          title: 'Missing Supabase configuration',
          message: 'Add SUPABASE_URL and SUPABASE_ANON_KEY to your .env file.',
        ),
      );
    }

    return AppScaffold(
      padding: EdgeInsets.zero,
      body: AuthPageLayout(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTopBar(
                onBack: () => Navigator.of(context).maybePop(),
                stepIndex: 0,
              ),
              const SizedBox(height: 20),
              Text('Enter phone', style: authTitleStyle(context)),
              const SizedBox(height: 8),
              Text(
                'We will check if your account exists or create a new one.',
                style: authSubtitleStyle(context),
              ),
              const SizedBox(height: 32),
              const AuthSectionLabel(text: 'MOBILE NUMBER'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _continue(),
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
                validator: _validatePhone,
              ),
              const SizedBox(height: 6),
              Text('OTP will be sent to this number',
                  style: authFootnoteStyle(context)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isChecking ? null : _continue,
                  style: authPrimaryButtonStyle(),
                  child: _isChecking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: authFootnoteStyle(context),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: authLinkStyle(context),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: authLinkStyle(context),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
