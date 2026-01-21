import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inspection.displayName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(inspection.status ?? 'Open'),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Schedule'),
        const SizedBox(height: AppSpacing.md),
        _InfoRow(label: 'Scheduled', value: formattedDate),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Checklist'),
        const SizedBox(height: AppSpacing.md),
        if (inspection.items == null || inspection.items!.isEmpty)
          const Text('No checklist items yet.'),
        if (inspection.items != null && inspection.items!.isNotEmpty)
          Column(
            children: inspection.items!
                .map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.title ?? 'Checklist item'),
                    subtitle: Text(item.status ?? 'Pending'),
                  ),
                )
                .toList(),
          ),
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
