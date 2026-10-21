import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:flutter/material.dart';

/// A failed load: what went wrong and one way out.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: AppStateMessage(
      icon: Icons.cloud_off_rounded,
      iconColor: context.colors.error,
      title: title,
      message: message,
      action: onRetry == null
          ? null
          : FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(retryLabel ?? context.l10n.commonRetry),
            ),
    ),
  );
}

/// Pads [AppErrorView] or [AppEmptyView] so a [RefreshIndicator] can still
/// be pulled when the list has nothing to show.
class StateScrollView extends StatelessWidget {
  const StateScrollView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight.isFinite
                ? (constraints.maxHeight - AppSpacing.xxl).clamp(
                    0,
                    double.infinity,
                  )
                : 0,
          ),
          child: Center(child: child),
        ),
      ],
    ),
  );
}
