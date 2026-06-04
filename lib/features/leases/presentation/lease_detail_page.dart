import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LeaseDetailPage extends ConsumerStatefulWidget {
  const LeaseDetailPage({super.key, required this.leaseId});

  final String leaseId;

  @override
  ConsumerState<LeaseDetailPage> createState() => _LeaseDetailPageState();
}

class _LeaseDetailPageState extends ConsumerState<LeaseDetailPage> {
  bool _isProcessing = false;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  AppStatusType _statusType(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppStatusType.success;
      case 'expired':
      case 'terminated':
        return AppStatusType.neutral;
      case 'expiring':
      case 'pending':
        return AppStatusType.warning;
      default:
        return AppStatusType.info;
    }
  }

  Future<void> _uploadSigned() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    setState(() => _isProcessing = true);
    try {
      await ref
          .read(leasesRepositoryProvider)
          .uploadSigned(widget.leaseId, File(path));
      ref.invalidate(leaseDetailProvider(widget.leaseId));
      ref.invalidate(leasesListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed lease uploaded.')),
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

  Future<void> _renewLease() async {
    final endDateController = TextEditingController();
    final rentController = TextEditingController();
    final request = await showDialog<LeaseRenewRequest>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Renew lease'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'New end date',
                  hintText: 'YYYY-MM-DD',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'New rent amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final endDate = DateTime.tryParse(
                  endDateController.text.trim(),
                );
                final rentAmount = double.tryParse(
                  rentController.text.trim(),
                );
                Navigator.of(context).pop(
                  LeaseRenewRequest(
                    newEndDate: endDate,
                    newRentAmount: rentAmount,
                  ),
                );
              },
              child: const Text('Renew'),
            ),
          ],
        );
      },
    );
    if (request == null) return;
    if (!mounted) return;
    if (request.newEndDate == null && request.newRentAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a new end date or rent amount.')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    try {
      await ref.read(leasesRepositoryProvider).renew(widget.leaseId, request);
      ref.invalidate(leaseDetailProvider(widget.leaseId));
      ref.invalidate(leasesListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lease renewed.')),
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

  Future<void> _terminateLease() async {
    final reasonController = TextEditingController();
    final request = await showDialog<LeaseTerminateRequest>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Terminate lease'),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Reason'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(
                  LeaseTerminateRequest(
                    reason: reasonController.text.trim(),
                    terminatedAt: DateTime.now(),
                  ),
                );
              },
              child: const Text('Terminate'),
            ),
          ],
        );
      },
    );
    if (request == null) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(leasesRepositoryProvider).terminate(widget.leaseId, request);
      ref.invalidate(leaseDetailProvider(widget.leaseId));
      ref.invalidate(leasesListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lease terminated.')),
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

  double _leaseProgress(Lease lease) {
    if (lease.startDate == null || lease.endDate == null) return 0;
    final now = DateTime.now();
    final total = lease.endDate!.difference(lease.startDate!).inDays;
    if (total <= 0) return 1;
    final elapsed = now.difference(lease.startDate!).inDays;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final leaseAsync = ref.watch(leaseDetailProvider(widget.leaseId));

    return AppScaffold(
      appBar: AppBar(title: const Text('Lease details')),
      scrollable: true,
      body: leaseAsync.when(
        data: (lease) {
          final textTheme = Theme.of(context).textTheme;
          final scheme = Theme.of(context).colorScheme;
          final status = lease.status ?? 'Active';
          final progress = _leaseProgress(lease);

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                AppCard(
                  variant: AppCardVariant.tinted,
                  tintColor: scheme.primary,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lease.displayName,
                              style: textTheme.headlineSmall,
                            ),
                          ),
                          AppStatusBadge(
                            label: status,
                            type: _statusType(status),
                            variant: AppStatusVariant.subtle,
                          ),
                        ],
                      ),
                      if (lease.tenantName != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          lease.tenantName!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Timeline section with visual progress bar
                AppSectionCard(
                  title: 'Timeline',
                  icon: Icons.date_range_outlined,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              _formatDate(lease.startDate),
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'End',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              _formatDate(lease.endDate),
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: AppRadii.pill,
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: AppColors.surfaceSecondary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 0.9
                                  ? AppColors.warning
                                  : AppColors.success,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${(progress * 100).toInt()}% elapsed',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Financials section
                AppSectionCard(
                  title: 'Financial Terms',
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.success,
                  children: [
                    // Rent amount - prominent
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: 0.08),
                            borderRadius: AppRadii.md,
                          ),
                          child: Icon(
                            Icons.payments_outlined,
                            size: 20,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Rent',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                lease.rentAmount != null
                                    ? '\u20B9${lease.rentAmount!.toStringAsFixed(0)}'
                                    : 'Not set',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Divider(
                      height: 1,
                      color: AppColors.cardBorder,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Deposit
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.08),
                            borderRadius: AppRadii.md,
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            size: 20,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Security Deposit',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                lease.depositAmount != null
                                    ? '\u20B9${lease.depositAmount!.toStringAsFixed(0)}'
                                    : 'Not set',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Document Upload
                AppSectionCard(
                  title: 'Document',
                  icon: Icons.description_outlined,
                  children: [
                    AppCard(
                      variant: AppCardVariant.outlined,
                      onTap: _isProcessing ? null : _uploadSigned,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSecondary,
                              borderRadius: AppRadii.md,
                            ),
                            child: Icon(
                              lease.signedDocumentUrl != null
                                  ? Icons.picture_as_pdf_outlined
                                  : Icons.upload_file_outlined,
                              size: 20,
                              color: lease.signedDocumentUrl != null
                                  ? AppColors.danger
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lease.signedDocumentUrl != null
                                      ? 'Signed Lease Agreement'
                                      : 'Upload Signed PDF',
                                  style: textTheme.titleSmall,
                                ),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  lease.signedDocumentUrl != null
                                      ? 'Tap to replace document'
                                      : 'PDF format only',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Actions section
                AppSectionCard(
                  title: 'Actions',
                  icon: Icons.settings_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isProcessing ? null : _renewLease,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Renew'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isProcessing ? null : _terminateLease,
                            icon: Icon(
                              Icons.cancel_outlined,
                              size: 18,
                              color: _isProcessing ? null : AppColors.danger,
                            ),
                            label: Text(
                              'Terminate',
                              style: TextStyle(
                                color: _isProcessing ? null : AppColors.danger,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: _isProcessing
                                  ? null
                                  : const BorderSide(color: AppColors.danger),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
        loading: () => const AppLoadingShimmer(itemCount: 3),
        error: (error, _) => AppErrorView(
          title: 'Unable to load lease',
          message: error.toString(),
          onRetry: () => ref.invalidate(leaseDetailProvider(widget.leaseId)),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}
