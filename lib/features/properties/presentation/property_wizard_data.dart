import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:flutter/foundation.dart' show listEquals;

/// Form state of the property wizard. The steps edit the fields in place.
///
/// The request bodies use the backend names (`ManagedPropertyCreate` and
/// `ManagedPropertyUpdate`): `title`, `description`, `property_type`,
/// `monthly_rent`, `full_address`, `area_sqft`, `bedrooms`, `bathrooms`,
/// `balconies`, `amenity_ids`, `latitude`, `longitude`, `payment_due_day`,
/// `grace_period_days`, `management_status`.
class PropertyWizardData {
  PropertyWizardData();

  /// Populate from an existing property (edit).
  factory PropertyWizardData.fromProperty(Property property) {
    final data = PropertyWizardData()
      ..name = property.title ?? ''
      ..type = property.propertyType
      // A property saved with a status the app does not know keeps no choice.
      ..status = property.managementStatus ?? ManagedPropertyStatus.active
      ..description = property.description ?? ''
      ..address = property.fullAddress ?? ''
      ..city = property.city ?? ''
      ..state = property.state ?? ''
      ..pincode = property.pincode ?? ''
      ..latitude = property.latitude
      ..longitude = property.longitude
      ..areaSqft = property.areaSqft
      ..bedrooms = property.bedrooms
      ..bathrooms = property.bathrooms
      ..balconies = property.balconies
      ..ageOfProperty = property.ageOfProperty
      ..amenityIds = {
        for (final amenity in property.amenities ?? const <PropertyAmenity>[])
          if (amenity.id != null) amenity.id!,
      }
      ..monthlyRent = property.monthlyRent ?? property.basePrice
      ..securityDeposit = property.securityDeposit
      ..paymentDueDay = property.paymentDueDay ?? 1
      ..gracePeriodDays = property.gracePeriodDays ?? 5
      ..images = property.imageUrls
      ..floorPlans = property.floorPlanUrls;
    return data..markSaved();
  }

  // Step 1: Basic details
  String name = '';
  PropertyType? type;
  ManagedPropertyStatus status = ManagedPropertyStatus.active;
  String description = '';

  // Step 2: Location
  String address = '';
  String city = '';
  String state = '';
  String pincode = '';
  double? latitude;
  double? longitude;

  /// The place the user picked on the location screen, for display only.
  String? locationName;

  // Step 3: Specifications
  double? areaSqft;
  int? bedrooms;
  int? bathrooms;
  int? balconies;
  int? ageOfProperty;
  Set<int> amenityIds = <int>{};

  // Step 4: Rent
  double? monthlyRent;
  double? securityDeposit;
  int paymentDueDay = 1;
  int gracePeriodDays = 5;

  // Step 5: Media. Stored URLs, plus `file:` URIs of pictures not uploaded yet.
  List<String> images = [];
  List<String> floorPlans = [];

  Map<String, dynamic>? _baseline;
  List<String> _baselineImages = const [];
  List<String> _baselineFloorPlans = const [];

  /// Records the field values as saved and leaves the photo baselines alone,
  /// so a photo removed in the same save is still sent by [mediaPatch].
  void markFieldsSaved() => _baseline = _fields();

  /// Records the current values as the saved state. A later [toPatchBody] sends
  /// only what changed after this point.
  void markSaved({List<String>? savedImages, List<String>? savedFloorPlans}) {
    _baseline = _fields();
    _baselineImages = List<String>.of(savedImages ?? remoteImages);
    _baselineFloorPlans = List<String>.of(savedFloorPlans ?? remoteFloorPlans);
  }

  static bool isLocalFile(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.scheme == 'file';
  }

  List<String> get remoteImages =>
      images.where((u) => !isLocalFile(u)).toList();
  List<String> get remoteFloorPlans =>
      floorPlans.where((u) => !isLocalFile(u)).toList();

  static String? _text(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Every editable field by wire name. A cleared optional field is null.
  Map<String, dynamic> _fields() {
    return {
      'title': name.trim(),
      'description': _text(description),
      'property_type': type?.wire,
      // A managed property is a rental. `base_price` is the rent.
      'purpose': PropertyPurpose.rent.wire,
      'base_price': monthlyRent,
      'monthly_rent': monthlyRent,
      'security_deposit': securityDeposit,
      'management_status': status.wire,
      'payment_due_day': paymentDueDay,
      'grace_period_days': gracePeriodDays,
      'full_address': _text(address),
      'city': _text(city),
      'state': _text(state),
      'pincode': _text(pincode),
      'latitude': latitude,
      'longitude': longitude,
      'area_sqft': areaSqft,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'balconies': balconies,
      'age_of_property': ageOfProperty,
      'amenity_ids': (amenityIds.toList()..sort()),
    };
  }

  /// The `POST /pm/properties` body (`ManagedPropertyCreate`): set fields only.
  /// An agent's `owner_id` is added by the API client.
  Map<String, dynamic> toCreateBody() {
    return {
      for (final entry in _fields().entries)
        if (entry.value != null) entry.key: entry.value,
    };
  }

  /// The `PATCH /pm/properties/{id}` body (`ManagedPropertyUpdate`): only the
  /// keys that changed since [markSaved]. A cleared optional field is sent as
  /// an explicit null. Without a saved state every set field is sent.
  Map<String, dynamic> toPatchBody() {
    final baseline = _baseline;
    final body = <String, dynamic>{};
    for (final entry in _fields().entries) {
      if (baseline != null && _same(entry.value, baseline[entry.key])) {
        continue;
      }
      if (baseline == null && entry.value == null) continue;
      body[entry.key] = entry.value;
    }
    // The point is built only when both coordinates are present.
    if (body.containsKey('latitude') || body.containsKey('longitude')) {
      if (latitude != null && longitude != null) {
        body['latitude'] = latitude;
        body['longitude'] = longitude;
      } else if (latitude == null && longitude == null) {
        // Both cleared: the explicit nulls stay.
      } else {
        body.remove('latitude');
        body.remove('longitude');
      }
    }
    return body;
  }

  /// The media keys of the PATCH: `images` replaces the photos and
  /// `floor_plans` replaces the floor plans. A key is present only when its
  /// list differs from the saved list.
  Map<String, dynamic> mediaPatch({
    required List<String> photoUrls,
    required List<String> floorPlanUrls,
  }) {
    return {
      if (!listEquals(photoUrls, _baselineImages)) 'images': photoUrls,
      if (!listEquals(floorPlanUrls, _baselineFloorPlans))
        'floor_plans': floorPlanUrls,
    };
  }

  static bool _same(Object? a, Object? b) {
    if (a is List && b is List) return listEquals<Object?>(a, b);
    return a == b;
  }

  /// What blocks [step] (1 to 5). The screen shows each issue under its
  /// field. Step 4: the due day is 1 to 28 and the grace period 0 to 365 (the
  /// backend refuses other values).
  List<WizardIssue> issues(int step) => switch (step) {
    1 => [
      if (name.trim().isEmpty) WizardIssue.name,
      if (type == null) WizardIssue.type,
    ],
    2 => [if (city.trim().isEmpty) WizardIssue.city],
    4 => [
      if (monthlyRent == null || monthlyRent! <= 0) WizardIssue.rent,
      if (paymentDueDay < 1 || paymentDueDay > 28) WizardIssue.dueDay,
      if (gracePeriodDays < 0 || gracePeriodDays > 365) WizardIssue.grace,
    ],
    _ => const [],
  };
}

/// A field the wizard cannot move past.
enum WizardIssue { name, type, city, rent, dueDay, grace }
