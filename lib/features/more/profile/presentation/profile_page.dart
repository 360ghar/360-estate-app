import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/more/presentation/widgets/link_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Who you are in the app: photo, name, how to reach you, and the one way to
/// change it.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(authControllerProvider).user;
    final name = profile?.displayName;
    final shownName = name == null || name.trim().isEmpty
        ? l10n.moreGuestName
        : name;

    String orNotSet(String? value) =>
        value == null || value.trim().isEmpty ? l10n.profileNotSet : value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profilePageTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          Center(
            child: AppAvatar(
              imageUrl: profile?.avatarUrl,
              name: name,
              size: AppAvatarSize.xl,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            shownName,
            textAlign: TextAlign.center,
            style: context.text.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => context.push('/more/profile/edit'),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(l10n.profileEditAction),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          LinkGroup(
            title: l10n.profileDetailsTitle,
            children: [
              _DetailRow(
                icon: Icons.person_outline_rounded,
                label: l10n.profileName,
                value: orNotSet(profile?.fullName),
              ),
              _DetailRow(
                icon: Icons.mail_outline_rounded,
                label: l10n.profileEmail,
                value: orNotSet(profile?.email),
              ),
              _DetailRow(
                icon: Icons.phone_outlined,
                label: l10n.profilePhone,
                value: orNotSet(profile?.phone),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.profileSecurityTitle,
            children: [
              LinkRow(
                icon: Icons.lock_outline_rounded,
                title: l10n.moreChangePassword,
                onTap: () => context.push('/more/profile/change-password'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A read-only fact: what it is, then the value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: ListTile(
      leading: ExcludeSemantics(child: Icon(icon)),
      title: Text(
        label,
        style: context.text.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: context.text.bodyLarge?.copyWith(
          color: context.colors.onSurface,
        ),
      ),
    ),
  );
}
