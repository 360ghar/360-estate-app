import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/more/tenants/data/tenants_repository.dart';
import 'package:estate_app/features/more/tenants/models/tenant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tenantsRepositoryProvider = Provider<TenantsRepository>((ref) {
  ref.watch(accountScopeProvider);
  return TenantsRepository(
    ref.read(apiClientProvider),
    ref.read(cacheStoreProvider),
  );
});

/// The tenant list, one page at a time (`limit` 20, the backend maximum is
/// 100).
final tenantsPagedProvider =
    StateNotifierProvider<PagedListController<Tenant>, PagedListState<Tenant>>((
      ref,
    ) {
      final repository = ref.watch(tenantsRepositoryProvider);
      return PagedListController<Tenant>(
        fetchPage: ({required cursor, required limit}) {
          return repository.listPage(cursor: cursor, limit: limit);
        },
      );
    });

/// A tenant by `user_id`.
final tenantDetailProvider = FutureProvider.family<Tenant, int>(
  (ref, userId) => ref.watch(tenantsRepositoryProvider).fetch(userId),
);
