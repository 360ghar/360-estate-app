import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart';

@freezed
class Property with _$Property {
  const factory Property({
    @JsonKey(fromJson: parseInt) int? id,
    String? name,
    @JsonKey(name: 'property_name') String? propertyName,
    String? address,
    String? city,
    String? state,
    @JsonKey(name: 'pincode') String? pincode,
    @JsonKey(name: 'unit_count', fromJson: parseInt) int? unitCount,
    @JsonKey(name: 'occupied_units', fromJson: parseInt) int? occupiedUnits,
    String? type,
    @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble) double? floorAreaSqft,
    @JsonKey(name: 'bedroom_count', fromJson: parseInt) int? bedroomCount,
    @JsonKey(name: 'bathroom_count', fromJson: parseInt) int? bathroomCount,
    @JsonKey(name: 'balcony_count', fromJson: parseInt) int? balconyCount,
    @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble) double? monthlyRentInr,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) int? paymentDueDay,
    @JsonKey(name: 'management_status') String? managementStatus,
    String? notes,
    // New fields
    @JsonKey(name: 'images') List<String>? images,
    @JsonKey(name: 'floor_plans') List<String>? floorPlans,
    @JsonKey(name: 'market_value', fromJson: parseDouble) double? marketValue,
    @JsonKey(name: 'amenities') List<String>? amenities,
    @JsonKey(name: 'year_built', fromJson: parseInt) int? yearBuilt,
    @JsonKey(name: 'property_tax_id') String? propertyTaxId,
    @JsonKey(name: 'insurance_policy') String? insurancePolicy,
    @JsonKey(name: 'hoa_info') String? hoaInfo,
    @JsonKey(name: 'assigned_manager_id', fromJson: parseInt) int? assignedManagerId,
    @JsonKey(name: 'latitude', fromJson: parseDouble) double? latitude,
    @JsonKey(name: 'longitude', fromJson: parseDouble) double? longitude,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
}

extension PropertyX on Property {
  String get displayName => name ?? propertyName ?? 'Property';

  String get fullAddress {
    final parts = [address, city, state]
        .where((value) => value != null && value.trim().isNotEmpty)
        .map((value) => value!.trim())
        .toList();
    if (pincode != null && pincode!.trim().isNotEmpty) {
      parts.add(pincode!.trim());
    }
    return parts.isEmpty ? 'Address not set' : parts.join(', ');
  }

  /// Get display text for property type
  String get typeDisplay {
    switch (type?.toLowerCase()) {
      case '1rk':
        return '1RK';
      case '1bhk':
        return '1BHK';
      case '2bhk':
        return '2BHK';
      case '3bhk':
        return '3BHK';
      case 'pg':
        return 'PG';
      case 'commercial':
        return 'Commercial';
      default:
        return type?.toUpperCase() ?? 'OTHER';
    }
  }

  /// Get display text for management status
  String get statusDisplay {
    switch (managementStatus?.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'sold':
        return 'Sold';
      default:
        return 'Unknown';
    }
  }

  /// Check if property is active
  bool get isActive => managementStatus?.toLowerCase() == 'active';

  /// Check if property is occupied (has occupied units)
  bool get isOccupied {
    return occupiedUnits != null && occupiedUnits! > 0;
  }

  /// Get occupancy rate (0.0 to 1.0)
  double get occupancyRate {
    if (unitCount == null || unitCount! == 0) return 0.0;
    final occupied = occupiedUnits ?? 0;
    return occupied / unitCount!;
  }
}

/// Common property types
const propertyTypes = [
  'apartment',
  'house',
  'builder_floor',
  'room',
];

/// Common property amenities
const commonAmenities = [
  'Parking',
  'Swimming Pool',
  'Gym',
  'Lift',
  'Power Backup',
  'Security',
  'Water Supply',
  'Garden',
  'Club House',
  'AC',
  'WiFi',
  'Furnished',
];
