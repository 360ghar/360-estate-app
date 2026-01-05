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
import 'package:estate_app/core/presentation/widgets/feature_coming_soon.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';
import 'package:estate_app/features/leases/presentation/controllers/leases_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeasesPage extends StatelessWidget {
  const LeasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Show coming soon if feature is disabled
    if (!FeatureFlags.leasesEnabled) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Leases')),
        body: const FeatureComingSoon(
          featureName: 'Lease Management',
          icon: Icons.description,
          description:
              'Create and manage lease agreements, track renewals, and handle terminations.',
        ),
      );
    }
    return const _LeasesView();
  }
}

class _LeasesView extends StatefulWidget {
  const _LeasesView();

  @override
  State<_LeasesView> createState() => _LeasesViewState();
}

class _LeasesViewState extends State<_LeasesView> {
  late final LeasesController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LeasesController>();
    scrollController = ScrollController()..addListener(_onScroll);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.items;
      final isLoading = controller.isLoading.value && items.isEmpty;
      final failure = controller.failure.value;

      return AppScaffold(
        appBar: AppBar(
          title: const Text('Leases'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterSheet(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'leases_fab',
          onPressed: () async {
            await Get.toNamed<void>(Routes.leaseCreate);
            unawaited(controller.refresh());
          },
          child: const Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (isLoading) {
              return const Center(child: AppLoader());
            }

            if (failure != null && items.isEmpty) {
              return AppErrorView(
                title: context.l10n.errorSomethingWentWrong,
                message: failure.localizedMessage(context.l10n),
                retryLabel: context.l10n.commonRetry,
                onRetry: () => unawaited(controller.loadLeases()),
              );
            }

            if (items.isEmpty) {
              return AppEmptyState(
                icon: Icons.description_outlined,
                title: 'No Leases',
                message: 'No leases found. Create a new lease to get started.',
                action: AppButton(
                  label: 'Create Lease',
                  onPressed: () => Get.toNamed<void>(Routes.leaseCreate),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    if (controller.isLoadingMore.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: AppLoader()),
                      );
                    }
                    return const SizedBox(height: 16);
                  }

                  final lease = items[index];
                  return _LeaseCard(
                    lease: lease,
                    onTap: () async {
                      await Get.toNamed<void>(
                        Routes.leaseDetail.replaceFirst(
                          ':id',
                          lease.id.toString(),
                        ),
                      );
                      unawaited(controller.refresh());
                    },
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  void _showFilterSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Filter Leases',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        controller.clearFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _FilterChip(
                      label: 'Active',
                      isSelected: controller.filterStatus.value == 'active',
                      onTap: () {
                        controller.setStatusFilter('active');
                        Navigator.pop(context);
                      },
                    ),
                    _FilterChip(
                      label: 'Expired',
                      isSelected: controller.filterStatus.value == 'expired',
                      onTap: () {
                        controller.setStatusFilter('expired');
                        Navigator.pop(context);
                      },
                    ),
                    _FilterChip(
                      label: 'Terminated',
                      isSelected: controller.filterStatus.value == 'terminated',
                      onTap: () {
                        controller.setStatusFilter('terminated');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor:
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class _LeaseCard extends StatelessWidget {
  const _LeaseCard({
    required this.lease,
    required this.onTap,
  });

  final Lease lease;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '\u20B9',
      decimalDigits: 0,
    );

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lease.propertyTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _StatusBadge(lease: lease),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    lease.tenantName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${dateFormat.format(lease.startDate)} - ${dateFormat.format(lease.endDate)}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currencyFormat.format(lease.monthlyRent)}/month',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (lease.isExpiringSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lease.daysRemaining} days',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.lease});

  final Lease lease;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (lease.isActive) {
      color = Colors.green;
      label = 'ACTIVE';
    } else if (lease.isExpired) {
      color = Colors.red;
      label = 'EXPIRED';
    } else {
      color = Colors.grey;
      label = lease.status?.toUpperCase() ?? 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
