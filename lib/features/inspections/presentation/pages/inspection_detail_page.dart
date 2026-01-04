import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/inspections/domain/entities/inspection.dart';
import 'package:estate_app/features/inspections/presentation/controllers/inspection_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InspectionDetailPage extends StatelessWidget {
  const InspectionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InspectionDetailView();
  }
}

class _InspectionDetailView extends StatelessWidget {
  const _InspectionDetailView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InspectionDetailController>();
    final dateFormat = DateFormat('MMM d, yyyy');

    return Obx(() {
      final state = controller.state.value;

      return AppScaffold(
        appBar: AppBar(
          title: const Text('Inspection Details'),
          actions: [
            if (state.status == ViewStatus.success)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _editInspection(context, state.data!);
                  } else if (value == 'cancel') {
                    _confirmCancel(context, controller);
                  }
                },
                itemBuilder: (context) => [
                  if (state.data?.canCancel ?? false) ...[
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(Icons.cancel_outlined, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Cancel', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
        body: Builder(
          builder: (_) {
            switch (state.status) {
              case ViewStatus.idle:
              case ViewStatus.loading:
                return const Center(child: AppLoader());

              case ViewStatus.empty:
              case ViewStatus.error:
                return AppErrorView(
                  title: context.l10n.errorSomethingWentWrong,
                  message: state.failure?.localizedMessage(context.l10n) ??
                      'Failed to load inspection',
                  retryLabel: context.l10n.commonRetry,
                  onRetry: () => unawaited(controller.loadInspection()),
                );

              case ViewStatus.success:
                final inspection = state.data!;
                return _buildContent(
                  context,
                  inspection,
                  controller,
                  dateFormat,
                );
            }
          },
        ),
      );
    });
  }

  Widget _buildContent(
    BuildContext context,
    Inspection inspection,
    InspectionDetailController controller,
    DateFormat dateFormat,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Card
        _HeaderCard(inspection: inspection, dateFormat: dateFormat),
        const SizedBox(height: 16),

        // Status Actions
        if (inspection.canStart ||
            inspection.canComplete ||
            inspection.canSign)
          _ActionCard(inspection: inspection, controller: controller),

        // Property Info
        if (inspection.propertyTitle != null ||
            inspection.propertyAddress != null) ...[
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Property',
            children: [
              if (inspection.propertyTitle != null)
                _InfoRow(
                  icon: Icons.apartment,
                  label: 'Property',
                  value: inspection.propertyTitle!,
                ),
              if (inspection.propertyAddress != null)
                _InfoRow(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: inspection.propertyAddress!,
                ),
            ],
          ),
        ],

        // Details
        const SizedBox(height: 16),
        _InfoCard(
          title: 'Details',
          children: [
            _InfoRow(
              icon: Icons.category,
              label: 'Type',
              value: inspection.inspectionType.displayName,
            ),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Scheduled',
              value: dateFormat.format(inspection.scheduledDate),
            ),
            if (inspection.completedDate != null)
              _InfoRow(
                icon: Icons.check_circle,
                label: 'Completed',
                value: dateFormat.format(inspection.completedDate!),
              ),
            if (inspection.inspectorName != null)
              _InfoRow(
                icon: Icons.person,
                label: 'Inspector',
                value: inspection.inspectorName!,
              ),
            if (inspection.tenantName != null)
              _InfoRow(
                icon: Icons.person_outline,
                label: 'Tenant',
                value: inspection.tenantName!,
              ),
          ],
        ),

        // Signatures
        if (inspection.isPendingReview || inspection.isCompleted) ...[
          const SizedBox(height: 16),
          _SignaturesCard(inspection: inspection),
        ],

        // Notes
        if (inspection.notes != null && inspection.notes!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Notes',
            children: [
              Text(
                inspection.notes!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],

        // Inspection Items
        if (inspection.items.isNotEmpty) ...[
          const SizedBox(height: 16),
          _ItemsSection(inspection: inspection, controller: controller),
        ],

        const SizedBox(height: 80),
      ],
    );
  }

