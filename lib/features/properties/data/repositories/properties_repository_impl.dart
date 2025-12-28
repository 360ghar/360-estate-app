import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:estate_app/features/properties/data/models/property_dto.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';

final class PropertiesRepositoryImpl implements PropertiesRepository {
  PropertiesRepositoryImpl({
    required PropertiesRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final PropertiesRemoteDataSource _dataSource;

  @override
  Future<Page<Property>> getProperties({
    required int page,
    required int limit,
    required String query,
  }) async {
    final dtoPage = await _dataSource.getProperties(
      page: page,
      limit: limit,
      query: query,
    );

    return Page<Property>(
      items: dtoPage.items.map((d) => d.toEntity()).toList(growable: false),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<Property> getPropertyById(int id) async {
    final dto = await _dataSource.getPropertyById(id);
    return dto.toEntity();
  }

  @override
  Future<Property> createProperty({
    required String title,
    String? nickname,
    required String addressLine,
    required String city,
    String? state,
    String? pincode,
    String country = 'India',
    required String propertyType,
    required String propertyCategory,
    int? bedroomCount,
    int? bathroomCount,
    int? balconyCount,
    double? floorAreaSqft,
    String managementStatus = 'active',
    int paymentDueDay = 1,
    String? notes,
  }) async {
    final dto = PropertyDto(
      id: 0, // Will be assigned by server
      title: title,
      nickname: nickname,
      addressLine: addressLine,
      city: city,
      state: state,
      pincode: pincode,
      country: country,
      propertyType: propertyType,
      propertyCategory: propertyCategory,
      bedroomCount: bedroomCount,
      bathroomCount: bathroomCount,
      balconyCount: balconyCount,
      floorAreaSqft: floorAreaSqft,
      managementStatus: managementStatus,
      paymentDueDay: paymentDueDay,
      notes: notes,
    );

    final result = await _dataSource.createProperty(dto);
    return result.toEntity();
  }

  @override
  Future<Property> updateProperty(int id, Map<String, dynamic> updates) async {
    final dto = await _dataSource.updateProperty(id, updates);
    return dto.toEntity();
  }

  @override
  Future<void> deleteProperty(int id) async {
    await _dataSource.deleteProperty(id);
  }
}
