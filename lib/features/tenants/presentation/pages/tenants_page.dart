import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_text_field.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/presentation/controllers/tenants_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TenantsPage extends StatelessWidget {
  const TenantsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.brand.withValues(alpha: 0.1),
          child: Text(
            tenant.initials,
            style: const TextStyle(
              color: AppColors.brand,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(tenant.displayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tenant.contactInfo != null) Text(tenant.contactInfo!),
            if (tenant.hasActiveLease)
              Text(
                'Active lease: ${tenant.currentLease!.propertyTitle}',
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 12,
                ),
              )
            else
              Text(
                'No active lease',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 12,
                ),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.brand,
        ),
      ),
    );
  }
}
