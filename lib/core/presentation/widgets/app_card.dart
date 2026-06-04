import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

/// Card visual variant.
enum AppCardVariant {
  /// Default card with subtle border and shadow
  flat,

  /// Raised card with more prominent shadow
  elevated,

  /// No fill, strong border only
  outlined,

  /// Colored tinted background
  tinted,
}

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppInsets.card,
    this.variant = AppCardVariant.flat,
    this.onTap,
    this.headerColor,
    this.tintColor,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final AppCardVariant variant;
  final VoidCallback? onTap;

  /// Colored top border accent (4px)
  final Color? headerColor;

  /// Background tint color (used with [AppCardVariant.tinted])
  final Color? tintColor;

  /// Custom border radius override
  final BorderRadiusGeometry? borderRadius;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: AppDurations.pressCurve),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null) _scaleController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onTap != null) _scaleController.reverse();
  }

  void _onTapCancel() {
    if (widget.onTap != null) _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = widget.borderRadius ?? AppRadii.lg;

    final decoration = _buildDecoration(scheme, isDark, radius);

    Widget card = Container(
      clipBehavior: widget.headerColor != null ? Clip.antiAlias : Clip.none,
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.headerColor != null)
            Container(height: 4, color: widget.headerColor),
          Padding(padding: widget.padding, child: widget.child),
        ],
      ),
    );

    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: card,
        ),
      );
    }

    return card;
  }

  BoxDecoration _buildDecoration(
    ColorScheme scheme,
    bool isDark,
    BorderRadiusGeometry radius,
  ) {
    return switch (widget.variant) {
      AppCardVariant.flat => BoxDecoration(
          color: scheme.surface,
          borderRadius: radius,
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 0.5,
          ),
          boxShadow: AppShadows.cardResting,
        ),
      AppCardVariant.elevated => BoxDecoration(
          color: scheme.surface,
          borderRadius: radius,
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 0.5,
          ),
          boxShadow: AppShadows.cardElevated,
        ),
      AppCardVariant.outlined => BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      AppCardVariant.tinted => BoxDecoration(
          color: widget.tintColor?.withValues(alpha: isDark ? 0.12 : 0.06) ??
              (isDark ? AppColors.darkAccentSoft : AppColors.accentSoft),
          borderRadius: radius,
          border: Border.all(
            color: widget.tintColor?.withValues(alpha: isDark ? 0.2 : 0.12) ??
                (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
            width: 0.5,
          ),
        ),
    };
  }
}
