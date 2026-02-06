import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:estate_app/core/presentation/design_system/design_system.dart';

/// Toast notification types
enum GlassToastType {
  /// Success toast with green accent
  success,

  /// Error toast with red accent
  error,

  /// Info toast with blue accent
  info,

  /// Warning toast with orange accent
  warning,
}

/// A glassmorphism toast notification.
///
/// Displays temporary messages with premium glass styling.
///
/// Example:
/// ```dart
/// GlassToast.show(
///   context: context,
///   message: 'Operation successful!',
///   type: GlassToastType.success,
/// )
/// ```
class GlassToast extends StatelessWidget {
  /// Message to display
  final String message;

  /// Toast type (success, error, info, warning)
  final GlassToastType type;

  /// Optional title
  final String? title;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the toast
  final double borderRadius;

  /// Duration before auto-dismiss
  final Duration duration;

  /// Icon to display
  final IconData? icon;

  const GlassToast({
    super.key,
    required this.message,
    this.type = GlassToastType.info,
    this.title,
    this.blur = AppGlassBlur.medium,
    this.opacity = AppGlassColors.opacityStrong,
    this.borderRadius = 12,
    this.duration = const Duration(milliseconds: 3000),
    this.icon,
  });

  /// Shows a glass toast notification
  static void show(
    BuildContext context, {
    required String message,
    GlassToastType type = GlassToastType.info,
    String? title,
    double blur = AppGlassBlur.medium,
    double opacity = AppGlassColors.opacityStrong,
    double borderRadius = 12,
    Duration duration = const Duration(milliseconds: 3000),
    IconData? icon,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _GlassToastOverlay(
        message: message,
        type: type,
        title: title,
        blur: blur,
        opacity: opacity,
        borderRadius: borderRadius,
        duration: duration,
        icon: icon,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Shows a success toast
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    show(
      context,
      message: message,
      type: GlassToastType.success,
      title: title,
      duration: duration,
    );
  }

  /// Shows an error toast
  static void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    show(
      context,
      message: message,
      type: GlassToastType.error,
      title: title,
      duration: duration,
    );
  }

  /// Shows an info toast
  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    show(
      context,
      message: message,
      type: GlassToastType.info,
      title: title,
      duration: duration,
    );
  }

  /// Shows a warning toast
  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    show(
      context,
      message: message,
      type: GlassToastType.warning,
      title: title,
      duration: duration,
    );
  }

  Color _getAccentColor(BuildContext context) {
    switch (type) {
      case GlassToastType.success:
        return AppColors.successLight;
      case GlassToastType.error:
        return AppColors.dangerLight;
      case GlassToastType.info:
        return AppColors.infoLight;
      case GlassToastType.warning:
        return AppColors.warningLight;
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case GlassToastType.success:
        return Icons.check_circle_outline;
      case GlassToastType.error:
        return Icons.error_outline;
      case GlassToastType.info:
        return Icons.info_outline;
      case GlassToastType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor(context);
    final effectiveIcon = icon ?? _getDefaultIcon();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppGlassColors.toastDark.withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppGlassColors.borderDark,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    effectiveIcon,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: title != null ? FontWeight.w400 : FontWeight.w500,
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
    );
  }
}

class _GlassToastOverlay extends StatefulWidget {
  final String message;
  final GlassToastType type;
  final String? title;
  final double blur;
  final double opacity;
  final double borderRadius;
  final Duration duration;
  final IconData? icon;
  final VoidCallback onDismiss;

  const _GlassToastOverlay({
    required this.message,
    required this.type,
    this.title,
    required this.blur,
    required this.opacity,
    required this.borderRadius,
    required this.duration,
    this.icon,
    required this.onDismiss,
  });

  @override
  State<_GlassToastOverlay> createState() => _GlassToastOverlayState();
}

class _GlassToastOverlayState extends State<_GlassToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GlassToast(
            message: widget.message,
            type: widget.type,
            title: widget.title,
            blur: widget.blur,
            opacity: widget.opacity,
            borderRadius: widget.borderRadius,
            duration: widget.duration,
            icon: widget.icon,
          ),
        ),
      ),
    );
  }
}

/// A glass snackbar alternative with bottom positioning.
class GlassSnackbar extends StatelessWidget {
  /// Message to display
  final String message;

  /// Optional action button label
  final String? actionLabel;

  /// Callback for action button
  final VoidCallback? onAction;

  /// Snackbar type
  final GlassToastType type;

  const GlassSnackbar({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.type = GlassToastType.info,
  });

  /// Shows a glass snackbar at the bottom
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    GlassToastType type = GlassToastType.info,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 8,
        ),
        content: GlassSnackbar(
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
          type: type,
        ),
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }

  Color _getAccentColor() {
    switch (type) {
      case GlassToastType.success:
        return AppColors.successLight;
      case GlassToastType.error:
        return AppColors.dangerLight;
      case GlassToastType.info:
        return AppColors.infoLight;
      case GlassToastType.warning:
        return AppColors.warningLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppGlassBlur.medium, sigmaY: AppGlassBlur.medium),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppGlassColors.toastDark.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppGlassColors.borderDark,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                type == GlassToastType.success
                    ? Icons.check_circle
                    : type == GlassToastType.error
                        ? Icons.error
                        : Icons.info,
                color: accentColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onAction?.call();
                  },
                  child: Text(
                    actionLabel!,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
