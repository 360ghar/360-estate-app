import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/models/property.dart';

abstract interface class PropertiesRepository {
  /// One page of the owner's managed properties. [occupancy] filters on the
  /// server: an occupying lease (active or expiring soon) makes a property
  /// occupied. [q] searches the title and the address on the server.
  Future<Page<Property>> listPage({
    required String? cursor,
    required int limit,
    OccupancyFilter? occupancy,
    String? q,
  });

  /// Every managed property (follows `next_cursor`).
  Future<List<Property>> listAll();

  /// The property and the lease that occupies it.
  Future<PropertyDetail> fetch(String id);

  /// Creates a managed property from a `ManagedPropertyCreate` body.
  Future<Property> create(Map<String, dynamic> body);

  /// Updates a managed property with a `ManagedPropertyUpdate` body. Send only
  /// the keys that changed. An explicit null clears a nullable field.
  Future<Property> update(String id, Map<String, dynamic> body);
}
