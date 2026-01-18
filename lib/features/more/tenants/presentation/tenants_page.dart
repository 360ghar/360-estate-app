import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:estate_app/features/more/tenants/tenants_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TenantsPage extends ConsumerWidget {
  const TenantsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tenantsPagedProvider);
    final controller = ref.read(tenantsPagedProvider.notifier);

    return AppScaffold(
      appBar: AppBar(title: const Text('Tenants')),
      padding: EdgeInsets.zero,
      body: PagedListView<Tenant>(
        state: state,
        emptyTitle: 'No tenants',
        emptyMessage: 'Tenant directory will show up here.',
        onLoadMore: controller.loadMore,
        onRefresh: controller.refresh,
        onRetry: controller.loadInitial,
        itemBuilder: (context, tenant) => _TenantTile(tenant: tenant),
      ),
    );
  }
}

class _TenantTile extends StatelessWidget {
  const _TenantTile({required this.tenant});

  final Tenant tenant;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tenant.displayName),
        subtitle: Text(tenant.propertyName ?? 'Property not set'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/more/tenants/${tenant.id}'),
      ),
    );
  }
}
