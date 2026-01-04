/// Mock implementation of PropertiesRemoteDataSource for development/demo mode.
library;

import 'package:estate_app/core/mocks/mock_data_factory.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:estate_app/features/properties/data/models/property_dto.dart';

final class MockPropertiesRemoteDataSource implements PropertiesRemoteDataSource {
  MockPropertiesRemoteDataSource();

  // Local mutable copy of properties for CRUD operations
  final List<Map<String, dynamic>> _properties = 
      List<Map<String, dynamic>>.from(MockDataFactory.properties);

  int _nextId = 100; // Start IDs at 100 for new properties

  @override
  Future<Page<PropertyDto>> getProperties({
    required int page,
    required int limit,
    required String query,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _properties.toList();

    // Apply search filter
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered.where((p) {
        final title = (p['title'] as String? ?? '').toLowerCase();
        final city = (p['city'] as String? ?? '').toLowerCase();
        final address = (p['address_line'] as String? ?? '').toLowerCase();
        return title.contains(q) || city.contains(q) || address.contains(q);
      }).toList();
    }

    // Paginate
    final offset = (page - 1) * limit;
    final paged = filtered.skip(offset).take(limit).toList();
    final hasMore = offset + paged.length < filtered.length;

    final items = paged.map(PropertyDto.fromJson).toList();

    return Page<PropertyDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<PropertyDto> getPropertyById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final property = _properties.firstWhere(
      (p) => p['id'] == id,
      orElse: () => throw Exception('Property not found: $id'),
    );

    return PropertyDto.fromJson(property);
  }

  @override
  Future<PropertyDto> createProperty(PropertyDto property) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now().toIso8601String();
    final newProperty = {
      'id': _nextId++,
      'title': property.title,
      'nickname': property.nickname,
      'address_line': property.addressLine,
      'city': property.city,
      'state': property.state,
      'pincode': property.pincode,
      'country': property.country,
      'property_type': property.propertyType,
      'property_category': property.propertyCategory,
      'bedroom_count': property.bedroomCount,
      'bathroom_count': property.bathroomCount,
      'balcony_count': property.balconyCount,
      'floor_area_sqft': property.floorAreaSqft,
      'images': property.images,
      'management_status': property.managementStatus,
      'payment_due_day': property.paymentDueDay,
      'notes': property.notes,
      'monthly_rent_inr': property.monthlyRentInr,
      'security_deposit': property.securityDeposit,
      'maintenance_charges': property.maintenanceCharges,
      'active_lease': null,
      'created_at': now,
      'updated_at': now,
    };

    _properties.insert(0, newProperty);
    return PropertyDto.fromJson(newProperty);
  }

  @override
  Future<PropertyDto> updateProperty(int id, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _properties.indexWhere((p) => p['id'] == id);
    if (index == -1) {
      throw Exception('Property not found: $id');
    }

    final updated = Map<String, dynamic>.from(_properties[index]);
    updates.forEach((key, value) {
      // Convert camelCase to snake_case for storage
      final snakeKey = key.replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => '_${m.group(0)!.toLowerCase()}',
      );
      updated[snakeKey] = value;
    });
    updated['updated_at'] = DateTime.now().toIso8601String();

    _properties[index] = updated;
    return PropertyDto.fromJson(updated);
  }

  @override
  Future<void> deleteProperty(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _properties.indexWhere((p) => p['id'] == id);
    if (index == -1) {
      throw Exception('Property not found: $id');
    }

    _properties.removeAt(index);
  }

  @override
  Future<String> uploadPropertyImage(String path) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return a mock URL
    return 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/800/600';
  }
}
