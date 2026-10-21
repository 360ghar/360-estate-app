import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart';

/// One photo or floor plan of a property (`PropertyImage`).
@freezed
class PropertyImage with _$PropertyImage {
  const factory PropertyImage({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? caption,
    @JsonKey(name: 'image_category') String? imageCategory,
    @JsonKey(name: 'display_order', fromJson: parseInt) int? displayOrder,
    @JsonKey(name: 'is_main_image') bool? isMainImage,
  }) = _PropertyImage;

  factory PropertyImage.fromJson(Map<String, dynamic> json) =>
      _$PropertyImageFromJson(json);
}

/// An amenity of a property (`PropertyAmenityResponse`). `id` is the amenity
/// id: the value that goes back in `amenity_ids`.
@freezed
class PropertyAmenity with _$PropertyAmenity {
  const factory PropertyAmenity({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? icon,
    String? category,
  }) = _PropertyAmenity;

  factory PropertyAmenity.fromJson(Map<String, dynamic> json) =>
      _$PropertyAmenityFromJson(json);
}

/// A managed property as the backend sends it (`Property`).
///
/// Wire names are the backend names: `title`, `property_type`, `full_address`,
/// `description`, `area_sqft`, `bedrooms`, `bathrooms`, `balconies`,
/// `monthly_rent`. Fields the backend does not have (unit count, market
/// value, year built, tax, insurance, HOA, manager) are not modelled.
@freezed
class Property with _$Property {
  const factory Property({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    String? title,
    String? description,
    @JsonKey(
      name: 'property_type',
      fromJson: PropertyType.fromJson,
      toJson: PropertyType.toJsonValue,
    )
    PropertyType? propertyType,
    @JsonKey(
      fromJson: PropertyPurpose.fromJson,
      toJson: PropertyPurpose.toJsonValue,
    )
    PropertyPurpose? purpose,
    @JsonKey(
      name: 'status',
      fromJson: PropertyStatus.fromJson,
      toJson: PropertyStatus.toJsonValue,
    )
    PropertyStatus? listingStatus,
    @JsonKey(name: 'base_price', fromJson: parseDouble) double? basePrice,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble) double? monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    double? securityDeposit,
    @JsonKey(name: 'maintenance_charges', fromJson: parseDouble)
    double? maintenanceCharges,
    @JsonKey(fromJson: parseDouble) double? latitude,
    @JsonKey(fromJson: parseDouble) double? longitude,
    String? city,
    String? state,
    String? pincode,
    String? locality,
    @JsonKey(name: 'full_address') String? fullAddress,
    @JsonKey(name: 'area_sqft', fromJson: parseDouble) double? areaSqft,
    @JsonKey(fromJson: parseInt) int? bedrooms,
    @JsonKey(fromJson: parseInt) int? bathrooms,
    @JsonKey(fromJson: parseInt) int? balconies,
    @JsonKey(name: 'age_of_property', fromJson: parseInt) int? ageOfProperty,
    @JsonKey(
      name: 'furnishing_level',
      fromJson: FurnishingLevel.fromJson,
      toJson: FurnishingLevel.toJsonValue,
    )
    FurnishingLevel? furnishingLevel,
    @JsonKey(name: 'is_available') bool? isAvailable,
    @JsonKey(name: 'is_managed') bool? isManaged,
    @JsonKey(
      name: 'management_status',
      fromJson: ManagedPropertyStatus.fromJson,
      toJson: ManagedPropertyStatus.toJsonValue,
    )
    ManagedPropertyStatus? managementStatus,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) int? paymentDueDay,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    int? gracePeriodDays,
    @JsonKey(name: 'late_fee_policy') Map<String, dynamic>? lateFeePolicy,
    @JsonKey(name: 'current_lease_id', fromJson: parseInt) int? currentLeaseId,
    @JsonKey(name: 'current_tenant_id', fromJson: parseInt)
    int? currentTenantId,
    @JsonKey(name: 'main_image_url') String? mainImageUrl,
    List<PropertyImage>? images,
    @JsonKey(name: 'floor_plans') List<PropertyImage>? floorPlans,
    List<PropertyAmenity>? amenities,
    @JsonKey(name: 'owner_name') String? ownerName,
    // The owner's number for the owner and admins only. Anyone else gets the
    // assigned agent's number, else the company number, else null.
    @JsonKey(name: 'owner_contact') String? ownerContact,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
}

