import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InspectionsPage extends ConsumerWidget {
  const InspectionsPage({super.key, this.propertyId, this.tenantId});

  final String? propertyId;
  final String? tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionsAsync = ref.watch(
      inspectionsListProvider(
        InspectionListFilter(propertyId: propertyId, tenantId: tenantId),
      ),
    );

    return AppScaffold(
      appBar: AppBar(title: const Text('Inspections')),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/inspections/new'),
        icon: const Icon(Icons.playlist_add),
        label: const Text('New inspection'),
      ),
      body: inspectionsAsync.when(
        data: (inspections) {
          if (inspections.isEmpty) {
            return const AppEmptyView(
              title: 'No inspections yet',
              message: 'Create a checklist to start an inspection.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: inspections.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _InspectionTile(inspection: inspections[index]);
            },
          );
        },
        loading: () => const AppLoadingShimmer(),
        error: (error, _) => AppErrorView(
          title: 'Unable to load inspections',
          message: error.toString(),
          onRetry: () => ref.invalidate(inspectionsListProvider),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _InspectionTile extends StatelessWidget {
  const _InspectionTile({required this.inspection});

  final Inspection inspection;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not scheduled';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final status = inspection.status ?? 'Open';
    final scheduled = _formatDate(inspection.scheduledAt);

    return Card(
      child: ListTile(
        title: Text(inspection.displayName),
        subtitle: Text('$status | $scheduled'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/more/inspections/${inspection.id}'),
      ),
    );
  }
}
