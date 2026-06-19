import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/more/tenants/data/tenants_repository.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tenantsRepositoryProvider = Provider<TenantsRepository>((ref) {
  return TenantsRepository(
    ref.read(apiClientProvider),
    ref.read(cacheStoreProvider),
  );
});

final tenantsListProvider = FutureProvider<List<Tenant>>((ref) {
  return ref.read(tenantsRepositoryProvider).list();
});

final tenantsPagedProvider =
    StateNotifierProvider<PagedListController<Tenant>, PagedListState<Tenant>>(
  (ref) => PagedListController<Tenant>(
    fetchPage: ({required cursor, required limit}) {
      return ref.read(tenantsRepositoryProvider).listPage(
            cursor: cursor,
            limit: limit,
          );
    },
  ),
);

final tenantDetailProvider = FutureProvider.family<Tenant, String>(
  (ref, id) => ref.read(tenantsRepositoryProvider).fetch(id),
);
