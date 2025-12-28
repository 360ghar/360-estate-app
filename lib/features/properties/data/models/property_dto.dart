import 'package:estate_app/features/properties/domain/entities/property.dart';

final class PropertyDto {
  const PropertyDto({
    required this.id,
    required this.title,
    this.nickname,
    required this.addressLine,
    required this.city,
    this.state,
    this.pincode,
    this.country = 'India',
    required this.propertyType,
    required this.propertyCategory,
    this.bedroomCount,
    this.bathroomCount,
    this.balconyCount,
    this.floorAreaSqft,
    this.images = const [],
    required this.managementStatus,
    this.paymentDueDay = 1,
    this.notes,
    this.monthlyRentInr = 0,
    this.activeLease,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String title;
  final String? nickname;
  final String addressLine;
  final String city;
  final String? state;
  final String? pincode;
  final String country;
  final String propertyType;
  final String propertyCategory;
  final int? bedroomCount;
  final int? bathroomCount;
  final int? balconyCount;
  final double? floorAreaSqft;
  final List<String> images;
  final String managementStatus;
  final int paymentDueDay;
  final String? notes;
  final int monthlyRentInr;
  final ActiveLeaseDto? activeLease;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PropertyDto.fromJson(Map<String, dynamic> json) {
    final id = _parseInt(json['id'] ?? json['property_id']);
    final title = (json['title'] ?? json['name'] ?? '').toString();
    final nickname = json['nickname'] as String?;
    final addressLine = (json['address_line'] ?? json['address'] ?? '').toString();
    final city = (json['city'] ?? json['town'] ?? '').toString();
    final state = json['state'] as String?;
    final pincode = (json['pincode'] ?? json['postal_code'])?.toString();
    final country = (json['country'] ?? 'India').toString();

    final propertyType = (json['property_type'] ?? 'apartment').toString();
    final propertyCategory = (json['property_category'] ?? 'residential').toString();

    final bedroomCount = _parseIntOrNull(json['bedroom_count'] ?? json['bedrooms']);
    final bathroomCount = _parseIntOrNull(json['bathroom_count'] ?? json['bathrooms']);
    final balconyCount = _parseIntOrNull(json['balcony_count'] ?? json['balconies']);
    final floorAreaSqft = _parseDoubleOrNull(json['floor_area_sqft'] ?? json['area']);

    final rawImages = json['images'];
    final images = <String>[];
    if (rawImages is List) {
      for (final img in rawImages) {
        if (img is String) {
          images.add(img);
        } else if (img is Map<String, dynamic>) {
          final url = img['url'] as String?;
          if (url != null) images.add(url);
        }
      }
    }

    final managementStatus = (json['management_status'] ?? 'active').toString();
    final paymentDueDay = _parseInt(json['payment_due_day'] ?? 1);
    final notes = json['notes'] as String?;
    final monthlyRentInr = _parseInt(json['monthly_rent_inr'] ?? json['rent'] ?? 0);

    final activeLeaseJson = json['active_lease'];
    final activeLease = activeLeaseJson is Map<String, dynamic>
        ? ActiveLeaseDto.fromJson(activeLeaseJson)
        : null;

    final createdAt = _parseDateTime(json['created_at']);
    final updatedAt = _parseDateTime(json['updated_at']);

    return PropertyDto(
      id: id,
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
      images: images,
      managementStatus: managementStatus,
      paymentDueDay: paymentDueDay,
      notes: notes,
      monthlyRentInr: monthlyRentInr,
      activeLease: activeLease,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    if (nickname != null) 'nickname': nickname,
    'address_line': addressLine,
    'city': city,
    if (state != null) 'state': state,
    if (pincode != null) 'pincode': pincode,
    'country': country,
    'property_type': propertyType,
    'property_category': propertyCategory,
    if (bedroomCount != null) 'bedroom_count': bedroomCount,
    if (bathroomCount != null) 'bathroom_count': bathroomCount,
    if (balconyCount != null) 'balcony_count': balconyCount,
    if (floorAreaSqft != null) 'floor_area_sqft': floorAreaSqft,
    'management_status': managementStatus,
    'payment_due_day': paymentDueDay,
    if (notes != null) 'notes': notes,
  };

  Property toEntity() => Property(
    id: id,
    title: title,
    nickname: nickname,
    addressLine: addressLine,
    city: city,
    state: state,
    pincode: pincode,
    country: country,
    propertyType: _parsePropertyType(propertyType),
    propertyCategory: _parsePropertyCategory(propertyCategory),
    bedroomCount: bedroomCount,
    bathroomCount: bathroomCount,
    balconyCount: balconyCount,
    floorAreaSqft: floorAreaSqft,
    images: images,
    managementStatus: _parseManagementStatus(managementStatus),
    paymentDueDay: paymentDueDay,
    notes: notes,
    monthlyRentInr: monthlyRentInr,
    activeLease: activeLease?.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _parseIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static PropertyType _parsePropertyType(String value) {
    return switch (value.toLowerCase()) {
      'apartment' => PropertyType.apartment,
      'house' => PropertyType.house,
      'villa' => PropertyType.villa,
      'commercial' => PropertyType.commercial,
      'land' => PropertyType.land,
      _ => PropertyType.other,
    };
  }

  static PropertyCategory _parsePropertyCategory(String value) {
    return switch (value.toLowerCase()) {
      'commercial' => PropertyCategory.commercial,
      _ => PropertyCategory.residential,
    };
  }

  static ManagementStatus _parseManagementStatus(String value) {
    return switch (value.toLowerCase()) {
      'inactive' => ManagementStatus.inactive,
      'sold' => ManagementStatus.sold,
      _ => ManagementStatus.active,
    };
  }
}

final class ActiveLeaseDto {
  const ActiveLeaseDto({
    required this.id,
    required this.tenantName,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    this.securityDeposit,
    this.status,
  });

  final int id;
  final String tenantName;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyRent;
  final double? securityDeposit;
  final String? status;

  factory ActiveLeaseDto.fromJson(Map<String, dynamic> json) {
    return ActiveLeaseDto(
      id: PropertyDto._parseInt(json['id'] ?? json['lease_id']),
      tenantName: (json['tenant_name'] ?? json['tenant']?['name'] ?? '').toString(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      monthlyRent: PropertyDto._parseDoubleOrNull(json['monthly_rent']) ?? 0,
      securityDeposit: PropertyDto._parseDoubleOrNull(json['security_deposit']),
      status: json['status'] as String?,
    );
  }

  ActiveLease toEntity() => ActiveLease(
    id: id,
    tenantName: tenantName,
    startDate: startDate,
    endDate: endDate,
    monthlyRent: monthlyRent,
    securityDeposit: securityDeposit,
    status: status,
  );
}
