enum PropertyType {
  apartment,
  builderFloor,
  commercial,
  condo,
  flatmate,
  house,
  land,
  loft,
  office,
  other,
  penthouse,
  pg,
  plot,
  room,
  shop,
  studio,
  villa,
  warehouse,
}

enum PropertyCategory { residential, commercial }

enum ManagementStatus { active, inactive, sold }

final class Property {
  const Property({
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
  final PropertyType propertyType;
  final PropertyCategory propertyCategory;
  final int? bedroomCount;
  final int? bathroomCount;
  final int? balconyCount;
  final double? floorAreaSqft;
  final List<String> images;
  final ManagementStatus managementStatus;
  final int paymentDueDay;
  final String? notes;
  final int monthlyRentInr;
  final ActiveLease? activeLease;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayName => nickname ?? title;

  String get fullAddress {
    final parts = <String>[addressLine, city];
    if (state != null) parts.add(state!);
    if (pincode != null) parts.add(pincode!);
    return parts.join(', ');
  }

  bool get isOccupied => activeLease != null;
  bool get isVacant => activeLease == null;
}

final class ActiveLease {
  const ActiveLease({
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
  final DateTime? startDate;
  final DateTime? endDate;
  final double monthlyRent;
  final double? securityDeposit;
  final String? status;

  bool get isExpiringSoon {
    final end = endDate;
    if (end == null) return false;
    final daysUntilExpiry = end.difference(DateTime.now()).inDays;
    return daysUntilExpiry >= 0 && daysUntilExpiry <= 30;
  }
}
