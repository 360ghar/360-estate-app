// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Property _$PropertyFromJson(Map<String, dynamic> json) {
  return _Property.fromJson(json);
}

/// @nodoc
mixin _$Property {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'pincode')
  String? get pincode => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_count', fromJson: parseInt)
  int? get unitCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'occupied_units', fromJson: parseInt)
  int? get occupiedUnits => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble)
  double? get floorAreaSqft => throw _privateConstructorUsedError;
  @JsonKey(name: 'bedroom_count', fromJson: parseInt)
  int? get bedroomCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'bathroom_count', fromJson: parseInt)
  int? get bathroomCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'balcony_count', fromJson: parseInt)
  int? get balconyCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble)
  double? get monthlyRentInr => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  int? get paymentDueDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'management_status')
  String? get managementStatus => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // New fields
  @JsonKey(name: 'images')
  List<String>? get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_plans')
  List<String>? get floorPlans => throw _privateConstructorUsedError;
  @JsonKey(name: 'market_value', fromJson: parseDouble)
  double? get marketValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'amenities')
  List<String>? get amenities => throw _privateConstructorUsedError;
  @JsonKey(name: 'year_built', fromJson: parseInt)
  int? get yearBuilt => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_tax_id')
  String? get propertyTaxId => throw _privateConstructorUsedError;
  @JsonKey(name: 'insurance_policy')
  String? get insurancePolicy => throw _privateConstructorUsedError;
  @JsonKey(name: 'hoa_info')
  String? get hoaInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_manager_id', fromJson: parseInt)
  int? get assignedManagerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitude', fromJson: parseDouble)
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitude', fromJson: parseDouble)
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Property to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyCopyWith<Property> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyCopyWith<$Res> {
  factory $PropertyCopyWith(Property value, $Res Function(Property) then) =
      _$PropertyCopyWithImpl<$Res, Property>;
  @useResult
  $Res call({
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
    @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble)
    double? floorAreaSqft,
    @JsonKey(name: 'bedroom_count', fromJson: parseInt) int? bedroomCount,
    @JsonKey(name: 'bathroom_count', fromJson: parseInt) int? bathroomCount,
    @JsonKey(name: 'balcony_count', fromJson: parseInt) int? balconyCount,
    @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble)
    double? monthlyRentInr,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) int? paymentDueDay,
    @JsonKey(name: 'management_status') String? managementStatus,
    String? notes,
    @JsonKey(name: 'images') List<String>? images,
    @JsonKey(name: 'floor_plans') List<String>? floorPlans,
    @JsonKey(name: 'market_value', fromJson: parseDouble) double? marketValue,
    @JsonKey(name: 'amenities') List<String>? amenities,
    @JsonKey(name: 'year_built', fromJson: parseInt) int? yearBuilt,
    @JsonKey(name: 'property_tax_id') String? propertyTaxId,
    @JsonKey(name: 'insurance_policy') String? insurancePolicy,
    @JsonKey(name: 'hoa_info') String? hoaInfo,
    @JsonKey(name: 'assigned_manager_id', fromJson: parseInt)
    int? assignedManagerId,
    @JsonKey(name: 'latitude', fromJson: parseDouble) double? latitude,
    @JsonKey(name: 'longitude', fromJson: parseDouble) double? longitude,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  });
}

