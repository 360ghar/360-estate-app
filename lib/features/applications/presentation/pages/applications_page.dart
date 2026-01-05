import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';
import 'package:estate_app/features/applications/presentation/controllers/applications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ApplicationsView();
  }
}

class _ApplicationsView extends StatefulWidget {
  const _ApplicationsView();

  @override
  State<_ApplicationsView> createState() => _ApplicationsViewState();
}

class _ApplicationsViewState extends State<_ApplicationsView>
    with SingleTickerProviderStateMixin {
  late final ApplicationsController controller;
  late final TabController tabController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ApplicationsController>();
    tabController = TabController(length: 2, vsync: this);
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
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Inbox'),
            Tab(text: 'Forms'),
          ],
        ),
        actions: [
          Obx(() {
            if (controller.hasActiveFilters) {
              return IconButton(
                icon: const Icon(Icons.filter_alt_off),
                onPressed: controller.clearFilters,
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'applications_fab',
        onPressed: () async {
          final result = await Get.toNamed<ApplicationForm>(
            Routes.applicationFormCreate,
          );
          if (result != null) {
            unawaited(controller.loadForms());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _ApplicationsTab(
            controller: controller,
            scrollController: scrollController,
          ),
          _FormsTab(controller: controller),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
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
                      'Filter Applications',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        controller.clearFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear All'),
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
                  runSpacing: 8,
                  children: ApplicationStatus.values.map((status) {
                    return _FilterChip(
                      label: status.displayName,
                      isSelected: controller.filterStatus.value == status,
                      onTap: () {
                        controller.setStatusFilter(status);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
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

class _ApplicationsTab extends StatelessWidget {
  const _ApplicationsTab({
    required this.controller,
    required this.scrollController,
  });

  final ApplicationsController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.applications;
      final isLoading = controller.isLoadingApplications.value && items.isEmpty;
      final failure = controller.applicationsFailure.value;

      if (isLoading) {
        return const Center(child: AppLoader());
      }

      if (failure != null && items.isEmpty) {
        return AppErrorView(
          title: context.l10n.errorSomethingWentWrong,
          message: failure.localizedMessage(context.l10n),
          retryLabel: context.l10n.commonRetry,
          onRetry: () => unawaited(controller.loadApplications()),
        );
      }

      if (items.isEmpty) {
        return const AppEmptyState(
          title: 'No Applications',
          message: 'No applications received yet.',
        );
      }

      return Column(
        children: [
          // Stats bar
          _StatsBar(controller: controller),
          // List
          Expanded(
            child: RefreshIndicator(
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

                  final application = items[index];
                  return _ApplicationCard(
                    application: application,
                    onTap: () async {
                      final result = await Get.toNamed<Application>(
                        Routes.applicationDetail
                            .replaceFirst(':id', '${application.id}'),
                      );
                      if (result != null) {
                        unawaited(controller.loadApplications());
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _FormsTab extends StatelessWidget {
  const _FormsTab({required this.controller});

  final ApplicationsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final forms = controller.forms;
      final isLoading = controller.isLoadingForms.value && forms.isEmpty;
      final failure = controller.formsFailure.value;

      if (isLoading) {
        return const Center(child: AppLoader());
      }

      if (failure != null && forms.isEmpty) {
        return AppErrorView(
          title: context.l10n.errorSomethingWentWrong,
          message: failure.localizedMessage(context.l10n),
          retryLabel: context.l10n.commonRetry,
          onRetry: () => unawaited(controller.loadForms()),
        );
      }

      if (forms.isEmpty) {
        return AppEmptyState(
          icon: Icons.description_outlined,
          title: 'No Application Forms',
          message: 'Create an application form for your properties.',
          action: AppButton(
            label: 'Create Form',
            onPressed: () => Get.toNamed<void>(Routes.applicationFormCreate),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadForms,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: forms.length,
          itemBuilder: (context, index) {
            final form = forms[index];
            return _FormCard(
              form: form,
              onDeactivate: () => _confirmDeactivate(context, form),
            );
          },
        ),
      );
    });
  }

  void _confirmDeactivate(BuildContext context, ApplicationForm form) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Deactivate Form'),
          content: Text(
            'Are you sure you want to deactivate the application form for "${form.propertyTitle}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                unawaited(controller.deactivateForm(form.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Deactivate'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.controller});

  final ApplicationsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Pending',
            value: controller.pendingCount.toString(),
            color: ApplicationStatus.pending.color,
          ),
          _StatItem(
            label: 'Review',
            value: controller.underReviewCount.toString(),
            color: ApplicationStatus.underReview.color,
          ),
          _StatItem(
            label: 'Approved',
            value: controller.approvedCount.toString(),
            color: ApplicationStatus.approved.color,
          ),
          _StatItem(
            label: 'Rejected',
            value: controller.rejectedCount.toString(),
            color: ApplicationStatus.rejected.color,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
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

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({
    required this.application,
    required this.onTap,
  });

  final Application application;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

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
                  CircleAvatar(
                    backgroundColor:
                        application.status.color.withValues(alpha: 0.1),
                    child: Text(
                      application.applicantName.isNotEmpty
                          ? application.applicantName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: application.status.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.applicantName,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          application.applicantEmail,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: application.status),
                ],
              ),
              if (application.propertyTitle != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.apartment,
                      size: 14,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        application.propertyTitle!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (application.submittedAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Applied ${dateFormat.format(application.submittedAt!)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.form,
    required this.onDeactivate,
  });

  final ApplicationForm form;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.description,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        form.propertyTitle ?? 'Application Form',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (form.propertyAddress != null)
                        Text(
                          form.propertyAddress!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (form.isExpired)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Expired',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: form.publicUrl));
                      Get.snackbar(
                        'Copied',
                        'Application link copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy Link'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDeactivate,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 12,
            color: status.color,
          ),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}
