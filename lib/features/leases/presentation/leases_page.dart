import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LeasesPage extends ConsumerWidget {
  const LeasesPage({super.key, this.propertyId, this.tenantId});

  final String? propertyId;
  final String? tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leasesAsync = ref.watch(
      leasesListProvider(
        LeaseListFilter(propertyId: propertyId, tenantId: tenantId),
      ),
    );

    return AppScaffold(
      appBar: AppBar(title: const Text('Leases')),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/leases/new'),
        icon: const Icon(Icons.post_add_outlined),
        label: const Text('New lease'),
      ),
      body: leasesAsync.when(
        data: (leases) {
          if (leases.isEmpty) {
            return const AppEmptyView(
              title: 'No leases yet',
              message: 'Create your first lease to begin tracking.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: leases.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _LeaseTile(lease: leases[index]);
            },
          );
        },
        loading: () => const AppLoadingShimmer(),
        error: (error, _) => AppErrorView(
          title: 'Unable to load leases',
          message: error.toString(),
          onRetry: () => ref.invalidate(leasesListProvider),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _LeaseTile extends StatelessWidget {
  const _LeaseTile({required this.lease});

  final Lease lease;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final start = _formatDate(lease.startDate);
    final end = _formatDate(lease.endDate);
    final status = lease.status ?? 'Active';

    return Card(
      child: ListTile(
        title: Text(lease.displayName),
        subtitle: Text('$status | $start - $end'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/more/leases/${lease.id}'),
      ),
    );
  }
}
