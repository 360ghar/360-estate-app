// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyImageImpl _$$PropertyImageImplFromJson(Map<String, dynamic> json) =>
    _$PropertyImageImpl(
      id: parseInt(json['id']),
      imageUrl: json['image_url'] as String?,
      caption: json['caption'] as String?,
      imageCategory: json['image_category'] as String?,
      displayOrder: parseInt(json['display_order']),
      isMainImage: json['is_main_image'] as bool?,
    );

Map<String, dynamic> _$$PropertyImageImplToJson(_$PropertyImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'caption': instance.caption,
      'image_category': instance.imageCategory,
      'display_order': instance.displayOrder,
      'is_main_image': instance.isMainImage,
    };

_$PropertyAmenityImpl _$$PropertyAmenityImplFromJson(
  Map<String, dynamic> json,
) => _$PropertyAmenityImpl(
  id: parseInt(json['id']),
  title: json['title'] as String?,
  icon: json['icon'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$$PropertyAmenityImplToJson(
  _$PropertyAmenityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'icon': instance.icon,
  'category': instance.category,
};

_$PropertyImpl _$$PropertyImplFromJson(Map<String, dynamic> json) =>
    _$PropertyImpl(
      id: parseInt(json['id']),
      ownerId: parseInt(json['owner_id']),
      title: json['title'] as String?,
      description: json['description'] as String?,
      propertyType: PropertyType.fromJson(json['property_type']),
      purpose: PropertyPurpose.fromJson(json['purpose']),
      listingStatus: PropertyStatus.fromJson(json['status']),
      basePrice: parseDouble(json['base_price']),
      monthlyRent: parseDouble(json['monthly_rent']),
      securityDeposit: parseDouble(json['security_deposit']),
      maintenanceCharges: parseDouble(json['maintenance_charges']),
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      locality: json['locality'] as String?,
      fullAddress: json['full_address'] as String?,
      areaSqft: parseDouble(json['area_sqft']),
      bedrooms: parseInt(json['bedrooms']),
      bathrooms: parseInt(json['bathrooms']),
      balconies: parseInt(json['balconies']),
      ageOfProperty: parseInt(json['age_of_property']),
      furnishingLevel: FurnishingLevel.fromJson(json['furnishing_level']),
      isAvailable: json['is_available'] as bool?,
      isManaged: json['is_managed'] as bool?,
      managementStatus: ManagedPropertyStatus.fromJson(
        json['management_status'],
      ),
      paymentDueDay: parseInt(json['payment_due_day']),
      gracePeriodDays: parseInt(json['grace_period_days']),
      lateFeePolicy: json['late_fee_policy'] as Map<String, dynamic>?,
      currentLeaseId: parseInt(json['current_lease_id']),
      currentTenantId: parseInt(json['current_tenant_id']),
      mainImageUrl: json['main_image_url'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => PropertyImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      floorPlans: (json['floor_plans'] as List<dynamic>?)
          ?.map((e) => PropertyImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => PropertyAmenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      ownerName: json['owner_name'] as String?,
      ownerContact: json['owner_contact'] as String?,
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );

Map<String, dynamic> _$$PropertyImplToJson(_$PropertyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'title': instance.title,
      'description': instance.description,
      'property_type': PropertyType.toJsonValue(instance.propertyType),
      'purpose': PropertyPurpose.toJsonValue(instance.purpose),
      'status': PropertyStatus.toJsonValue(instance.listingStatus),
      'base_price': instance.basePrice,
      'monthly_rent': instance.monthlyRent,
      'security_deposit': instance.securityDeposit,
      'maintenance_charges': instance.maintenanceCharges,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
      'locality': instance.locality,
      'full_address': instance.fullAddress,
      'area_sqft': instance.areaSqft,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'balconies': instance.balconies,
      'age_of_property': instance.ageOfProperty,
      'furnishing_level': FurnishingLevel.toJsonValue(instance.furnishingLevel),
      'is_available': instance.isAvailable,
      'is_managed': instance.isManaged,
      'management_status': ManagedPropertyStatus.toJsonValue(
        instance.managementStatus,
      ),
      'payment_due_day': instance.paymentDueDay,
      'grace_period_days': instance.gracePeriodDays,
      'late_fee_policy': instance.lateFeePolicy,
      'current_lease_id': instance.currentLeaseId,
      'current_tenant_id': instance.currentTenantId,
      'main_image_url': instance.mainImageUrl,
      'images': instance.images,
      'floor_plans': instance.floorPlans,
      'amenities': instance.amenities,
      'owner_name': instance.ownerName,
      'owner_contact': instance.ownerContact,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$PropertyDetailImpl _$$PropertyDetailImplFromJson(Map<String, dynamic> json) =>
    _$PropertyDetailImpl(
      property: Property.fromJson(json['property'] as Map<String, dynamic>),
      activeLease: json['active_lease'] == null
          ? null
          : Lease.fromJson(json['active_lease'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PropertyDetailImplToJson(
  _$PropertyDetailImpl instance,
) => <String, dynamic>{
  'property': instance.property,
  'active_lease': instance.activeLease,
};
