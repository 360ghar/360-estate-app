import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/presentation/widgets/receipt_edge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The applicant's receipt: the application arrived, and what happens next.
class PublicApplicationSuccessPage extends StatelessWidget {
  const PublicApplicationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyLarge?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final steps = [
      l10n.publicApplySentStep1,
      l10n.publicApplySentStep2,
      l10n.publicApplySentStep3,
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.publicApplyTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          RiseIn(
            child: Semantics(
              liveRegion: true,
              child: Material(
                color: context.palette.card,
                shape: const ReceiptEdgeBorder(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xl,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 44,
                          color: context.palette.success,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.publicApplySentTitle,
                        style: context.text.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l10n.publicApplySentBody, style: muted),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        l10n.publicApplySentNext,
                        style: context.text.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final (index, step) in steps.indexed)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 28,
                                child: Text(
                                  '${index + 1}',
                                  style: context.text.bodyLarge?.copyWith(
                                    color: context.colors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  step,
                                  style: context.text.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: TextButton(
              onPressed: () => context.go(Routes.enterPhone),
              child: Text(l10n.publicApplySignIn),
            ),
          ),
        ],
      ),
    );
  }
}
