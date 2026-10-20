import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/owner_scope_card.dart';
import 'package:estate_app/features/more/presentation/widgets/link_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The index of everything that is not a tab: who you are, what you manage,
/// your account, and help. Sign out sits apart at the foot.
class MorePage extends ConsumerStatefulWidget {
  const MorePage({super.key});

  @override
  ConsumerState<MorePage> createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage> {
  String? _version;

  @override
  void initState() {
    super.initState();
    unawaited(_loadVersion());
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = info.version);
  }

  Future<void> _signOut() async {
    final l10n = context.l10n;
    final confirmed = await context.confirm(
      title: l10n.moreSignOutTitle,
      message: l10n.moreSignOutBody,
      confirmLabel: l10n.commonSignOut,
      destructive: true,
    );
    if (confirmed) await ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final flags = ref.watch(appConfigProvider).featureFlags;
    final authState = ref.watch(authControllerProvider);
    void open(String path) => context.push(path);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          _ProfileRow(user: authState.user, onTap: () => open('/more/profile')),
          const SizedBox(height: AppSpacing.md),
          // Agents and admins pick the owner they manage. Owners see nothing.
          const OwnerScopeCard(),
          LinkGroup(
            title: l10n.moreSectionManage,
            children: [
              if (flags.enableApplicationsModule)
                LinkRow(
                  icon: Icons.assignment_outlined,
                  title: l10n.moreApplications,
                  onTap: () => open('/more/applications'),
                ),
              LinkRow(
                icon: Icons.people_outline_rounded,
                title: l10n.moreTenants,
                onTap: () => open('/more/tenants'),
              ),
              LinkRow(
                icon: Icons.description_outlined,
                title: l10n.moreLeases,
                onTap: () => open('/more/leases'),
              ),
              LinkRow(
                icon: Icons.fact_check_outlined,
                title: l10n.moreInspections,
                onTap: () => open('/more/inspections'),
              ),
              LinkRow(
                icon: Icons.receipt_long_outlined,
                title: l10n.moreExpenses,
                onTap: () => open('/more/expenses'),
              ),
              LinkRow(
                icon: Icons.folder_outlined,
                title: l10n.moreDocuments,
                onTap: () => open('/more/documents'),
              ),
              LinkRow(
                icon: Icons.insert_chart_outlined_rounded,
                title: l10n.moreReports,
                onTap: () => open('/more/reports'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.moreSectionAccount,
            children: [
              LinkRow(
                icon: Icons.notifications_none_rounded,
                title: l10n.notifications,
                onTap: () => open('/more/notifications'),
              ),
              LinkRow(
                icon: Icons.tune_rounded,
                title: l10n.moreSettings,
                onTap: () => open('/more/profile/settings'),
              ),
              LinkRow(
                icon: Icons.lock_outline_rounded,
                title: l10n.moreChangePassword,
                onTap: () => open('/more/profile/change-password'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinkGroup(
            title: l10n.moreSectionSupport,
            children: [
              LinkRow(
                icon: Icons.help_outline_rounded,
                title: l10n.moreHelp,
                onTap: () => open('/more/profile/help'),
              ),
              LinkRow(
                icon: Icons.mail_outline_rounded,
                title: l10n.moreContact,
                onTap: () => open('/more/profile/contact'),
              ),
              LinkRow(
                icon: Icons.info_outline_rounded,
                title: l10n.about,
                onTap: () => open('/more/profile/about'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: TextButton.icon(
              onPressed: authState.isBusy ? null : _signOut,
              style: TextButton.styleFrom(
                foregroundColor: context.colors.error,
              ),
              icon: authState.isBusy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout_rounded),
              label: Text(l10n.commonSignOut),
            ),
          ),
          if (_version != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.moreVersion(_version!),
              textAlign: TextAlign.center,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Who is signed in. Tap to open the profile.
class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.user, required this.onTap});

  final UserProfile? user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = user?.displayName;
    final contact = [
      user?.email,
      user?.phone,
    ].whereType<String>().where((s) => s.trim().isNotEmpty);
    final muted = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    return AppCard(
      onTap: onTap,
      semanticLabel: context.l10n.moreOpenProfile,
      child: Row(
        children: [
          AppAvatar(
            imageUrl: user?.avatarUrl,
            name: name,
            size: AppAvatarSize.lg,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name == null || name.trim().isEmpty
                      ? context.l10n.moreGuestName
                      : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleLarge,
                ),
                for (final line in contact)
                  Text(
                    line,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: muted,
                  ),
              ],
            ),
          ),
          ExcludeSemantics(
            child: Icon(
              Icons.chevron_right_rounded,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
