import 'package:estate_app/core/auth/user_role.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TenantProfilePage extends ConsumerWidget {
  const TenantProfilePage({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return 'Not set';
    return amount.toStringAsFixed(0);
  }

  String _valueOrFallback(String? value, String fallback) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return fallback;
    return trimmed;
  }

  AppStatusType _leaseStatusType(String? status) {
    final value = status?.toLowerCase() ?? '';
    if (value.contains('active') || value.contains('current')) {
      return AppStatusType.success;
    }
    if (value.contains('pending') || value.contains('draft')) {
      return AppStatusType.warning;
    }
    if (value.contains('expired') ||
        value.contains('terminated') ||
        value.contains('cancel')) {
      return AppStatusType.danger;
    }
    return AppStatusType.neutral;
  }

  String _leaseStatusLabel(String? status) {
    final value = status?.trim();
    if (value == null || value.isEmpty) return 'NOT SET';
    return value.replaceAll('_', ' ').toUpperCase();
  }

  Lease? _selectPrimaryLease(List<Lease> leases) {
    if (leases.isEmpty) return null;
    final active = leases.where((lease) {
      final status = lease.status?.toLowerCase() ?? '';
      return status.contains('active') || status.contains('current');
    }).toList();
    final candidates = active.isNotEmpty ? active : leases;
    candidates.sort((a, b) {
      final aDate =
          a.startDate ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          b.startDate ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return candidates.first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final profile = authState.user;
    final displayName = _valueOrFallback(profile?.displayName, 'User');
    final email = _valueOrFallback(profile?.email, 'Not set');
    final phone = _valueOrFallback(profile?.phone, 'Not set');
    final roleLabel = authState.role?.label ?? profile?.role;
    final roleValue = _valueOrFallback(roleLabel, 'User');
    final userId = profile?.id?.toString() ?? 'Not set';

    final tenantId = profile?.id?.toString();
    final leaseFilter =
        tenantId == null ? null : LeaseListFilter(tenantId: tenantId);
    final leasesAsync = leaseFilter == null
        ? const AsyncValue.data(<Lease>[])
        : ref.watch(leasesListProvider(leaseFilter));

    return AppScaffold(
      appBar: AppBar(title: const Text('Profile')),
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _ProfileHeroCard(
            displayName: displayName,
            phone: phone,
            avatarUrl: profile?.avatarUrl,
            onEditTap: () => context.push('/tenant/profile/edit'),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(
            title: 'Quick Actions',
            icon: Icons.bolt_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.build_outlined,
                iconColor: AppColors.warning,
                title: 'Maintenance requests',
                subtitle: 'Track your tickets',
                onTap: () => context.go('/tenant/requests'),
              ),
              _SettingsTile(
                icon: Icons.payments_outlined,
                iconColor: AppColors.primary,
                title: 'Payments',
                subtitle: 'View charges and history',
                onTap: () => context.go('/tenant/payments'),
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                iconColor: AppColors.info,
                title: 'Documents',
                subtitle: 'Lease and shared files',
                onTap: () => context.go('/tenant/documents'),
              ),
              _SettingsTile(
                icon: Icons.fact_check_outlined,
                iconColor: AppColors.success,
                title: 'Inspections',
                subtitle: 'Review upcoming inspections',
                onTap: () => context.go('/tenant/profile/inspections'),
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.accent,
                title: 'Notifications',
                subtitle: 'Alerts and updates',
                onTap: () => context.go('/tenant/profile/notifications'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(
            title: 'Preferences',
            icon: Icons.tune_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                iconColor: AppColors.warning,
                title: 'Appearance',
                subtitle: 'Theme and language',
                onTap: () => context.push('/tenant/profile/settings'),
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.accent,
                title: 'Notification settings',
                subtitle: 'Alerts and reminders',
                onTap: () =>
                    context.push('/tenant/profile/settings/notifications'),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: AppColors.success,
                title: 'Privacy',
                subtitle: 'Control your data',
                onTap: () => context.push('/tenant/profile/settings/privacy'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(
            title: 'Account Details',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            children: [
              _DetailTile(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                label: 'Name',
                value: displayName,
              ),
              _DetailTile(
                icon: Icons.verified_user_outlined,
                iconColor: AppColors.info,
                label: 'Role',
                value: roleValue,
              ),
              _DetailTile(
                icon: Icons.email_outlined,
                iconColor: AppColors.accent,
                label: 'Email',
                value: email,
              ),
              _DetailTile(
                icon: Icons.phone_outlined,
                iconColor: AppColors.warning,
                label: 'Phone',
                value: phone,
              ),
              _DetailTile(
                icon: Icons.tag_outlined,
                iconColor: AppColors.primary,
                label: 'User ID',
                value: userId,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(
            title: 'Lease Details',
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildLeaseCard(
            context,
            leasesAsync,
            onRetry: leaseFilter == null
                ? null
                : () => ref.invalidate(leasesListProvider(leaseFilter)),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SignOutCard(
            isBusy: authState.isBusy,
            onTap: () => ref.read(authControllerProvider.notifier).logout(),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildLeaseCard(
    BuildContext context,
    AsyncValue<List<Lease>> leasesAsync, {
    VoidCallback? onRetry,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return leasesAsync.when(
      data: (leases) {
        final lease = _selectPrimaryLease(leases);
        if (lease == null) {
          return _LeaseStateCard(
            child: Text(
              'No lease found yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          );
        }

        final propertyLabel = lease.propertyName?.trim();
        final propertyName = propertyLabel != null && propertyLabel.isNotEmpty
            ? propertyLabel
            : lease.propertyId != null
                ? 'Property #${lease.propertyId}'
                : 'Property';

        return _LeaseSummaryCard(
          lease: lease,
          propertyName: propertyName,
          statusLabel: _leaseStatusLabel(lease.status),
          statusType: _leaseStatusType(lease.status),
          formatDate: _formatDate,
          formatCurrency: _formatCurrency,
        );
      },
      loading: () => const _LeaseStateCard(
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: AppSpacing.md),
            Text('Loading lease details...'),
          ],
        ),
      ),
      error: (error, _) => _LeaseStateCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unable to load lease details.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              error.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.displayName,
    required this.phone,
    this.avatarUrl,
    this.onEditTap,
  });

  final String displayName;
  final String phone;
  final String? avatarUrl;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.6),
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEditTap,
          borderRadius: AppRadii.lg,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                AppAvatar(
                  imageUrl: avatarUrl,
                  name: displayName,
                  size: AppAvatarSize.lg,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phone,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onEditTap != null)
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: AppRadii.sm,
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          final isLast = index == children.length - 1;
          return Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : 1,
            ),
            child: children[index],
          );
        }),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.md,
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: AppRadii.md,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          size: 18,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: AppRadii.md,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }
}

class _LeaseSummaryCard extends StatelessWidget {
  const _LeaseSummaryCard({
    required this.lease,
    required this.propertyName,
    required this.statusLabel,
    required this.statusType,
    required this.formatDate,
    required this.formatCurrency,
  });

  final Lease lease;
  final String propertyName;
  final String statusLabel;
  final AppStatusType statusType;
  final String Function(DateTime?) formatDate;
  final String Function(double?) formatCurrency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.colorScheme.outlineVariant.withOpacity(0.5);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(color: dividerColor),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    propertyName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppStatusBadge(
                  label: statusLabel,
                  type: statusType,
                  variant: AppStatusVariant.subtle,
                ),
              ],
            ),
          ),
          Container(height: 1, color: dividerColor),
          _DetailTile(
            icon: Icons.confirmation_number_outlined,
            iconColor: AppColors.primary,
            label: 'Lease ID',
            value: lease.id?.toString() ?? 'Not set',
          ),
          _DetailTile(
            icon: Icons.event_outlined,
            iconColor: AppColors.info,
            label: 'Start date',
            value: formatDate(lease.startDate),
          ),
          _DetailTile(
            icon: Icons.event_available_outlined,
            iconColor: AppColors.success,
            label: 'End date',
            value: formatDate(lease.endDate),
          ),
          _DetailTile(
            icon: Icons.attach_money,
            iconColor: AppColors.warning,
            label: 'Rent',
            value: formatCurrency(lease.rentAmount),
          ),
          _DetailTile(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.accent,
            label: 'Deposit',
            value: formatCurrency(lease.depositAmount),
          ),
        ],
      ),
    );
  }
}

class _LeaseStateCard extends StatelessWidget {
  const _LeaseStateCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
        boxShadow: AppShadows.sm,
      ),
      child: child,
    );
  }
}

class _SignOutCard extends StatelessWidget {
  const _SignOutCard({
    required this.isBusy,
    required this.onTap,
  });

  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isBusy ? null : onTap,
      borderRadius: AppRadii.lg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withOpacity(0.3),
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: theme.colorScheme.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Sign Out',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isBusy) ...[
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
