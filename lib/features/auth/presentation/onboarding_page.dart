import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The one welcome step after sign-up: what the app is for and the first
/// thing to do. Either action marks onboarding done on the backend (so the
/// gate moves past `app_onboarding`), then opens the app.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  bool _busy = false;

  Future<void> _finish(String location) async {
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).completeOnboarding();
    } catch (_) {
      // Not critical: the gate asks again on the next launch.
    }
    // The router still holds the user on /onboarding until the gate opens.
    ref.read(authControllerProvider.notifier).finishOnboarding();
    if (mounted) context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      (Icons.apartment_outlined, l10n.onboardingStepProperty),
      (Icons.people_outline_rounded, l10n.onboardingStepTenants),
      (Icons.payments_outlined, l10n.onboardingStepRent),
    ];
    return AuthScaffold(
      title: l10n.onboardingTitle,
      subtitle: Text(l10n.onboardingBody),
      card: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (icon, label) in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(icon, color: context.colors.primary),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: Text(label, style: context.text.titleMedium)),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          AuthPrimaryButton(
            label: l10n.onboardingAddProperty,
            busy: _busy,
            onPressed: () => _finish('/properties/create'),
          ),
        ],
      ),
      footer: Center(
        child: TextButton(
          onPressed: _busy ? null : () => _finish('/home'),
          child: Text(l10n.onboardingGoHome),
        ),
      ),
    );
  }
}
