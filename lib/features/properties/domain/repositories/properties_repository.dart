import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';

abstract interface class PropertiesRepository {
  Future<Page<Property>> getProperties({
    required int page,
    required int limit,
    required String query,
  });

  Future<Property> getPropertyById(int id);

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
    int monthlyRentInr = 0,
    double? securityDeposit,
    double? maintenanceCharges,
    String managementStatus = 'active',
    int paymentDueDay = 1,
    String? notes,
    List<String> images = const [],
  });

  Future<String> uploadPropertyImage(String filePath);

  Future<Property> updateProperty(int id, Map<String, dynamic> updates);

  Future<void> deleteProperty(int id);
}
