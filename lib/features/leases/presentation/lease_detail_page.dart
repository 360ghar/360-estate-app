import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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

  @override
  Widget build(BuildContext context) {
    final leaseAsync = ref.watch(leaseDetailProvider(widget.leaseId));

    return AppScaffold(
      appBar: AppBar(title: const Text('Lease details')),
      body: leaseAsync.when(
        data: (lease) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lease.displayName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(lease.status ?? 'Active'),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Timeline'),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                label: 'Start date',
                value: _formatDate(lease.startDate),
              ),
              _InfoRow(
                label: 'End date',
                value: _formatDate(lease.endDate),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Financials'),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                label: 'Rent',
                value: lease.rentAmount?.toStringAsFixed(0) ?? 'Not set',
              ),
              _InfoRow(
                label: 'Deposit',
                value: lease.depositAmount?.toStringAsFixed(0) ?? 'Not set',
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Actions'),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _uploadSigned,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Upload signed PDF'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _renewLease,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Renew'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _terminateLease,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Terminate'),
                  ),
                ],
              ),
            ],
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
