import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TenantDetailPage extends ConsumerWidget {
  const TenantDetailPage({super.key, required this.tenantId});

  final String tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(tenantDetailProvider(tenantId));

    return AppScaffold(
      appBar: AppBar(title: const Text('Tenant details')),
      scrollable: true,
      body: tenantAsync.when(
        data: (tenant) => _TenantDetail(tenant: tenant),
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load tenant',
          message: error.toString(),
          onRetry: () => ref.invalidate(tenantDetailProvider(tenantId)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _TenantDetail extends StatelessWidget {
  const _TenantDetail({required this.tenant});

  final Tenant tenant;

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppStatusType.success;
      case 'inactive':
      case 'moved_out':
      case 'moved out':
        return AppStatusType.neutral;
      case 'pending':
        return AppStatusType.warning;
      default:
        return AppStatusType.info;
    }
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenantId = tenant.id?.toString();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final status = tenant.status ?? 'Active';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Header Card
        AppCard(
          variant: AppCardVariant.tinted,
          tintColor: scheme.primary,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    _getInitials(tenant.displayName),
                    style: textTheme.titleLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant.displayName,
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tenant.propertyName ?? 'Property not set',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: status,
                type: _statusType(status),
                variant: AppStatusVariant.subtle,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Contact Information
        AppSectionCard(
          title: 'Contact Information',
          icon: Icons.contact_phone_outlined,
          children: [
            _ContactRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: tenant.phone ?? 'Not set',
              onTap: tenant.phone != null
                  ? () => _launchPhone(tenant.phone!)
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _ContactRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: tenant.email ?? 'Not set',
              onTap: tenant.email != null
                  ? () => _launchEmail(tenant.email!)
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _ContactRow(
              icon: Icons.door_front_door_outlined,
              label: 'Room',
              value: tenant.roomNumber ?? 'Not set',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Leases & Inspections
        AppSectionCard(
          title: 'Leases & Inspections',
          icon: Icons.assignment_outlined,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: tenantId == null
                        ? null
                        : () =>
                            context.go('/more/leases?tenantId=$tenantId'),
                    icon: const Icon(Icons.assignment_outlined, size: 18),
                    label: const Text('View leases'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: tenantId == null
                        ? null
                        : () => context
                            .go('/more/inspections?tenantId=$tenantId'),
                    icon: const Icon(Icons.fact_check_outlined, size: 18),
                    label: const Text('Inspections'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    Widget content = Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  color: onTap != null ? scheme.primary : null,
                  fontWeight: onTap != null ? FontWeight.w500 : null,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.open_in_new_rounded,
            size: 16,
            color: scheme.primary.withValues(alpha: 0.6),
          ),
      ],
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: content,
        ),
      );
    }

    return content;
  }
}
