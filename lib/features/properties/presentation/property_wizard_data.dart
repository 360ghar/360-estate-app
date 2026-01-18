import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/models/property.dart';

/// Data model for property wizard form state.
class PropertyWizardData {
  // Step 1: Basic Details
  String? name;
  String? type;
  String? managementStatus;
  String? notes;

  // Step 2: Location
  String? address;
  String? city;
  String? state;
  String? pincode;

  // Step 3: Specifications
  int? unitCount;
  double? floorAreaSqft;
  int? bedroomCount;
  int? bathroomCount;
  int? balconyCount;
  int? yearBuilt;
  List<String>? amenities;

  // Step 4: Financial & Management
  double? monthlyRentInr;
  int? paymentDueDay;
  double? marketValue;
  String? assignedManagerId;
  String? propertyTaxId;
  String? insurancePolicy;
  String? hoaInfo;

  // Step 5: Media (URLs after upload)
  List<String> images;
  List<String> floorPlans;

  PropertyWizardData({
    this.name,
    this.type,
    this.managementStatus = 'active',
    this.notes,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.unitCount,
    this.floorAreaSqft,
    this.bedroomCount,
    this.bathroomCount,
    this.balconyCount,
    this.yearBuilt,
    this.amenities,
    this.monthlyRentInr,
    this.paymentDueDay = 1,
    this.marketValue,
    this.assignedManagerId,
    this.propertyTaxId,
    this.insurancePolicy,
    this.hoaInfo,
    List<String>? images,
    List<String>? floorPlans,
  })  : images = images ?? [],
        floorPlans = floorPlans ?? [];

  /// Populate from existing Property.
  factory PropertyWizardData.fromProperty(Property property) {
    return PropertyWizardData(
      name: property.name ?? property.propertyName,
      type: property.type,
      managementStatus: property.managementStatus ?? 'active',
      notes: property.notes,
      address: property.address,
      city: property.city,
      state: property.state,
      pincode: property.pincode,
      unitCount: property.unitCount,
      floorAreaSqft: property.floorAreaSqft,
      bedroomCount: property.bedroomCount,
      bathroomCount: property.bathroomCount,
      balconyCount: property.balconyCount,
      yearBuilt: property.yearBuilt,
      amenities: property.amenities,
      monthlyRentInr: property.monthlyRentInr,
      paymentDueDay: property.paymentDueDay ?? 1,
      marketValue: property.marketValue,
      assignedManagerId: property.assignedManagerId?.toString(),
      propertyTaxId: property.propertyTaxId,
      insurancePolicy: property.insurancePolicy,
      hoaInfo: property.hoaInfo,
      images: property.images ?? [],
      floorPlans: property.floorPlans ?? [],
    );
  }

  /// Convert to PropertyPayload for API submission.
  PropertyPayload toPayload() {
    return PropertyPayload(
      name: name?.trim() ?? '',
      address: address?.trim(),
      city: city?.trim(),
      state: state?.trim(),
      pincode: pincode?.trim(),
      unitCount: unitCount,
      type: type,
      floorAreaSqft: floorAreaSqft,
      bedroomCount: bedroomCount,
      bathroomCount: bathroomCount,
      balconyCount: balconyCount,
      monthlyRentInr: monthlyRentInr,
      paymentDueDay: paymentDueDay ?? 1,
      managementStatus: managementStatus ?? 'active',
      notes: notes?.trim(),
      images: images.isEmpty ? null : images,
      floorPlans: floorPlans.isEmpty ? null : floorPlans,
      marketValue: marketValue,
      amenities: amenities?.isEmpty ?? true
          ? null
          : amenities,
      yearBuilt: yearBuilt,
      propertyTaxId: propertyTaxId?.trim(),
      insurancePolicy: insurancePolicy?.trim(),
      hoaInfo: hoaInfo?.trim(),
      assignedManagerId: int.tryParse(assignedManagerId ?? ''),
    );
  }

  /// Validate step 1 (Basic Details).
  String? validateStep1() {
    if (name == null || name!.trim().isEmpty) {
      return 'Please enter a property name';
    }
    if (type == null || type!.trim().isEmpty) {
      return 'Please select a property type';
    }
    return null;
  }

  /// Validate step 2 (Location).
  String? validateStep2() {
    if (city == null || city!.trim().isEmpty) {
      return 'Please enter a city';
    }
    return null;
  }

  /// Step 3 has no required fields.
  String? validateStep3() => null;

  /// Step 4 requires base price.
  String? validateStep4() {
    if (monthlyRentInr == null && marketValue == null) {
      return 'Please enter a base price';
    }
    return null;
  }

  /// Step 5 has no required fields.
  String? validateStep5() => null;

  /// Check if a step is valid.
  String? validateStep(int step) {
    return switch (step) {
      1 => validateStep1(),
      2 => validateStep2(),
      3 => validateStep3(),
      4 => validateStep4(),
      5 => validateStep5(),
      _ => null,
    };
  }

  /// Create a copy with updated fields.
  PropertyWizardData copyWith({
    String? name,
    String? type,
    String? managementStatus,
    String? notes,
    String? address,
    String? city,
    String? state,
    String? pincode,
    int? unitCount,
    double? floorAreaSqft,
    int? bedroomCount,
    int? bathroomCount,
    int? balconyCount,
    int? yearBuilt,
    List<String>? amenities,
    double? monthlyRentInr,
    int? paymentDueDay,
    double? marketValue,
    String? assignedManagerId,
    String? propertyTaxId,
    String? insurancePolicy,
    String? hoaInfo,
    List<String>? images,
    List<String>? floorPlans,
  }) {
    return PropertyWizardData(
      name: name ?? this.name,
      type: type ?? this.type,
      managementStatus: managementStatus ?? this.managementStatus,
      notes: notes ?? this.notes,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      unitCount: unitCount ?? this.unitCount,
      floorAreaSqft: floorAreaSqft ?? this.floorAreaSqft,
      bedroomCount: bedroomCount ?? this.bedroomCount,
      bathroomCount: bathroomCount ?? this.bathroomCount,
      balconyCount: balconyCount ?? this.balconyCount,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      amenities: amenities ?? this.amenities,
      monthlyRentInr: monthlyRentInr ?? this.monthlyRentInr,
      paymentDueDay: paymentDueDay ?? this.paymentDueDay,
      marketValue: marketValue ?? this.marketValue,
      assignedManagerId: assignedManagerId ?? this.assignedManagerId,
      propertyTaxId: propertyTaxId ?? this.propertyTaxId,
      insurancePolicy: insurancePolicy ?? this.insurancePolicy,
      hoaInfo: hoaInfo ?? this.hoaInfo,
      images: images ?? this.images,
      floorPlans: floorPlans ?? this.floorPlans,
    );
  }
}
