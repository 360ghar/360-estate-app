import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/properties/data/amenities_repository.dart';
import 'package:estate_app/features/properties/data/properties_repository.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/models/amenity.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final propertiesRepositoryProvider = Provider<PropertiesRepository>((ref) {
  ref.watch(accountScopeProvider);
  return PropertiesRepositoryImpl(
    ref.read(apiClientProvider),
    ref.read(cacheStoreProvider),
  );
});

/// Every managed property of the account. For pickers and name lookups.
final propertiesListProvider = FutureProvider<List<Property>>((ref) {
  return ref.watch(propertiesRepositoryProvider).listAll();
});

/// Property titles by id, for screens that list leases, charges and
/// inspections: those payloads carry a property id and no title.
final propertyTitlesProvider = FutureProvider<Map<int, String>>((ref) async {
  final properties = await ref.watch(propertiesListProvider.future);
  return {
    for (final property in properties)
      if (property.id != null) property.id!: property.displayName,
  };
});

/// The server-side filters of the property list: the occupancy (null = all)
/// and the search text (`q`, matched against the title and the address).
typedef PropertyListQuery = ({OccupancyFilter? occupancy, String? q});

/// A page-by-page list. The family key is the server-side filters.
final propertiesPagedProvider =
    StateNotifierProvider.family<
      PagedListController<Property>,
      PagedListState<Property>,
      PropertyListQuery
    >((ref, query) {
      final repository = ref.watch(propertiesRepositoryProvider);
      return PagedListController<Property>(
        fetchPage: ({required cursor, required limit}) {
          return repository.listPage(
            cursor: cursor,
            limit: limit,
            occupancy: query.occupancy,
            q: query.q,
          );
        },
      );
    });

final propertyDetailProvider = FutureProvider.family<PropertyDetail, String>(
  (ref, id) => ref.watch(propertiesRepositoryProvider).fetch(id),
);

/// The amenity catalogue (`GET /amenities`). The ids go in `amenity_ids`.
final amenityCatalogProvider = FutureProvider<List<Amenity>>((ref) {
  return fetchAllPages<Amenity>(
    ({required cursor, required limit}) => ref
        .read(amenitiesRepositoryProvider)
        .listPage(cursor: cursor, limit: limit),
  );
});

final amenitiesRepositoryProvider = Provider<AmenitiesRepository>(
  (ref) => AmenitiesRepository(ref.read(apiClientProvider)),
);