/// @nodoc
class _$PropertyCopyWithImpl<$Res, $Val extends Property>
    implements $PropertyCopyWith<$Res> {
  _$PropertyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? propertyName = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? unitCount = freezed,
    Object? occupiedUnits = freezed,
    Object? type = freezed,
    Object? floorAreaSqft = freezed,
    Object? bedroomCount = freezed,
    Object? bathroomCount = freezed,
    Object? balconyCount = freezed,
    Object? monthlyRentInr = freezed,
    Object? paymentDueDay = freezed,
    Object? managementStatus = freezed,
    Object? notes = freezed,
    Object? images = freezed,
    Object? floorPlans = freezed,
    Object? marketValue = freezed,
    Object? amenities = freezed,
    Object? yearBuilt = freezed,
    Object? propertyTaxId = freezed,
    Object? insurancePolicy = freezed,
    Object? hoaInfo = freezed,
    Object? assignedManagerId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            pincode: freezed == pincode
                ? _value.pincode
                : pincode // ignore: cast_nullable_to_non_nullable
                      as String?,
            unitCount: freezed == unitCount
                ? _value.unitCount
                : unitCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            occupiedUnits: freezed == occupiedUnits
                ? _value.occupiedUnits
                : occupiedUnits // ignore: cast_nullable_to_non_nullable
                      as int?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            floorAreaSqft: freezed == floorAreaSqft
                ? _value.floorAreaSqft
                : floorAreaSqft // ignore: cast_nullable_to_non_nullable
                      as double?,
            bedroomCount: freezed == bedroomCount
                ? _value.bedroomCount
                : bedroomCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            bathroomCount: freezed == bathroomCount
                ? _value.bathroomCount
                : bathroomCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            balconyCount: freezed == balconyCount
                ? _value.balconyCount
                : balconyCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            monthlyRentInr: freezed == monthlyRentInr
                ? _value.monthlyRentInr
                : monthlyRentInr // ignore: cast_nullable_to_non_nullable
                      as double?,
            paymentDueDay: freezed == paymentDueDay
                ? _value.paymentDueDay
                : paymentDueDay // ignore: cast_nullable_to_non_nullable
                      as int?,
            managementStatus: freezed == managementStatus
                ? _value.managementStatus
                : managementStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            floorPlans: freezed == floorPlans
                ? _value.floorPlans
                : floorPlans // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            marketValue: freezed == marketValue
                ? _value.marketValue
                : marketValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            amenities: freezed == amenities
                ? _value.amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            yearBuilt: freezed == yearBuilt
                ? _value.yearBuilt
                : yearBuilt // ignore: cast_nullable_to_non_nullable
                      as int?,
            propertyTaxId: freezed == propertyTaxId
                ? _value.propertyTaxId
                : propertyTaxId // ignore: cast_nullable_to_non_nullable
                      as String?,
            insurancePolicy: freezed == insurancePolicy
                ? _value.insurancePolicy
                : insurancePolicy // ignore: cast_nullable_to_non_nullable
                      as String?,
            hoaInfo: freezed == hoaInfo
                ? _value.hoaInfo
                : hoaInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedManagerId: freezed == assignedManagerId
                ? _value.assignedManagerId
                : assignedManagerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyImplCopyWith<$Res>
    implements $PropertyCopyWith<$Res> {
  factory _$$PropertyImplCopyWith(
    _$PropertyImpl value,
    $Res Function(_$PropertyImpl) then,
  ) = __$$PropertyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
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
    @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble)
    double? floorAreaSqft,
    @JsonKey(name: 'bedroom_count', fromJson: parseInt) int? bedroomCount,
    @JsonKey(name: 'bathroom_count', fromJson: parseInt) int? bathroomCount,
    @JsonKey(name: 'balcony_count', fromJson: parseInt) int? balconyCount,
    @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble)
    double? monthlyRentInr,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) int? paymentDueDay,
    @JsonKey(name: 'management_status') String? managementStatus,
    String? notes,
    @JsonKey(name: 'images') List<String>? images,
    @JsonKey(name: 'floor_plans') List<String>? floorPlans,
    @JsonKey(name: 'market_value', fromJson: parseDouble) double? marketValue,
    @JsonKey(name: 'amenities') List<String>? amenities,
    @JsonKey(name: 'year_built', fromJson: parseInt) int? yearBuilt,
    @JsonKey(name: 'property_tax_id') String? propertyTaxId,
    @JsonKey(name: 'insurance_policy') String? insurancePolicy,
    @JsonKey(name: 'hoa_info') String? hoaInfo,
    @JsonKey(name: 'assigned_manager_id', fromJson: parseInt)
    int? assignedManagerId,
    @JsonKey(name: 'latitude', fromJson: parseDouble) double? latitude,
    @JsonKey(name: 'longitude', fromJson: parseDouble) double? longitude,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PropertyImplCopyWithImpl<$Res>
    extends _$PropertyCopyWithImpl<$Res, _$PropertyImpl>
    implements _$$PropertyImplCopyWith<$Res> {
  __$$PropertyImplCopyWithImpl(
    _$PropertyImpl _value,
    $Res Function(_$PropertyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? propertyName = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? unitCount = freezed,
    Object? occupiedUnits = freezed,
    Object? type = freezed,
    Object? floorAreaSqft = freezed,
    Object? bedroomCount = freezed,
    Object? bathroomCount = freezed,
    Object? balconyCount = freezed,
    Object? monthlyRentInr = freezed,
    Object? paymentDueDay = freezed,
    Object? managementStatus = freezed,
    Object? notes = freezed,
    Object? images = freezed,
    Object? floorPlans = freezed,
    Object? marketValue = freezed,
    Object? amenities = freezed,
    Object? yearBuilt = freezed,
    Object? propertyTaxId = freezed,
    Object? insurancePolicy = freezed,
    Object? hoaInfo = freezed,
    Object? assignedManagerId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PropertyImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        pincode: freezed == pincode
            ? _value.pincode
            : pincode // ignore: cast_nullable_to_non_nullable
                  as String?,
        unitCount: freezed == unitCount
            ? _value.unitCount
            : unitCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        occupiedUnits: freezed == occupiedUnits
            ? _value.occupiedUnits
            : occupiedUnits // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        floorAreaSqft: freezed == floorAreaSqft
            ? _value.floorAreaSqft
            : floorAreaSqft // ignore: cast_nullable_to_non_nullable
                  as double?,
        bedroomCount: freezed == bedroomCount
            ? _value.bedroomCount
            : bedroomCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        bathroomCount: freezed == bathroomCount
            ? _value.bathroomCount
            : bathroomCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        balconyCount: freezed == balconyCount
            ? _value.balconyCount
            : balconyCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        monthlyRentInr: freezed == monthlyRentInr
            ? _value.monthlyRentInr
            : monthlyRentInr // ignore: cast_nullable_to_non_nullable
                  as double?,
        paymentDueDay: freezed == paymentDueDay
            ? _value.paymentDueDay
            : paymentDueDay // ignore: cast_nullable_to_non_nullable
                  as int?,
        managementStatus: freezed == managementStatus
            ? _value.managementStatus
            : managementStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        floorPlans: freezed == floorPlans
            ? _value._floorPlans
            : floorPlans // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        marketValue: freezed == marketValue
            ? _value.marketValue
            : marketValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        amenities: freezed == amenities
            ? _value._amenities
            : amenities // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        yearBuilt: freezed == yearBuilt
            ? _value.yearBuilt
            : yearBuilt // ignore: cast_nullable_to_non_nullable
                  as int?,
        propertyTaxId: freezed == propertyTaxId
            ? _value.propertyTaxId
            : propertyTaxId // ignore: cast_nullable_to_non_nullable
                  as String?,
        insurancePolicy: freezed == insurancePolicy
            ? _value.insurancePolicy
            : insurancePolicy // ignore: cast_nullable_to_non_nullable
                  as String?,
        hoaInfo: freezed == hoaInfo
            ? _value.hoaInfo
            : hoaInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedManagerId: freezed == assignedManagerId
            ? _value.assignedManagerId
            : assignedManagerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyImpl implements _Property {
  const _$PropertyImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.name,
    @JsonKey(name: 'property_name') this.propertyName,
    this.address,
    this.city,
    this.state,
    @JsonKey(name: 'pincode') this.pincode,
    @JsonKey(name: 'unit_count', fromJson: parseInt) this.unitCount,
    @JsonKey(name: 'occupied_units', fromJson: parseInt) this.occupiedUnits,
    this.type,
    @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble) this.floorAreaSqft,
    @JsonKey(name: 'bedroom_count', fromJson: parseInt) this.bedroomCount,
    @JsonKey(name: 'bathroom_count', fromJson: parseInt) this.bathroomCount,
    @JsonKey(name: 'balcony_count', fromJson: parseInt) this.balconyCount,
    @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble)
    this.monthlyRentInr,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) this.paymentDueDay,
    @JsonKey(name: 'management_status') this.managementStatus,
    this.notes,
    @JsonKey(name: 'images') final List<String>? images,
    @JsonKey(name: 'floor_plans') final List<String>? floorPlans,
    @JsonKey(name: 'market_value', fromJson: parseDouble) this.marketValue,
    @JsonKey(name: 'amenities') final List<String>? amenities,
    @JsonKey(name: 'year_built', fromJson: parseInt) this.yearBuilt,
    @JsonKey(name: 'property_tax_id') this.propertyTaxId,
    @JsonKey(name: 'insurance_policy') this.insurancePolicy,
    @JsonKey(name: 'hoa_info') this.hoaInfo,
    @JsonKey(name: 'assigned_manager_id', fromJson: parseInt)
    this.assignedManagerId,
    @JsonKey(name: 'latitude', fromJson: parseDouble) this.latitude,
    @JsonKey(name: 'longitude', fromJson: parseDouble) this.longitude,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) this.updatedAt,
  }) : _images = images,
       _floorPlans = floorPlans,
       _amenities = amenities;

  factory _$PropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? state;
  @override
  @JsonKey(name: 'pincode')
  final String? pincode;
  @override
  @JsonKey(name: 'unit_count', fromJson: parseInt)
  final int? unitCount;
  @override
  @JsonKey(name: 'occupied_units', fromJson: parseInt)
  final int? occupiedUnits;
  @override
  final String? type;
  @override
  @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble)
  final double? floorAreaSqft;
  @override
  @JsonKey(name: 'bedroom_count', fromJson: parseInt)
  final int? bedroomCount;
  @override
  @JsonKey(name: 'bathroom_count', fromJson: parseInt)
  final int? bathroomCount;
  @override
  @JsonKey(name: 'balcony_count', fromJson: parseInt)
  final int? balconyCount;
  @override
  @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble)
  final double? monthlyRentInr;
  @override
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  final int? paymentDueDay;
  @override
  @JsonKey(name: 'management_status')
  final String? managementStatus;
  @override
  final String? notes;
  // New fields
  final List<String>? _images;
  // New fields
  @override
  @JsonKey(name: 'images')
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _floorPlans;
  @override
  @JsonKey(name: 'floor_plans')
  List<String>? get floorPlans {
    final value = _floorPlans;
    if (value == null) return null;
    if (_floorPlans is EqualUnmodifiableListView) return _floorPlans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'market_value', fromJson: parseDouble)
  final double? marketValue;
  final List<String>? _amenities;
  @override
  @JsonKey(name: 'amenities')
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'year_built', fromJson: parseInt)
  final int? yearBuilt;
  @override
  @JsonKey(name: 'property_tax_id')
  final String? propertyTaxId;
  @override
  @JsonKey(name: 'insurance_policy')
  final String? insurancePolicy;
  @override
  @JsonKey(name: 'hoa_info')
  final String? hoaInfo;
  @override
  @JsonKey(name: 'assigned_manager_id', fromJson: parseInt)
  final int? assignedManagerId;
  @override
  @JsonKey(name: 'latitude', fromJson: parseDouble)
  final double? latitude;
  @override
  @JsonKey(name: 'longitude', fromJson: parseDouble)
  final double? longitude;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Property(id: $id, name: $name, propertyName: $propertyName, address: $address, city: $city, state: $state, pincode: $pincode, unitCount: $unitCount, occupiedUnits: $occupiedUnits, type: $type, floorAreaSqft: $floorAreaSqft, bedroomCount: $bedroomCount, bathroomCount: $bathroomCount, balconyCount: $balconyCount, monthlyRentInr: $monthlyRentInr, paymentDueDay: $paymentDueDay, managementStatus: $managementStatus, notes: $notes, images: $images, floorPlans: $floorPlans, marketValue: $marketValue, amenities: $amenities, yearBuilt: $yearBuilt, propertyTaxId: $propertyTaxId, insurancePolicy: $insurancePolicy, hoaInfo: $hoaInfo, assignedManagerId: $assignedManagerId, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.unitCount, unitCount) ||
                other.unitCount == unitCount) &&
            (identical(other.occupiedUnits, occupiedUnits) ||
                other.occupiedUnits == occupiedUnits) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.floorAreaSqft, floorAreaSqft) ||
                other.floorAreaSqft == floorAreaSqft) &&
            (identical(other.bedroomCount, bedroomCount) ||
                other.bedroomCount == bedroomCount) &&
            (identical(other.bathroomCount, bathroomCount) ||
                other.bathroomCount == bathroomCount) &&
            (identical(other.balconyCount, balconyCount) ||
                other.balconyCount == balconyCount) &&
            (identical(other.monthlyRentInr, monthlyRentInr) ||
                other.monthlyRentInr == monthlyRentInr) &&
            (identical(other.paymentDueDay, paymentDueDay) ||
                other.paymentDueDay == paymentDueDay) &&
            (identical(other.managementStatus, managementStatus) ||
                other.managementStatus == managementStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(
              other._floorPlans,
              _floorPlans,
            ) &&
            (identical(other.marketValue, marketValue) ||
                other.marketValue == marketValue) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            (identical(other.yearBuilt, yearBuilt) ||
                other.yearBuilt == yearBuilt) &&
            (identical(other.propertyTaxId, propertyTaxId) ||
                other.propertyTaxId == propertyTaxId) &&
            (identical(other.insurancePolicy, insurancePolicy) ||
                other.insurancePolicy == insurancePolicy) &&
            (identical(other.hoaInfo, hoaInfo) || other.hoaInfo == hoaInfo) &&
            (identical(other.assignedManagerId, assignedManagerId) ||
                other.assignedManagerId == assignedManagerId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    propertyName,
    address,
    city,
    state,
    pincode,
    unitCount,
    occupiedUnits,
    type,
    floorAreaSqft,
    bedroomCount,
    bathroomCount,
    balconyCount,
    monthlyRentInr,
    paymentDueDay,
    managementStatus,
    notes,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_floorPlans),
    marketValue,
    const DeepCollectionEquality().hash(_amenities),
    yearBuilt,
    propertyTaxId,
    insurancePolicy,
    hoaInfo,
    assignedManagerId,
    latitude,
    longitude,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyImplCopyWith<_$PropertyImpl> get copyWith =>
      __$$PropertyImplCopyWithImpl<_$PropertyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyImplToJson(this);
  }
}