  void _editInspection(BuildContext context, Inspection inspection) {
    unawaited(Get.toNamed<Inspection>(
      Routes.inspectionCreate,
      arguments: {'inspection': inspection},
    ),);
  }

  void _confirmCancel(
    BuildContext context,
    InspectionDetailController controller,
  ) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Inspection'),
        content: const Text(
          'Are you sure you want to cancel this inspection?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              unawaited(controller.cancelInspection());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    ),);
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.inspection,
    required this.dateFormat,
  });

  final Inspection inspection;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: inspection.inspectionType.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              inspection.inspectionType.icon,
              color: inspection.inspectionType.color,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inspection.inspectionType.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: inspection.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        inspection.status.icon,
                        size: 14,
                        color: inspection.status.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        inspection.status.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: inspection.status.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.inspection,
    required this.controller,
  });

  final Inspection inspection;
  final InspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (inspection.canStart)
                  AppButton(
                    label: 'Start Inspection',
                    leading: const Icon(Icons.play_circle, size: 18),
                    isLoading: controller.isActionLoading.value,
                    onPressed: () => unawaited(controller.startInspection()),
                  ),
                if (inspection.canComplete)
                  AppButton(
                    label: 'Complete Inspection',
                    leading: const Icon(Icons.check_circle, size: 18),
                    isLoading: controller.isActionLoading.value,
                    onPressed: () =>
                        unawaited(controller.completeInspection()),
                  ),
                if (inspection.canSign && !inspection.isFullySigned) ...[
                  if (!inspection.hasTenantSignature)
                    AppButton(
                      label: 'Sign as Tenant',
                      leading: const Icon(Icons.draw, size: 18),
                      isLoading: controller.isActionLoading.value,
                      onPressed: () =>
                          _showSignatureDialog(context, controller, 'tenant'),
                    ),
                  if (inspection.hasTenantSignature &&
                      !inspection.hasLandlordSignature) ...[
                    const SizedBox(height: 8),
                    AppButton(
                      label: 'Sign as Landlord',
                      leading: const Icon(Icons.draw, size: 18),
                      isLoading: controller.isActionLoading.value,
                      onPressed: () =>
                          _showSignatureDialog(context, controller, 'landlord'),
                    ),
                  ],
                ],
              ],
            ),
          ),
      );
  }
}

void _showSignatureDialog(
  BuildContext context,
  InspectionDetailController controller,
  String type,
) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign as ${type == 'tenant' ? 'Tenant' : 'Landlord'}'),
        content: const Text(
          'By signing, you confirm that the inspection details are accurate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              unawaited(controller.signInspection(
                signatureType: type,
                signature: 'signed_${DateTime.now().millisecondsSinceEpoch}',
              ));
            },
            child: const Text('Confirm & Sign'),
          ),
        ],
      ),
    ));
  }

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturesCard extends StatelessWidget {
  const _SignaturesCard({required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Signatures',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _SignatureRow(
            label: 'Tenant',
            isSigned: inspection.hasTenantSignature,
          ),
          const SizedBox(height: 8),
          _SignatureRow(
            label: 'Landlord',
            isSigned: inspection.hasLandlordSignature,
          ),
        ],
      ),
    );
  }
}

class _SignatureRow extends StatelessWidget {
  const _SignatureRow({
    required this.label,
    required this.isSigned,
  });

  final String label;
  final bool isSigned;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isSigned ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isSigned ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSigned ? Colors.black : Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          isSigned ? 'Signed' : 'Pending',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSigned ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({
    required this.inspection,
    required this.controller,
  });

  final Inspection inspection;
  final InspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    // Group items by area
    final itemsByArea = <String, List<InspectionItem>>{};
    for (final item in inspection.items) {
      itemsByArea.putIfAbsent(item.area, () => []).add(item);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Inspection Items',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Text(
                '${inspection.itemsCount} items',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...itemsByArea.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ...entry.value.map((item) => _InspectionItemRow(item: item)),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _InspectionItemRow extends StatelessWidget {
  const _InspectionItemRow({required this.item});

  final InspectionItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.item,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: item.conditionColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.conditionDisplayName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: item.conditionColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
