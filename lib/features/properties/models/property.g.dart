// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyImpl _$$PropertyImplFromJson(Map<String, dynamic> json) =>
    _$PropertyImpl(
      id: parseInt(json['id']),
      name: json['name'] as String?,
      propertyName: json['property_name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      unitCount: parseInt(json['unit_count']),
      occupiedUnits: parseInt(json['occupied_units']),
      type: json['type'] as String?,
      floorAreaSqft: parseDouble(json['floor_area_sqft']),
      bedroomCount: parseInt(json['bedroom_count']),
      bathroomCount: parseInt(json['bathroom_count']),
      balconyCount: parseInt(json['balcony_count']),
      monthlyRentInr: parseDouble(json['monthly_rent_inr']),
      paymentDueDay: parseInt(json['payment_due_day']),
      managementStatus: json['management_status'] as String?,
      notes: json['notes'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      floorPlans: (json['floor_plans'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      marketValue: parseDouble(json['market_value']),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      yearBuilt: parseInt(json['year_built']),
      propertyTaxId: json['property_tax_id'] as String?,
      insurancePolicy: json['insurance_policy'] as String?,
      hoaInfo: json['hoa_info'] as String?,
      assignedManagerId: parseInt(json['assigned_manager_id']),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );

Map<String, dynamic> _$$PropertyImplToJson(_$PropertyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'property_name': instance.propertyName,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
      'unit_count': instance.unitCount,
      'occupied_units': instance.occupiedUnits,
      'type': instance.type,
      'floor_area_sqft': instance.floorAreaSqft,
      'bedroom_count': instance.bedroomCount,
      'bathroom_count': instance.bathroomCount,
      'balcony_count': instance.balconyCount,
      'monthly_rent_inr': instance.monthlyRentInr,
      'payment_due_day': instance.paymentDueDay,
      'management_status': instance.managementStatus,
      'notes': instance.notes,
      'images': instance.images,
      'floor_plans': instance.floorPlans,
      'market_value': instance.marketValue,
      'amenities': instance.amenities,
      'year_built': instance.yearBuilt,
      'property_tax_id': instance.propertyTaxId,
      'insurance_policy': instance.insurancePolicy,
      'hoa_info': instance.hoaInfo,
      'assigned_manager_id': instance.assignedManagerId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
