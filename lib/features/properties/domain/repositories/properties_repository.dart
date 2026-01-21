import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/properties/models/property.dart';

abstract interface class PropertiesRepository {
  /// List properties with pagination
  Future<Page<Property>> listPage({
    required int page,
    required int limit,
  });

  /// Get a property by ID
  Future<Property> fetch(String id);

  /// Create a new property
  Future<Property> create(PropertyPayload payload);

  /// Update an existing property
  Future<Property> update(String id, PropertyPayload payload);

  /// Delete a property
  Future<void> delete(String id);

  /// List all properties (convenience method)
  Future<List<Property>> list({int limit});
}

/// Payload for creating/updating a property
class PropertyPayload {
  const PropertyPayload({
    this.name,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.unitCount,
    this.type,
    this.floorAreaSqft,
    this.bedroomCount,
    this.bathroomCount,
    this.balconyCount,
    this.monthlyRentInr,
    this.paymentDueDay,
    this.managementStatus,
    this.notes,
    // New fields
    this.images,
    this.floorPlans,
    this.marketValue,
    this.amenities,
    this.yearBuilt,
    this.propertyTaxId,
    this.insurancePolicy,
    this.hoaInfo,
    this.assignedManagerId,
  });

  final String? name;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final int? unitCount;
  final String? type;
  final double? floorAreaSqft;
  final int? bedroomCount;
  final int? bathroomCount;
  final int? balconyCount;
  final double? monthlyRentInr;
  final int? paymentDueDay;
  final String? managementStatus;
  final String? notes;
  // New fields
  final List<String>? images;
  final List<String>? floorPlans;
  final double? marketValue;
  final List<String>? amenities;
  final int? yearBuilt;
  final String? propertyTaxId;
  final String? insurancePolicy;
  final String? hoaInfo;
  final int? assignedManagerId;

  /// Create PropertyPayload from JSON
  factory PropertyPayload.fromJson(Map<String, dynamic> json) {
    return PropertyPayload(
      name: json['name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      unitCount: json['unit_count'] as int?,
      type: json['type'] as String?,
      floorAreaSqft: (json['floor_area_sqft'] as num?)?.toDouble(),
      bedroomCount: json['bedroom_count'] as int?,
      bathroomCount: json['bathroom_count'] as int?,
      balconyCount: json['balcony_count'] as int?,
      monthlyRentInr: (json['monthly_rent_inr'] as num?)?.toDouble(),
      paymentDueDay: json['payment_due_day'] as int?,
      managementStatus: json['management_status'] as String?,
      notes: json['notes'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      floorPlans: (json['floor_plans'] as List<dynamic>?)?.cast<String>(),
      marketValue: (json['market_value'] as num?)?.toDouble(),
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>(),
      yearBuilt: json['year_built'] as int?,
      propertyTaxId: json['property_tax_id'] as String?,
      insurancePolicy: json['insurance_policy'] as String?,
      hoaInfo: json['hoa_info'] as String?,
      assignedManagerId: json['assigned_manager_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      payload['name'] = trimmedName;
      payload['title'] = trimmedName;
    }
    if (address != null && address!.trim().isNotEmpty) {
      payload['address'] = address!.trim();
    }
    if (city != null && city!.trim().isNotEmpty) {
      payload['city'] = city!.trim();
    }
    if (state != null && state!.trim().isNotEmpty) {
      payload['state'] = state!.trim();
    }
    if (pincode != null && pincode!.trim().isNotEmpty) {
      payload['pincode'] = pincode!.trim();
    }
    if (unitCount != null) {
      payload['unit_count'] = unitCount;
    }
    final trimmedType = type?.trim();
    if (trimmedType != null && trimmedType.isNotEmpty) {
      payload['type'] = trimmedType;
      final normalizedType = _normalizePropertyType(trimmedType);
      if (normalizedType != null) {
        payload['property_type'] = normalizedType;
      }
      final purpose = _derivePurpose(trimmedType);
      if (purpose != null) {
        payload['purpose'] = purpose;
      }
      final category = _deriveCategory(trimmedType);
      if (category != null) {
        payload['property_category'] = category;
      }
    }
    if (floorAreaSqft != null) {
      payload['floor_area_sqft'] = floorAreaSqft;
    }
    if (bedroomCount != null) {
      payload['bedroom_count'] = bedroomCount;
    }
    if (bathroomCount != null) {
      payload['bathroom_count'] = bathroomCount;
    }
    if (balconyCount != null) {
      payload['balcony_count'] = balconyCount;
    }
    if (monthlyRentInr != null) {
      payload['monthly_rent_inr'] = monthlyRentInr;
    }
    final basePrice = monthlyRentInr ?? marketValue;
    if (basePrice != null) {
      payload['base_price'] = basePrice;
    }
    if (paymentDueDay != null) {
      payload['payment_due_day'] = paymentDueDay;
    }
    if (managementStatus != null && managementStatus!.trim().isNotEmpty) {
      payload['management_status'] = managementStatus!.trim();
    }
    if (notes != null && notes!.trim().isNotEmpty) {
      payload['notes'] = notes!.trim();
    }
    // New fields
    if (images != null && images!.isNotEmpty) {
      payload['images'] = images;
    }
    if (floorPlans != null && floorPlans!.isNotEmpty) {
      payload['floor_plans'] = floorPlans;
    }
    if (marketValue != null) {
      payload['market_value'] = marketValue;
    }
    if (amenities != null && amenities!.isNotEmpty) {
      payload['amenities'] = amenities;
    }
    if (yearBuilt != null) {
      payload['year_built'] = yearBuilt;
    }
    if (propertyTaxId != null && propertyTaxId!.trim().isNotEmpty) {
      payload['property_tax_id'] = propertyTaxId!.trim();
    }
    if (insurancePolicy != null && insurancePolicy!.trim().isNotEmpty) {
      payload['insurance_policy'] = insurancePolicy!.trim();
    }
    if (hoaInfo != null && hoaInfo!.trim().isNotEmpty) {
      payload['hoa_info'] = hoaInfo!.trim();
    }
    if (assignedManagerId != null) {
      payload['assigned_manager_id'] = assignedManagerId;
    }
    return payload;
  }
}

String? _normalizePropertyType(String raw) {
  final value = raw.trim().toLowerCase();
  if (value.isEmpty) return null;
  switch (value) {
    case 'builder_floor':
    case 'builder floor':
    case 'floor':
    case 'commercial':
    case 'office':
    case 'shop':
    case 'warehouse':
    case 'land':
      return 'builder_floor';
    case 'pg':
    case '1rk':
    case 'room':
      return 'room';
    case '1bhk':
    case '2bhk':
    case '3bhk':
    case '4bhk':
    case 'flat':
    case 'apartment':
      return 'apartment';
    case 'villa':
      return 'house';
    case 'house':
      return 'house';
    default:
      return 'apartment';
  }
}

String? _derivePurpose(String raw) {
  final value = raw.trim().toLowerCase();
  if (value.isEmpty) return null;
  return 'rent';
}

String? _deriveCategory(String raw) {
  final value = raw.trim().toLowerCase();
  if (value.isEmpty) return null;
  if (value == 'commercial' ||
      value == 'office' ||
      value == 'shop' ||
      value == 'warehouse') {
    return 'commercial';
  }
  return 'residential';
}
