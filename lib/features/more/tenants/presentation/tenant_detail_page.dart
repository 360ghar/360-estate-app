import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/more/tenants/presentation/tenant_text.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TenantDetailPage extends ConsumerWidget {
  const TenantDetailPage({super.key, required this.tenantId});

  /// The `user_id` of the tenant, as it appears in the route.
  final String tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final userId = int.tryParse(tenantId);
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.tenantDetailTitle)),
        body: AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: l10n.tenantDetailInvalidLink,
        ),
      );
    }
    final tenant = ref.watch(tenantDetailProvider(userId));
    Future<void> reload() async {
      ref.invalidate(tenantDetailProvider(userId));
      await ref
          .read(tenantDetailProvider(userId).future)
          .catchError((_) => const Tenant());
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tenantDetailTitle)),
      body: RefreshIndicator(
        onRefresh: reload,
        child: tenant.when(
          loading: () => const AppLoadingShimmer(itemCount: 3, itemHeight: 120),
          error: (error, _) => StateScrollView(
            child: AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: reload,
            ),
          ),
          data: (tenant) => _TenantDetail(tenant: tenant),
        ),
      ),
    );
  }
}

class _TenantDetail extends StatelessWidget {
  const _TenantDetail({required this.tenant});

  final Tenant tenant;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = tenant.userId;
    final leases = tenant.leases ?? const <Lease>[];
    // The lease the tenant lives under now, else the newest one.
    final current = leases.isEmpty
        ? null
        : leases.firstWhere((l) => l.isOccupying, orElse: () => leases.first);
    final phone = tenant.phone?.trim();
    final email = tenant.email?.trim();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        AppCard(
          child: Row(
            children: [
              AppAvatar(name: tenant.fullName, size: AppAvatarSize.xl),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tenant.displayName, style: context.text.headlineSmall),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      tenant.propertyName ?? l10n.tenantsNoProperty,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    tenantStatusBadge(tenant, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppSectionCard(
          title: l10n.tenantDetailContact,
          contentPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
          children: [
            _ContactRow(
              icon: Icons.call_outlined,
              label: l10n.tenantDetailPhone,
              value: phone,
              actionLabel: l10n.tenantDetailCall(tenant.displayName),
              uri: phone == null || phone.isEmpty
                  ? null
                  : Uri(scheme: 'tel', path: phone),
            ),
            _ContactRow(
              icon: Icons.mail_outline_rounded,
              label: l10n.tenantDetailEmail,
              value: email,
              actionLabel: l10n.tenantDetailWrite(tenant.displayName),
              uri: email == null || email.isEmpty
                  ? null
                  : Uri(scheme: 'mailto', path: email),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppSectionCard(
          title: l10n.tenantDetailLeases,
          contentPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
          children: [
            if (leases.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Text(
                  l10n.tenantDetailNoLeases,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            for (final lease in leases) _LeaseRow(lease: lease),
            const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.tenantDetailAllLeases),
              trailing: const Icon(Icons.chevron_right_rounded),
              enabled: userId != null,
              onTap: () => context.go('/more/leases?tenantUserId=$userId'),
            ),
            ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: Text(l10n.tenantDetailInspections),
              // The inspection list filters by lease, not by tenant.
              subtitle: Text(
                current?.id == null
                    ? l10n.tenantDetailInspectionsNone
                    : l10n.tenantDetailInspectionsHint,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              enabled: current?.id != null,
              onTap: () =>
                  context.go('/more/inspections?leaseId=${current!.id}'),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeaseRow extends StatelessWidget {
  const _LeaseRow({required this.lease});

  final Lease lease;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final start = lease.startDate;
    final end = lease.endDate;
    final period = switch ((start, end)) {
      (final s?, final e?) => l10n.tenantDetailPeriod(
        shortDate(context, s),
        shortDate(context, e),
      ),
      (final s?, null) => l10n.tenantDetailSince(shortDate(context, s)),
      (null, final e?) => shortDate(context, e),
      (null, null) => l10n.tenantDetailOpenEnded,
    };
    final id = lease.id;
    return ListTile(
      title: Text(period),
      subtitle: Align(
        alignment: AlignmentDirectional.centerStart,
        child: leaseStatusBadge(lease.status, l10n),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: id == null ? null : () => context.go('/more/leases/$id'),
    );
  }
}

/// A phone number or an email. A known value opens the phone or the mail app.
class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.actionLabel,
    required this.uri,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String actionLabel;
  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    final target = uri;
    final known = value != null && value!.isNotEmpty;
    final tile = ListTile(
      leading: ExcludeSemantics(child: Icon(icon)),
      title: Text(label),
      subtitle: Text(
        known ? value! : context.l10n.tenantDetailNotAdded,
        style: context.text.bodyLarge?.copyWith(
          color: known
              ? context.colors.onSurface
              : context.colors.onSurfaceVariant,
        ),
      ),
      trailing: target == null
          ? null
          : ExcludeSemantics(
              child: Icon(
                Icons.open_in_new_rounded,
                color: context.colors.primary,
              ),
            ),
      onTap: target == null ? null : () => launchUrl(target),
    );
    return target == null ? tile : Semantics(hint: actionLabel, child: tile);
  }
}
