import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GoogleSignInOutcome { success, error }

/// A reusable "Continue with Google" button wired to the auth controller.
///
/// Always visible: Google is enabled in Supabase. The controller picks the
/// native ID-token flow when `GOOGLE_WEB_CLIENT_ID` is configured, otherwise
/// the Supabase OAuth redirect flow (which needs no client id). With the
/// redirect flow the session arrives asynchronously, so a success result here
/// only means the redirect launched; routing is driven by the auth controller.
class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key, required this.enabled, this.onResult});

  final bool enabled;
  final ValueChanged<GoogleSignInOutcome>? onResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(authControllerProvider.select((s) => s.isBusy));
    final canPress = enabled && !isBusy;

    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: canPress ? () => _signIn(ref) : null,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _GoogleGlyph(),
              const SizedBox(width: 12),
              Text(
                'Continue with Google',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn(WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    final error = ref.read(authControllerProvider).errorMessage;
    onResult?.call(
      error == null ? GoogleSignInOutcome.success : GoogleSignInOutcome.error,
    );
  }
}

/// Minimal multi-color Google "G" rendered without an asset dependency.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontSize: 15,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
      ),
    );
  }
}
