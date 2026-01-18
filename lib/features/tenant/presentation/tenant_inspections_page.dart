import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TenantInspectionsPage extends ConsumerWidget {
  const TenantInspectionsPage({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not scheduled';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authControllerProvider).user?.id?.toString();
    if (userId == null) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Inspections')),
        body: const AppEmptyView(
          title: 'No profile found',
          message: 'Sign in to view inspections.',
        ),
      );
    }

    final inspectionsAsync = ref.watch(
      inspectionsListProvider(InspectionListFilter(tenantId: userId)),
    );

    return AppScaffold(
      appBar: AppBar(title: const Text('Inspections')),
      padding: EdgeInsets.zero,
      body: inspectionsAsync.when(
        data: (inspections) {
          if (inspections.isEmpty) {
            return const AppEmptyView(
              title: 'No inspections yet',
              message: 'Your inspection requests will appear here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: inspections.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _InspectionTile(
                inspection: inspections[index],
                formattedDate: _formatDate(inspections[index].scheduledAt),
              );
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
  const _InspectionTile({
    required this.inspection,
    required this.formattedDate,
  });

  final Inspection inspection;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(inspection.displayName),
        subtitle: Text('${inspection.status ?? 'Open'} | $formattedDate'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            context.go('/tenant/profile/inspections/${inspection.id}'),
      ),
    );
  }
}
