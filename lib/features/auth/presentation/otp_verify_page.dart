import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OtpVerifyPage extends ConsumerStatefulWidget {
  const OtpVerifyPage({
    super.key,
    required this.phone,
    this.isSignupFlow = false,
  });

  final String phone;
  final bool isSignupFlow;

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

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
                stepIndex: 2,
              ),
              const SizedBox(height: 20),
              Text('Verify phone', style: authTitleStyle(context)),
              const SizedBox(height: 8),
              Text(
                'Enter the code sent to ${widget.phone}.',
                style: authSubtitleStyle(context),
              ),
              const SizedBox(height: 32),
              const AuthSectionLabel(text: 'OTP CODE'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: authInputDecoration(
                  context,
                  hintText: '000000',
                ),
                style: authInputTextStyle(context)?.copyWith(letterSpacing: 4),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.length < 4) return 'Enter the OTP.';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isBusy
                      ? null
                      : () async {
                          final router = GoRouter.of(context);
                          if (_formKey.currentState?.validate() ?? false) {
                            if (widget.isSignupFlow) {
                              final success =
                                  await ref
                                      .read(
                                        authControllerProvider.notifier,
                                      )
                                      .verifyOtpForSignup(
                                        phone: widget.phone,
                                        otp: _otpController.text.trim(),
                                      );
                              if (!mounted || !success) return;
                              final encoded =
                                  Uri.encodeComponent(widget.phone);
                              router.go('/login?phone=$encoded');
                              return;
                            }
                            await ref
                                .read(authControllerProvider.notifier)
                                .verifyOtp(
                                  phone: widget.phone,
                                  otp: _otpController.text.trim(),
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
                          'Verify',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: state.isBusy
                      ? null
                      : () {
                          ref
                              .read(authControllerProvider.notifier)
                              .requestOtp(widget.phone);
                        },
                  style: TextButton.styleFrom(foregroundColor: authAccent),
                  child: const Text('Resend OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
