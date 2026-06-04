import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InspectionDetailPage extends ConsumerStatefulWidget {
  const InspectionDetailPage({
    super.key,
    required this.inspectionId,
    this.allowSign = false,
  });

  final String inspectionId;
  final bool allowSign;

  @override
  ConsumerState<InspectionDetailPage> createState() =>
      _InspectionDetailPageState();
}

class _InspectionDetailPageState extends ConsumerState<InspectionDetailPage> {
  bool _isProcessing = false;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  Future<void> _signInspection() async {
    setState(() => _isProcessing = true);
    try {
      await ref
          .read(inspectionsRepositoryProvider)
          .sign(widget.inspectionId);
      ref.invalidate(inspectionDetailProvider(widget.inspectionId));
      ref.invalidate(inspectionsListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inspection signed.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspectionAsync = ref.watch(
      inspectionDetailProvider(widget.inspectionId),
    );

    return AppScaffold(
      appBar: AppBar(title: const Text('Inspection details')),
      body: inspectionAsync.when(
        data: (inspection) => _InspectionDetail(
          inspection: inspection,
          formattedDate: _formatDate(inspection.scheduledAt),
          allowSign: widget.allowSign,
          isProcessing: _isProcessing,
          onSign: _signInspection,
        ),
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load inspection',
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(inspectionDetailProvider(widget.inspectionId)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _InspectionDetail extends StatelessWidget {
  const _InspectionDetail({
    required this.inspection,
    required this.formattedDate,
    required this.allowSign,
    required this.isProcessing,
    required this.onSign,
  });

  final Inspection inspection;
  final String formattedDate;
  final bool allowSign;
  final bool isProcessing;
  final VoidCallback onSign;

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'signed':
        return AppStatusType.success;
      case 'in_progress':
      case 'in progress':
        return AppStatusType.warning;
      case 'cancelled':
      case 'canceled':
        return AppStatusType.danger;
      case 'scheduled':
        return AppStatusType.info;
      case 'open':
      default:
        return AppStatusType.neutral;
    }
  }

  Color _itemStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pass':
      case 'passed':
      case 'good':
      case 'completed':
        return AppColors.success;
      case 'fail':
      case 'failed':
      case 'poor':
        return AppColors.danger;
      case 'fair':
      case 'needs_attention':
      case 'warning':
        return AppColors.warning;
      case 'pending':
      default:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final status = inspection.status ?? 'Open';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and status header
        Text(
          inspection.displayName,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppStatusBadge(
          label: status,
          type: _statusType(status),
          variant: AppStatusVariant.subtle,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Schedule section
        AppSectionCard(
          title: 'Schedule',
          icon: Icons.calendar_today_outlined,
          iconColor: AppColors.info,
          children: [
            _InfoRow(label: 'Scheduled', value: formattedDate),
            if (inspection.signedAt != null)
              _InfoRow(
                label: 'Signed',
                value: DateFormat('d MMM yyyy').format(inspection.signedAt!),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Property Details section
        if (inspection.propertyName != null || inspection.tenantName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: AppSectionCard(
              title: 'Property Details',
              icon: Icons.home_outlined,
              iconColor: AppColors.primary,
              children: [
                if (inspection.propertyName != null)
                  _InfoRow(
                    label: 'Property',
                    value: inspection.propertyName!,
                  ),
                if (inspection.tenantName != null)
                  _InfoRow(
                    label: 'Tenant',
                    value: inspection.tenantName!,
                  ),
              ],
            ),
          ),

        // Checklist section
        AppSectionCard(
          title: 'Checklist Items',
          icon: Icons.checklist_outlined,
          iconColor: AppColors.warning,
          children: [
            if (inspection.items == null || inspection.items!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  'No checklist items yet.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            if (inspection.items != null && inspection.items!.isNotEmpty)
              ...inspection.items!.asMap().entries.map(
                (entry) {
                  final item = entry.value;
                  final isLast = entry.key == inspection.items!.length - 1;
                  final statusColor = _itemStatusColor(item.status);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status dot indicator
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title ?? 'Checklist item',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (item.status != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.xxs,
                                      ),
                                      child: Text(
                                        item.status!,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  if (item.notes != null &&
                                      item.notes!.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.xxs,
                                      ),
                                      child: Text(
                                        item.notes!,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (item.isRequired == true)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: AppSpacing.sm),
                                child: Text(
                                  'Required',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: AppColors.cardBorder,
                        ),
                    ],
                  );
                },
              ),
          ],
        ),

        // Sign button
        if (allowSign) ...[
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isProcessing ? null : onSign,
              icon: const Icon(Icons.edit_document),
              label: const Text('Sign inspection'),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