abstract class _Property implements Property {
  const factory _Property({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? name,
    @JsonKey(name: 'property_name') final String? propertyName,
    final String? address,
    final String? city,
    final String? state,
    @JsonKey(name: 'pincode') final String? pincode,
    @JsonKey(name: 'unit_count', fromJson: parseInt) final int? unitCount,
    @JsonKey(name: 'occupied_units', fromJson: parseInt)
    final int? occupiedUnits,
    final String? type,
    @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble)
    final double? floorAreaSqft,
    @JsonKey(name: 'bedroom_count', fromJson: parseInt) final int? bedroomCount,
    @JsonKey(name: 'bathroom_count', fromJson: parseInt)
    final int? bathroomCount,
    @JsonKey(name: 'balcony_count', fromJson: parseInt) final int? balconyCount,
    @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble)
    final double? monthlyRentInr,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt)
    final int? paymentDueDay,
    @JsonKey(name: 'management_status') final String? managementStatus,
    final String? notes,
    @JsonKey(name: 'images') final List<String>? images,
    @JsonKey(name: 'floor_plans') final List<String>? floorPlans,
    @JsonKey(name: 'market_value', fromJson: parseDouble)
    final double? marketValue,
    @JsonKey(name: 'amenities') final List<String>? amenities,
    @JsonKey(name: 'year_built', fromJson: parseInt) final int? yearBuilt,
    @JsonKey(name: 'property_tax_id') final String? propertyTaxId,
    @JsonKey(name: 'insurance_policy') final String? insurancePolicy,
    @JsonKey(name: 'hoa_info') final String? hoaInfo,
    @JsonKey(name: 'assigned_manager_id', fromJson: parseInt)
    final int? assignedManagerId,
    @JsonKey(name: 'latitude', fromJson: parseDouble) final double? latitude,
    @JsonKey(name: 'longitude', fromJson: parseDouble) final double? longitude,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime)
    final DateTime? updatedAt,
  }) = _$PropertyImpl;

  factory _Property.fromJson(Map<String, dynamic> json) =
      _$PropertyImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get state;
  @override
  @JsonKey(name: 'pincode')
  String? get pincode;
  @override
  @JsonKey(name: 'unit_count', fromJson: parseInt)
  int? get unitCount;
  @override
  @JsonKey(name: 'occupied_units', fromJson: parseInt)
  int? get occupiedUnits;
  @override
  String? get type;
  @override
  @JsonKey(name: 'floor_area_sqft', fromJson: parseDouble)
  double? get floorAreaSqft;
  @override
  @JsonKey(name: 'bedroom_count', fromJson: parseInt)
  int? get bedroomCount;
  @override
  @JsonKey(name: 'bathroom_count', fromJson: parseInt)
  int? get bathroomCount;
  @override
  @JsonKey(name: 'balcony_count', fromJson: parseInt)
  int? get balconyCount;
  @override
  @JsonKey(name: 'monthly_rent_inr', fromJson: parseDouble)
  double? get monthlyRentInr;
  @override
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  int? get paymentDueDay;
  @override
  @JsonKey(name: 'management_status')
  String? get managementStatus;
  @override
  String? get notes; // New fields
  @override
  @JsonKey(name: 'images')
  List<String>? get images;
  @override
  @JsonKey(name: 'floor_plans')
  List<String>? get floorPlans;
  @override
  @JsonKey(name: 'market_value', fromJson: parseDouble)
  double? get marketValue;
  @override
  @JsonKey(name: 'amenities')
  List<String>? get amenities;
  @override
  @JsonKey(name: 'year_built', fromJson: parseInt)
  int? get yearBuilt;
  @override
  @JsonKey(name: 'property_tax_id')
  String? get propertyTaxId;
  @override
  @JsonKey(name: 'insurance_policy')
  String? get insurancePolicy;
  @override
  @JsonKey(name: 'hoa_info')
  String? get hoaInfo;
  @override
  @JsonKey(name: 'assigned_manager_id', fromJson: parseInt)
  int? get assignedManagerId;
  @override
  @JsonKey(name: 'latitude', fromJson: parseDouble)
  double? get latitude;
  @override
  @JsonKey(name: 'longitude', fromJson: parseDouble)
  double? get longitude;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt;

  /// Create a copy of Property
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyImplCopyWith<_$PropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
