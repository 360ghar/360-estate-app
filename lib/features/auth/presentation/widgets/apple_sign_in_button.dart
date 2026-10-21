import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AppleSignInOutcome { success, error }

/// The official "Sign in with Apple" button, wired to the auth controller.
///
/// Rendered on iOS/macOS only (the parent gates on platform); it additionally
/// checks [SignInWithApple.isAvailable] and hides itself if unavailable (e.g.
/// iOS < 13). Apple's design guidelines require this official button, sized as
/// prominently as the Google button.
class AppleSignInButton extends ConsumerStatefulWidget {
  const AppleSignInButton({super.key, required this.enabled, this.onResult});

  final bool enabled;
  final ValueChanged<AppleSignInOutcome>? onResult;

  @override
  ConsumerState<AppleSignInButton> createState() => _AppleSignInButtonState();
}

class _AppleSignInButtonState extends ConsumerState<AppleSignInButton> {
  late final Future<bool> _availableFuture;

  @override
  void initState() {
    super.initState();
    final service = ref.read(appleSignInServiceProvider);
    _availableFuture = service?.isAvailable() ?? Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = ref.watch(authControllerProvider.select((s) => s.isBusy));

    return FutureBuilder<bool>(
      future: _availableFuture,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        final canPress = widget.enabled && !isBusy;
        return Opacity(
          opacity: canPress ? 1.0 : 0.6,
          child: AbsorbPointer(
            absorbing: !canPress,
            child: SignInWithAppleButton(
              text: context.l10n.authContinueWithApple,
              height: 48,
              borderRadius: AppRadii.md,
              // Apple's black button on light screens, white on dark ones.
              style: Theme.of(context).brightness == Brightness.dark
                  ? SignInWithAppleButtonStyle.white
                  : SignInWithAppleButtonStyle.black,
              onPressed: () => _signIn(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _signIn() async {
    await ref.read(authControllerProvider.notifier).signInWithApple();
    final error = ref.read(authControllerProvider).errorMessage;
    widget.onResult?.call(
      error == null ? AppleSignInOutcome.success : AppleSignInOutcome.error,
    );
  }
}
