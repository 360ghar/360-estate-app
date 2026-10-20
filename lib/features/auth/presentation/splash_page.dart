import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';

/// Shown while the stored session is checked. Everything is on screen from
/// the first frame; only the mark rises into place and the line runs.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RiseIn(child: AuthLogo(height: 96)),
                const SizedBox(height: AppSpacing.xl),
                ExcludeSemantics(
                  child: Text(
                    l10n.appName,
                    style: context.text.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.authSplashTagline,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: AppRadii.xs,
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      semanticsLabel: l10n.commonLoading,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
