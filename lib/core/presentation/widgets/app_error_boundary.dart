import 'package:flutter/material.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';

/// Style options for error display.
enum ErrorStyle {
  /// Full-page error with retry option
  fullPage,

  /// Inline error within a list or card
  inline,

  /// Banner/snackbar style error
  banner,
}

/// A consistent error display widget that adapts to different contexts.
///
/// This widget provides a unified way to display errors throughout the app,
/// ensuring consistent UX for error states.
class AppErrorBoundary extends StatelessWidget {
  const AppErrorBoundary({
    super.key,
    required this.failure,
    required this.onRetry,
    this.style = ErrorStyle.fullPage,
    this.title,
    this.showIcon = true,
  });

  /// The failure to display
  final Failure failure;

  /// Callback when user wants to retry
  final VoidCallback onRetry;

  /// The display style for this error
  final ErrorStyle style;

  /// Optional title override (defaults to failure title)
  final String? title;

  /// Whether to show an error icon
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      ErrorStyle.fullPage => _FullPageError(
          failure: failure,
          onRetry: onRetry,
          title: title,
          showIcon: showIcon,
        ),
      ErrorStyle.inline => _InlineError(
          failure: failure,
          onRetry: onRetry,
        ),
      ErrorStyle.banner => _BannerError(
          failure: failure,
          onRetry: onRetry,
        ),
    };
  }
}

class _FullPageError extends StatelessWidget {
  const _FullPageError({
    required this.failure,
    required this.onRetry,
    this.title,
    required this.showIcon,
  });

  final Failure failure;
  final VoidCallback onRetry;
  final String? title;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showIcon) ...[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    _getIconForFailure(failure),
                    size: 40,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text(
                title ?? _getTitleForFailure(failure, l10n),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                failure.localizedMessage(l10n),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForFailure(Failure failure) {
    return switch (failure.runtimeType) {
      const (NetworkFailure) => Icons.wifi_off,
      const (UnauthorizedFailure) => Icons.lock_outline,
      const (NotFoundFailure) => Icons.search_off,
      const (ValidationFailure) => Icons.error_outline,
      _ => Icons.error_outline,
    };
  }

  String _getTitleForFailure(Failure failure, dynamic l10n) {
    return switch (failure.runtimeType) {
      const (NetworkFailure) => 'Connection Error',
      const (UnauthorizedFailure) => 'Authentication Required',
      const (NotFoundFailure) => 'Not Found',
      const (ValidationFailure) => 'Invalid Input',
      _ => 'Something Went Wrong',
    };
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({
    required this.failure,
    required this.onRetry,
  });

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  failure.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _BannerError extends StatelessWidget {
  const _BannerError({
    required this.failure,
    required this.onRetry,
  });

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              failure.message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
