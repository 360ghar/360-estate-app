import 'package:cached_network_image/cached_network_image.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Avatar size options.
enum AppAvatarSize {
  xs,
  sm,
  md,
  lg,
  xl,
}

/// Avatar component for displaying user images or initials.
///
/// Features:
/// - Displays image URL if provided
/// - Falls back to initials if image fails or not provided
/// - Auto-generates initials from name
/// - Colored background with contrasting text
/// - Multiple size options
///
/// Example:
/// ```dart
/// AppAvatar(
///   name: 'Rajesh Kumar',
///   imageUrl: 'https://example.com/avatar.jpg',
///   size: AppAvatarSize.md,
/// )
///
/// // Or with just initials
/// AppAvatar(
///   initials: 'RK',
///   size: AppAvatarSize.sm,
/// )
/// ```
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? initials;
  final AppAvatarSize size;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.initials,
    this.size = AppAvatarSize.md,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = _getDimension();
    final effectiveInitials = initials ?? _generateInitials(name);
    final effectiveBackgroundColor = backgroundColor ?? _generateColor(name ?? initials);

    Widget avatar = ClipOval(
      child: SizedBox(
        width: dimension,
        height: dimension,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? _buildImage(effectiveBackgroundColor, effectiveInitials)
            : _buildInitials(effectiveBackgroundColor, effectiveInitials),
      ),
    );

    if (onTap != null) {
      avatar = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: avatar,
        ),
      );
    }

    return avatar;
  }

  Widget _buildImage(Color fallbackColor, String fallbackInitials) {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildInitials(fallbackColor, fallbackInitials),
      errorWidget: (context, url, error) => _buildInitials(fallbackColor, fallbackInitials),
    );
  }

  Widget _buildInitials(Color backgroundColor, String initials) {
    final isDark = backgroundColor.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          initials,
          style: _getTextStyle().copyWith(color: textColor),
        ),
      ),
    );
  }

  double _getDimension() {
    return switch (size) {
      AppAvatarSize.xs => 24.0,
      AppAvatarSize.sm => 32.0,
      AppAvatarSize.md => 40.0,
      AppAvatarSize.lg => 48.0,
      AppAvatarSize.xl => 64.0,
    };
  }

  TextStyle _getTextStyle() {
    return switch (size) {
      AppAvatarSize.xs => AppTextStyles.labelSmall,
      AppAvatarSize.sm => AppTextStyles.labelMedium,
      AppAvatarSize.md => AppTextStyles.labelLarge,
      AppAvatarSize.lg => AppTextStyles.titleMedium,
      AppAvatarSize.xl => AppTextStyles.titleLarge,
    }?.copyWith(fontWeight: FontWeight.w600) ?? const TextStyle();
  }

  String _generateInitials(String? name) {
    if (name == null || name.isEmpty) return '?';

    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _generateColor(String? seed) {
    if (seed == null || seed.isEmpty) {
      return AppColors.primary;
    }

    // Generate consistent color from string hash
    final hash = seed.hashCode;
    final colors = [
      AppColors.primary,
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFFEC4899), // Pink
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF10B981), // Emerald
    ];

    return colors[hash.abs() % colors.length];
  }
}

/// Group of stacked avatars for showing multiple users.
///
/// Example:
/// ```dart
/// AppAvatarGroup(
///   avatars: [
///     AppAvatar(name: 'Rajesh Kumar', imageUrl: 'url1'),
///     AppAvatar(name: 'Priya Singh', imageUrl: 'url2'),
///     AppAvatar(name: 'Amit Patel'),
///   ],
///   excessCount: 3,
/// )
/// ```
class AppAvatarGroup extends StatelessWidget {
  final List<AppAvatar> avatars;
  final int? excessCount;
  final double overlap;
  final AppAvatarSize size;

  const AppAvatarGroup({
    super.key,
    required this.avatars,
    this.excessCount,
    this.overlap = 0.5,
    this.size = AppAvatarSize.sm,
  });

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();

    final dimension = _getDimension();
    final overlapOffset = dimension * overlap;

    return SizedBox(
      height: dimension,
      child: Stack(
        children: [
          for (int i = avatars.length - 1; i >= 0; i--)
            Positioned(
              left: i * overlapOffset,
              child: avatars[i],
            ),
          if (excessCount != null && excessCount! > 0)
            Positioned(
              left: avatars.length * overlapOffset,
              child: _buildExcessAvatar(context),
            ),
        ],
      ),
    );
  }

  Widget _buildExcessAvatar(BuildContext context) {
    final dimension = _getDimension();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipOval(
      child: Container(
        width: dimension,
        height: dimension,
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.borderLight,
        child: Center(
          child: Text(
            '+$excessCount',
            style: _getTextStyle().copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  double _getDimension() {
    return switch (size) {
      AppAvatarSize.xs => 24.0,
      AppAvatarSize.sm => 32.0,
      AppAvatarSize.md => 40.0,
      AppAvatarSize.lg => 48.0,
      AppAvatarSize.xl => 64.0,
    };
  }

  TextStyle _getTextStyle() {
    return switch (size) {
      AppAvatarSize.xs => AppTextStyles.labelSmall,
      AppAvatarSize.sm => AppTextStyles.labelMedium,
      AppAvatarSize.md => AppTextStyles.labelLarge,
      AppAvatarSize.lg => AppTextStyles.titleMedium,
      AppAvatarSize.xl => AppTextStyles.titleLarge,
    }?.copyWith(fontWeight: FontWeight.w600) ?? const TextStyle();
  }
}
