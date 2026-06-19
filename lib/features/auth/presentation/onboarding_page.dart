import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Placeholder onboarding page for the estate app.
///
/// The estate app uses minimal onboarding — profile completion is the only
/// mandatory gate. This page marks onboarding as complete (persisted to the
/// backend so the gate advances past app_onboarding on the next launch) and
/// redirects to home. Replace with a real onboarding flow if needed.
class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  Future<void> _completeAndContinue(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(authRepositoryProvider).completeOnboarding(app: 'estate');
    } catch (_) {
      // Non-critical; ignore.
    }
    if (context.mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              'Welcome to Estate App',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all set!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => _completeAndContinue(ref, context),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
