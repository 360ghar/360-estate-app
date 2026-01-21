import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/properties/data/properties_repository.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final propertiesRepositoryProvider = Provider<PropertiesRepository>((ref) {
  final userId = ref.watch(
    authControllerProvider.select(
      (state) => state.user?.id?.toString() ?? 'anon',
    ),
  );
  return PropertiesRepositoryImpl(
    ref.read(apiClientProvider),
    ref.read(cacheStoreProvider),
    cacheScope: userId,
  );
});

final propertiesListProvider = FutureProvider<List<Property>>((ref) {
  return ref.watch(propertiesRepositoryProvider).list(limit: 200);
});

final propertiesPagedProvider =
    StateNotifierProvider<PagedListController<Property>, PagedListState<Property>>(
  (ref) {
    final repository = ref.watch(propertiesRepositoryProvider);
    return PagedListController<Property>(
      fetchPage: ({required page, required limit}) {
        return repository.listPage(
          page: page,
          limit: limit,
        );
      },
    );
  },
);

final propertyDetailProvider = FutureProvider.family<Property, String>(
  (ref, id) => ref.watch(propertiesRepositoryProvider).fetch(id),
);
