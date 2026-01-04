import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/config/feature_flags.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_text_field.dart';
import 'package:estate_app/core/presentation/widgets/feature_coming_soon.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/presentation/controllers/tenants_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TenantsPage extends StatelessWidget {
  const TenantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Show coming soon if feature is disabled
    if (!FeatureFlags.tenantsEnabled) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Tenants')),
        body: const FeatureComingSoon(
          featureName: 'Tenant Management',
          icon: Icons.people,
          description: 'Manage your tenants, track leases, and handle tenant communications.',
        ),
      );
    }
    return const _TenantsView();
  }
}

class _TenantsView extends StatefulWidget {
  const _TenantsView();

  @override
  State<_TenantsView> createState() => _TenantsViewState();
}

class _TenantsViewState extends State<_TenantsView> {
  late final TenantsController controller;
  late final ScrollController scrollController;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TenantsController>();
    scrollController = ScrollController()..addListener(_onScroll);
    searchController = TextEditingController();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < 250) {
      unawaited(controller.loadMore());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.items;
      final isFirstLoading =
          controller.isLoadingFirstPage.value && items.isEmpty;
      final initialFailure = controller.initialFailure.value;

      return AppScaffold(
        appBar: AppBar(title: const Text('Tenants')),
        body: Column(
          children: [
            AppTextField(
              controller: searchController,
              labelText: context.l10n.commonSearch,
              hintText: 'Search tenants...',
              onChanged: controller.setQuery,
              semanticsLabel: context.l10n.commonSearch,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${items.length} tenants',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (isFirstLoading) {
                    return const Center(child: AppLoader());
                  }

                  if (initialFailure != null && items.isEmpty) {
                    return AppErrorView(
                      title: context.l10n.errorSomethingWentWrong,
                      message: initialFailure.localizedMessage(context.l10n),
                      retryLabel: context.l10n.commonRetry,
                      onRetry: () => unawaited(controller.loadInitial()),
                    );
                  }

                  if (items.isEmpty) {
                    return AppEmptyState(
                      title: 'No Tenants',
                      message: 'No tenants found',
                      action: AppButton(
                        label: context.l10n.commonRetry,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => unawaited(controller.loadInitial()),
                      ),
                    );
                  }

                  final refreshFailure = controller.refreshFailure.value;

                  return Column(
                    children: [
                      if (refreshFailure != null) ...[
                        Text(
                          refreshFailure.localizedMessage(context.l10n),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshList,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == items.length) {
                                final loadMoreFailure =
                                    controller.loadMoreFailure.value;

                                if (controller.isLoadingMore.value) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(child: AppLoader()),
                                  );
                                }

                                if (loadMoreFailure != null) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          loadMoreFailure
                                              .localizedMessage(context.l10n),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        AppButton(
                                          label: context.l10n.commonRetry,
                                          variant: AppButtonVariant.secondary,
                                          onPressed: () =>
                                              unawaited(controller.loadMore()),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (!controller.hasMore.value) {
                                  return const SizedBox(height: 16);
                                }

                                return const SizedBox.shrink();
                              }

                              final tenant = items[index];
                              return _TenantCard(
                                tenant: tenant,
                                onTap: () async {
                                  await Get.toNamed<void>(
                                    Routes.tenantDetail.replaceFirst(
                                      ':id',
                                      tenant.userId,
                                    ),
                                  );
                                  unawaited(controller.refreshList());
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TenantCard extends StatelessWidget {
  const _TenantCard({
    required this.tenant,
    required this.onTap,
  });

  final Tenant tenant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  tenant.initials,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (tenant.contactInfo != null)
                      Text(
                        tenant.contactInfo!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (tenant.hasActiveLease)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tenant.currentLease!.propertyTitle,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NO ACTIVE LEASE',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