/// `GET /pm/properties/{id}`: the property and the lease that occupies it
/// (`ManagedPropertyDetail`).
@freezed
class PropertyDetail with _$PropertyDetail {
  const factory PropertyDetail({
    required Property property,
    @JsonKey(name: 'active_lease') Lease? activeLease,
  }) = _PropertyDetail;

  factory PropertyDetail.fromJson(Map<String, dynamic> json) =>
      _$PropertyDetailFromJson(json);
}

extension PropertyX on Property {
  String get displayName {
    final value = title?.trim();
    return value == null || value.isEmpty ? 'Property' : value;
  }

  /// The address as one line: the street line, then locality, city, state and
  /// pincode, without repeats.
  String get addressLine {
    final parts = <String>[];
    for (final value in [fullAddress, locality, city, state, pincode]) {
      final text = value?.trim();
      if (text == null || text.isEmpty) continue;
      final lower = text.toLowerCase();
      if (parts.any((part) => part.toLowerCase().contains(lower))) continue;
      parts.add(text);
    }
    return parts.isEmpty ? 'Address not set' : parts.join(', ');
  }

  /// City, state and pincode, for the line under the title.
  String? get cityLine {
    final parts = [city, state, pincode]
        .map((value) => value?.trim())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toList();
    return parts.isEmpty ? null : parts.join(', ');
  }

  String get typeDisplay => propertyType?.label ?? 'Other';

  String get statusDisplay => managementStatus?.label ?? 'Unknown';

  bool get isActive => managementStatus == ManagedPropertyStatus.active;

  /// An occupying lease (active or expiring soon) is linked to the property.
  bool get isOccupied => currentLeaseId != null;

  List<String> get imageUrls => [
    for (final image in images ?? const <PropertyImage>[])
      if (image.imageUrl != null && image.imageUrl!.isNotEmpty) image.imageUrl!,
  ];

  List<String> get floorPlanUrls => [
    for (final image in floorPlans ?? const <PropertyImage>[])
      if (image.imageUrl != null && image.imageUrl!.isNotEmpty) image.imageUrl!,
  ];

  /// The cover photo: the main image, else the first photo.
  String? get coverImageUrl {
    final main = mainImageUrl?.trim();
    if (main != null && main.isNotEmpty) return main;
    final urls = imageUrls;
    return urls.isEmpty ? null : urls.first;
  }

  List<String> get amenityTitles => [
    for (final amenity in amenities ?? const <PropertyAmenity>[])
      if (amenity.title != null && amenity.title!.isNotEmpty) amenity.title!,
  ];
}

extension PropertyTypeLabel on PropertyType {
  String get label => switch (this) {
    PropertyType.house => 'House',
    PropertyType.apartment => 'Apartment',
    PropertyType.builderFloor => 'Builder floor',
    PropertyType.room => 'Room',
    PropertyType.villa => 'Villa',
    PropertyType.plot => 'Plot',
    PropertyType.condo => 'Condo',
    PropertyType.penthouse => 'Penthouse',
    PropertyType.studio => 'Studio',
    PropertyType.loft => 'Loft',
    PropertyType.pg => 'PG',
    PropertyType.flatmate => 'Flatmate',
    PropertyType.office => 'Office',
    PropertyType.shop => 'Shop',
    PropertyType.warehouse => 'Warehouse',
  };
}

extension ManagedPropertyStatusLabel on ManagedPropertyStatus {
  String get label => switch (this) {
    ManagedPropertyStatus.draft => 'Draft',
    ManagedPropertyStatus.active => 'Active',
    ManagedPropertyStatus.archived => 'Archived',
  };
}
