import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:flutter/material.dart';

/// Profile header widget with avatar, name, email, phone, and edit button
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    this.onEditTap,
  });

  final UserProfile? profile;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final displayName = profile?.displayName ?? 'User';
    final email = profile?.email ?? '';
    final phone = profile?.phone ?? '';
    final avatarUrl = profile?.avatarUrl;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: AppRadii.lg,
      ),
      child: Row(
        children: [
          // Avatar
          _Avatar(
            avatarUrl: avatarUrl,
            displayName: displayName,
            onEditTap: onEditTap,
          ),
          const SizedBox(width: AppSpacing.md),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
                if (phone.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    phone,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),

          // Edit button
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEditTap,
            tooltip: context.l10n?.editProfile ?? 'Edit Profile',
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.avatarUrl,
    required this.displayName,
    this.onEditTap,
  });

  final String? avatarUrl;
  final String displayName;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: onEditTap,
      child: Stack(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                ],
              ),
            ),
            child: hasAvatar
                ? ClipOval(
                    child: Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _FallbackAvatar(initial: initial);
                      },
                    ),
                  )
                : _FallbackAvatar(initial: initial),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
