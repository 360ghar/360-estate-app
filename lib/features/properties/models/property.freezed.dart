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

PropertyImage _$PropertyImageFromJson(Map<String, dynamic> json) {
  return _PropertyImage.fromJson(json);
}

/// @nodoc
mixin _$PropertyImage {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_category')
  String? get imageCategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order', fromJson: parseInt)
  int? get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_main_image')
  bool? get isMainImage => throw _privateConstructorUsedError;

  /// Serializes this PropertyImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyImageCopyWith<PropertyImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyImageCopyWith<$Res> {
  factory $PropertyImageCopyWith(
    PropertyImage value,
    $Res Function(PropertyImage) then,
  ) = _$PropertyImageCopyWithImpl<$Res, PropertyImage>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? caption,
    @JsonKey(name: 'image_category') String? imageCategory,
    @JsonKey(name: 'display_order', fromJson: parseInt) int? displayOrder,
    @JsonKey(name: 'is_main_image') bool? isMainImage,
  });
}

/// @nodoc
class _$PropertyImageCopyWithImpl<$Res, $Val extends PropertyImage>
    implements $PropertyImageCopyWith<$Res> {
  _$PropertyImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? imageUrl = freezed,
    Object? caption = freezed,
    Object? imageCategory = freezed,
    Object? displayOrder = freezed,
    Object? isMainImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageCategory: freezed == imageCategory
                ? _value.imageCategory
                : imageCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayOrder: freezed == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                      as int?,
            isMainImage: freezed == isMainImage
                ? _value.isMainImage
                : isMainImage // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyImageImplCopyWith<$Res>
    implements $PropertyImageCopyWith<$Res> {
  factory _$$PropertyImageImplCopyWith(
    _$PropertyImageImpl value,
    $Res Function(_$PropertyImageImpl) then,
  ) = __$$PropertyImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? caption,
    @JsonKey(name: 'image_category') String? imageCategory,
    @JsonKey(name: 'display_order', fromJson: parseInt) int? displayOrder,
    @JsonKey(name: 'is_main_image') bool? isMainImage,
  });
}

/// @nodoc
class __$$PropertyImageImplCopyWithImpl<$Res>
    extends _$PropertyImageCopyWithImpl<$Res, _$PropertyImageImpl>
    implements _$$PropertyImageImplCopyWith<$Res> {
  __$$PropertyImageImplCopyWithImpl(
    _$PropertyImageImpl _value,
    $Res Function(_$PropertyImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? imageUrl = freezed,
    Object? caption = freezed,
    Object? imageCategory = freezed,
    Object? displayOrder = freezed,
    Object? isMainImage = freezed,
  }) {
    return _then(
      _$PropertyImageImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageCategory: freezed == imageCategory
            ? _value.imageCategory
            : imageCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayOrder: freezed == displayOrder
            ? _value.displayOrder
            : displayOrder // ignore: cast_nullable_to_non_nullable
                  as int?,
        isMainImage: freezed == isMainImage
            ? _value.isMainImage
            : isMainImage // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyImageImpl implements _PropertyImage {
  const _$PropertyImageImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'image_url') this.imageUrl,
    this.caption,
    @JsonKey(name: 'image_category') this.imageCategory,
    @JsonKey(name: 'display_order', fromJson: parseInt) this.displayOrder,
    @JsonKey(name: 'is_main_image') this.isMainImage,
  });

  factory _$PropertyImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyImageImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String? caption;
  @override
  @JsonKey(name: 'image_category')
  final String? imageCategory;
  @override
  @JsonKey(name: 'display_order', fromJson: parseInt)
  final int? displayOrder;
  @override
  @JsonKey(name: 'is_main_image')
  final bool? isMainImage;

  @override
  String toString() {
    return 'PropertyImage(id: $id, imageUrl: $imageUrl, caption: $caption, imageCategory: $imageCategory, displayOrder: $displayOrder, isMainImage: $isMainImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.imageCategory, imageCategory) ||
                other.imageCategory == imageCategory) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isMainImage, isMainImage) ||
                other.isMainImage == isMainImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    imageUrl,
    caption,
    imageCategory,
    displayOrder,
    isMainImage,
  );

  /// Create a copy of PropertyImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyImageImplCopyWith<_$PropertyImageImpl> get copyWith =>
      __$$PropertyImageImplCopyWithImpl<_$PropertyImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyImageImplToJson(this);
  }
}

abstract class _PropertyImage implements PropertyImage {
  const factory _PropertyImage({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'image_url') final String? imageUrl,
    final String? caption,
    @JsonKey(name: 'image_category') final String? imageCategory,
    @JsonKey(name: 'display_order', fromJson: parseInt) final int? displayOrder,
    @JsonKey(name: 'is_main_image') final bool? isMainImage,
  }) = _$PropertyImageImpl;

  factory _PropertyImage.fromJson(Map<String, dynamic> json) =
      _$PropertyImageImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String? get caption;
  @override
  @JsonKey(name: 'image_category')
  String? get imageCategory;
  @override
  @JsonKey(name: 'display_order', fromJson: parseInt)
  int? get displayOrder;
  @override
  @JsonKey(name: 'is_main_image')
  bool? get isMainImage;

  /// Create a copy of PropertyImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyImageImplCopyWith<_$PropertyImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PropertyAmenity _$PropertyAmenityFromJson(Map<String, dynamic> json) {
  return _PropertyAmenity.fromJson(json);
}

/// @nodoc
mixin _$PropertyAmenity {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  /// Serializes this PropertyAmenity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyAmenity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyAmenityCopyWith<PropertyAmenity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyAmenityCopyWith<$Res> {
  factory $PropertyAmenityCopyWith(
    PropertyAmenity value,
    $Res Function(PropertyAmenity) then,
  ) = _$PropertyAmenityCopyWithImpl<$Res, PropertyAmenity>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? icon,
    String? category,
  });
}

/// @nodoc
class _$PropertyAmenityCopyWithImpl<$Res, $Val extends PropertyAmenity>
    implements $PropertyAmenityCopyWith<$Res> {
  _$PropertyAmenityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyAmenity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? icon = freezed,
    Object? category = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyAmenityImplCopyWith<$Res>
    implements $PropertyAmenityCopyWith<$Res> {
  factory _$$PropertyAmenityImplCopyWith(
    _$PropertyAmenityImpl value,
    $Res Function(_$PropertyAmenityImpl) then,
  ) = __$$PropertyAmenityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? icon,
    String? category,
  });
}

/// @nodoc
class __$$PropertyAmenityImplCopyWithImpl<$Res>
    extends _$PropertyAmenityCopyWithImpl<$Res, _$PropertyAmenityImpl>
    implements _$$PropertyAmenityImplCopyWith<$Res> {
  __$$PropertyAmenityImplCopyWithImpl(
    _$PropertyAmenityImpl _value,
    $Res Function(_$PropertyAmenityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyAmenity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? icon = freezed,
    Object? category = freezed,
  }) {
    return _then(
      _$PropertyAmenityImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyAmenityImpl implements _PropertyAmenity {
  const _$PropertyAmenityImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.title,
    this.icon,
    this.category,
  });

  factory _$PropertyAmenityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyAmenityImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? title;
  @override
  final String? icon;
  @override
  final String? category;

  @override
  String toString() {
    return 'PropertyAmenity(id: $id, title: $title, icon: $icon, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyAmenityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, icon, category);

  /// Create a copy of PropertyAmenity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyAmenityImplCopyWith<_$PropertyAmenityImpl> get copyWith =>
      __$$PropertyAmenityImplCopyWithImpl<_$PropertyAmenityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyAmenityImplToJson(this);
  }
}

abstract class _PropertyAmenity implements PropertyAmenity {
  const factory _PropertyAmenity({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? title,
    final String? icon,
    final String? category,
  }) = _$PropertyAmenityImpl;

  factory _PropertyAmenity.fromJson(Map<String, dynamic> json) =
      _$PropertyAmenityImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get title;
  @override
  String? get icon;
  @override
  String? get category;

  /// Create a copy of PropertyAmenity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyAmenityImplCopyWith<_$PropertyAmenityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Property _$PropertyFromJson(Map<String, dynamic> json) {
  return _Property.fromJson(json);
}

/// @nodoc
mixin _$Property {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'property_type',
    fromJson: PropertyType.fromJson,
    toJson: PropertyType.toJsonValue,
  )
  PropertyType? get propertyType => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: PropertyPurpose.fromJson,
    toJson: PropertyPurpose.toJsonValue,
  )
  PropertyPurpose? get purpose => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'status',
    fromJson: PropertyStatus.fromJson,
    toJson: PropertyStatus.toJsonValue,
  )
  PropertyStatus? get listingStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price', fromJson: parseDouble)
  double? get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
  double? get monthlyRent => throw _privateConstructorUsedError;
  @JsonKey(name: 'security_deposit', fromJson: parseDouble)
  double? get securityDeposit => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_charges', fromJson: parseDouble)
  double? get maintenanceCharges => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get longitude => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get pincode => throw _privateConstructorUsedError;
  String? get locality => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_address')
  String? get fullAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_sqft', fromJson: parseDouble)
  double? get areaSqft => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseInt)
  int? get bedrooms => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseInt)
  int? get bathrooms => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseInt)
  int? get balconies => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_of_property', fromJson: parseInt)
  int? get ageOfProperty => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'furnishing_level',
    fromJson: FurnishingLevel.fromJson,
    toJson: FurnishingLevel.toJsonValue,
  )
  FurnishingLevel? get furnishingLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool? get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_managed')
  bool? get isManaged => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'management_status',
    fromJson: ManagedPropertyStatus.fromJson,
    toJson: ManagedPropertyStatus.toJsonValue,
  )
  ManagedPropertyStatus? get managementStatus =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  int? get paymentDueDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'grace_period_days', fromJson: parseInt)
  int? get gracePeriodDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_fee_policy')
  Map<String, dynamic>? get lateFeePolicy => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_lease_id', fromJson: parseInt)
  int? get currentLeaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_tenant_id', fromJson: parseInt)
  int? get currentTenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'main_image_url')
  String? get mainImageUrl => throw _privateConstructorUsedError;
  List<PropertyImage>? get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_plans')
  List<PropertyImage>? get floorPlans => throw _privateConstructorUsedError;
  List<PropertyAmenity>? get amenities => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_name')
  String? get ownerName => throw _privateConstructorUsedError; // The owner's number for the owner and admins only. Anyone else gets the
  // assigned agent's number, else the company number, else null.
  @JsonKey(name: 'owner_contact')
  String? get ownerContact => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'owner_contact') String? ownerContact,
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
    Object? ownerId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? propertyType = freezed,
    Object? purpose = freezed,
    Object? listingStatus = freezed,
    Object? basePrice = freezed,
    Object? monthlyRent = freezed,
    Object? securityDeposit = freezed,
    Object? maintenanceCharges = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? locality = freezed,
    Object? fullAddress = freezed,
    Object? areaSqft = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? balconies = freezed,
    Object? ageOfProperty = freezed,
    Object? furnishingLevel = freezed,
    Object? isAvailable = freezed,
    Object? isManaged = freezed,
    Object? managementStatus = freezed,
    Object? paymentDueDay = freezed,
    Object? gracePeriodDays = freezed,
    Object? lateFeePolicy = freezed,
    Object? currentLeaseId = freezed,
    Object? currentTenantId = freezed,
    Object? mainImageUrl = freezed,
    Object? images = freezed,
    Object? floorPlans = freezed,
    Object? amenities = freezed,
    Object? ownerName = freezed,
    Object? ownerContact = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyType: freezed == propertyType
                ? _value.propertyType
                : propertyType // ignore: cast_nullable_to_non_nullable
                      as PropertyType?,
            purpose: freezed == purpose
                ? _value.purpose
                : purpose // ignore: cast_nullable_to_non_nullable
                      as PropertyPurpose?,
            listingStatus: freezed == listingStatus
                ? _value.listingStatus
                : listingStatus // ignore: cast_nullable_to_non_nullable
                      as PropertyStatus?,
            basePrice: freezed == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            monthlyRent: freezed == monthlyRent
                ? _value.monthlyRent
                : monthlyRent // ignore: cast_nullable_to_non_nullable
                      as double?,
            securityDeposit: freezed == securityDeposit
                ? _value.securityDeposit
                : securityDeposit // ignore: cast_nullable_to_non_nullable
                      as double?,
            maintenanceCharges: freezed == maintenanceCharges
                ? _value.maintenanceCharges
                : maintenanceCharges // ignore: cast_nullable_to_non_nullable
                      as double?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
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
            locality: freezed == locality
                ? _value.locality
                : locality // ignore: cast_nullable_to_non_nullable
                      as String?,
            fullAddress: freezed == fullAddress
                ? _value.fullAddress
                : fullAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            areaSqft: freezed == areaSqft
                ? _value.areaSqft
                : areaSqft // ignore: cast_nullable_to_non_nullable
                      as double?,
            bedrooms: freezed == bedrooms
                ? _value.bedrooms
                : bedrooms // ignore: cast_nullable_to_non_nullable
                      as int?,
            bathrooms: freezed == bathrooms
                ? _value.bathrooms
                : bathrooms // ignore: cast_nullable_to_non_nullable
                      as int?,
            balconies: freezed == balconies
                ? _value.balconies
                : balconies // ignore: cast_nullable_to_non_nullable
                      as int?,
            ageOfProperty: freezed == ageOfProperty
                ? _value.ageOfProperty
                : ageOfProperty // ignore: cast_nullable_to_non_nullable
                      as int?,
            furnishingLevel: freezed == furnishingLevel
                ? _value.furnishingLevel
                : furnishingLevel // ignore: cast_nullable_to_non_nullable
                      as FurnishingLevel?,
            isAvailable: freezed == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isManaged: freezed == isManaged
                ? _value.isManaged
                : isManaged // ignore: cast_nullable_to_non_nullable
                      as bool?,
            managementStatus: freezed == managementStatus
                ? _value.managementStatus
                : managementStatus // ignore: cast_nullable_to_non_nullable
                      as ManagedPropertyStatus?,
            paymentDueDay: freezed == paymentDueDay
                ? _value.paymentDueDay
                : paymentDueDay // ignore: cast_nullable_to_non_nullable
                      as int?,
            gracePeriodDays: freezed == gracePeriodDays
                ? _value.gracePeriodDays
                : gracePeriodDays // ignore: cast_nullable_to_non_nullable
                      as int?,
            lateFeePolicy: freezed == lateFeePolicy
                ? _value.lateFeePolicy
                : lateFeePolicy // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            currentLeaseId: freezed == currentLeaseId
                ? _value.currentLeaseId
                : currentLeaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentTenantId: freezed == currentTenantId
                ? _value.currentTenantId
                : currentTenantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            mainImageUrl: freezed == mainImageUrl
                ? _value.mainImageUrl
                : mainImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<PropertyImage>?,
            floorPlans: freezed == floorPlans
                ? _value.floorPlans
                : floorPlans // ignore: cast_nullable_to_non_nullable
                      as List<PropertyImage>?,
            amenities: freezed == amenities
                ? _value.amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                      as List<PropertyAmenity>?,
            ownerName: freezed == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            ownerContact: freezed == ownerContact
                ? _value.ownerContact
                : ownerContact // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    @JsonKey(name: 'owner_contact') String? ownerContact,
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
    Object? ownerId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? propertyType = freezed,
    Object? purpose = freezed,
    Object? listingStatus = freezed,
    Object? basePrice = freezed,
    Object? monthlyRent = freezed,
    Object? securityDeposit = freezed,
    Object? maintenanceCharges = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? locality = freezed,
    Object? fullAddress = freezed,
    Object? areaSqft = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? balconies = freezed,
    Object? ageOfProperty = freezed,
    Object? furnishingLevel = freezed,
    Object? isAvailable = freezed,
    Object? isManaged = freezed,
    Object? managementStatus = freezed,
    Object? paymentDueDay = freezed,
    Object? gracePeriodDays = freezed,
    Object? lateFeePolicy = freezed,
    Object? currentLeaseId = freezed,
    Object? currentTenantId = freezed,
    Object? mainImageUrl = freezed,
    Object? images = freezed,
    Object? floorPlans = freezed,
    Object? amenities = freezed,
    Object? ownerName = freezed,
    Object? ownerContact = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PropertyImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyType: freezed == propertyType
            ? _value.propertyType
            : propertyType // ignore: cast_nullable_to_non_nullable
                  as PropertyType?,
        purpose: freezed == purpose
            ? _value.purpose
            : purpose // ignore: cast_nullable_to_non_nullable
                  as PropertyPurpose?,
        listingStatus: freezed == listingStatus
            ? _value.listingStatus
            : listingStatus // ignore: cast_nullable_to_non_nullable
                  as PropertyStatus?,
        basePrice: freezed == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        monthlyRent: freezed == monthlyRent
            ? _value.monthlyRent
            : monthlyRent // ignore: cast_nullable_to_non_nullable
                  as double?,
        securityDeposit: freezed == securityDeposit
            ? _value.securityDeposit
            : securityDeposit // ignore: cast_nullable_to_non_nullable
                  as double?,
        maintenanceCharges: freezed == maintenanceCharges
            ? _value.maintenanceCharges
            : maintenanceCharges // ignore: cast_nullable_to_non_nullable
                  as double?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
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
        locality: freezed == locality
            ? _value.locality
            : locality // ignore: cast_nullable_to_non_nullable
                  as String?,
        fullAddress: freezed == fullAddress
            ? _value.fullAddress
            : fullAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        areaSqft: freezed == areaSqft
            ? _value.areaSqft
            : areaSqft // ignore: cast_nullable_to_non_nullable
                  as double?,
        bedrooms: freezed == bedrooms
            ? _value.bedrooms
            : bedrooms // ignore: cast_nullable_to_non_nullable
                  as int?,
        bathrooms: freezed == bathrooms
            ? _value.bathrooms
            : bathrooms // ignore: cast_nullable_to_non_nullable
                  as int?,
        balconies: freezed == balconies
            ? _value.balconies
            : balconies // ignore: cast_nullable_to_non_nullable
                  as int?,
        ageOfProperty: freezed == ageOfProperty
            ? _value.ageOfProperty
            : ageOfProperty // ignore: cast_nullable_to_non_nullable
                  as int?,
        furnishingLevel: freezed == furnishingLevel
            ? _value.furnishingLevel
            : furnishingLevel // ignore: cast_nullable_to_non_nullable
                  as FurnishingLevel?,
        isAvailable: freezed == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isManaged: freezed == isManaged
            ? _value.isManaged
            : isManaged // ignore: cast_nullable_to_non_nullable
                  as bool?,
        managementStatus: freezed == managementStatus
            ? _value.managementStatus
            : managementStatus // ignore: cast_nullable_to_non_nullable
                  as ManagedPropertyStatus?,
        paymentDueDay: freezed == paymentDueDay
            ? _value.paymentDueDay
            : paymentDueDay // ignore: cast_nullable_to_non_nullable
                  as int?,
        gracePeriodDays: freezed == gracePeriodDays
            ? _value.gracePeriodDays
            : gracePeriodDays // ignore: cast_nullable_to_non_nullable
                  as int?,
        lateFeePolicy: freezed == lateFeePolicy
            ? _value._lateFeePolicy
            : lateFeePolicy // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        currentLeaseId: freezed == currentLeaseId
            ? _value.currentLeaseId
            : currentLeaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentTenantId: freezed == currentTenantId
            ? _value.currentTenantId
            : currentTenantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        mainImageUrl: freezed == mainImageUrl
            ? _value.mainImageUrl
            : mainImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<PropertyImage>?,
        floorPlans: freezed == floorPlans
            ? _value._floorPlans
            : floorPlans // ignore: cast_nullable_to_non_nullable
                  as List<PropertyImage>?,
        amenities: freezed == amenities
            ? _value._amenities
            : amenities // ignore: cast_nullable_to_non_nullable
                  as List<PropertyAmenity>?,
        ownerName: freezed == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        ownerContact: freezed == ownerContact
            ? _value.ownerContact
            : ownerContact // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    @JsonKey(name: 'owner_id', fromJson: parseInt) this.ownerId,
    this.title,
    this.description,
    @JsonKey(
      name: 'property_type',
      fromJson: PropertyType.fromJson,
      toJson: PropertyType.toJsonValue,
    )
    this.propertyType,
    @JsonKey(
      fromJson: PropertyPurpose.fromJson,
      toJson: PropertyPurpose.toJsonValue,
    )
    this.purpose,
    @JsonKey(
      name: 'status',
      fromJson: PropertyStatus.fromJson,
      toJson: PropertyStatus.toJsonValue,
    )
    this.listingStatus,
    @JsonKey(name: 'base_price', fromJson: parseDouble) this.basePrice,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble) this.monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    this.securityDeposit,
    @JsonKey(name: 'maintenance_charges', fromJson: parseDouble)
    this.maintenanceCharges,
    @JsonKey(fromJson: parseDouble) this.latitude,
    @JsonKey(fromJson: parseDouble) this.longitude,
    this.city,
    this.state,
    this.pincode,
    this.locality,
    @JsonKey(name: 'full_address') this.fullAddress,
    @JsonKey(name: 'area_sqft', fromJson: parseDouble) this.areaSqft,
    @JsonKey(fromJson: parseInt) this.bedrooms,
    @JsonKey(fromJson: parseInt) this.bathrooms,
    @JsonKey(fromJson: parseInt) this.balconies,
    @JsonKey(name: 'age_of_property', fromJson: parseInt) this.ageOfProperty,
    @JsonKey(
      name: 'furnishing_level',
      fromJson: FurnishingLevel.fromJson,
      toJson: FurnishingLevel.toJsonValue,
    )
    this.furnishingLevel,
    @JsonKey(name: 'is_available') this.isAvailable,
    @JsonKey(name: 'is_managed') this.isManaged,
    @JsonKey(
      name: 'management_status',
      fromJson: ManagedPropertyStatus.fromJson,
      toJson: ManagedPropertyStatus.toJsonValue,
    )
    this.managementStatus,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) this.paymentDueDay,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    this.gracePeriodDays,
    @JsonKey(name: 'late_fee_policy') final Map<String, dynamic>? lateFeePolicy,
    @JsonKey(name: 'current_lease_id', fromJson: parseInt) this.currentLeaseId,
    @JsonKey(name: 'current_tenant_id', fromJson: parseInt)
    this.currentTenantId,
    @JsonKey(name: 'main_image_url') this.mainImageUrl,
    final List<PropertyImage>? images,
    @JsonKey(name: 'floor_plans') final List<PropertyImage>? floorPlans,
    final List<PropertyAmenity>? amenities,
    @JsonKey(name: 'owner_name') this.ownerName,
    @JsonKey(name: 'owner_contact') this.ownerContact,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) this.updatedAt,
  }) : _lateFeePolicy = lateFeePolicy,
       _images = images,
       _floorPlans = floorPlans,
       _amenities = amenities;

  factory _$PropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  final int? ownerId;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(
    name: 'property_type',
    fromJson: PropertyType.fromJson,
    toJson: PropertyType.toJsonValue,
  )
  final PropertyType? propertyType;
  @override
  @JsonKey(
    fromJson: PropertyPurpose.fromJson,
    toJson: PropertyPurpose.toJsonValue,
  )
  final PropertyPurpose? purpose;
  @override
  @JsonKey(
    name: 'status',
    fromJson: PropertyStatus.fromJson,
    toJson: PropertyStatus.toJsonValue,
  )
  final PropertyStatus? listingStatus;
  @override
  @JsonKey(name: 'base_price', fromJson: parseDouble)
  final double? basePrice;
  @override
  @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
  final double? monthlyRent;
  @override
  @JsonKey(name: 'security_deposit', fromJson: parseDouble)
  final double? securityDeposit;
  @override
  @JsonKey(name: 'maintenance_charges', fromJson: parseDouble)
  final double? maintenanceCharges;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? latitude;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? longitude;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? pincode;
  @override
  final String? locality;
  @override
  @JsonKey(name: 'full_address')
  final String? fullAddress;
  @override
  @JsonKey(name: 'area_sqft', fromJson: parseDouble)
  final double? areaSqft;
  @override
  @JsonKey(fromJson: parseInt)
  final int? bedrooms;
  @override
  @JsonKey(fromJson: parseInt)
  final int? bathrooms;
  @override
  @JsonKey(fromJson: parseInt)
  final int? balconies;
  @override
  @JsonKey(name: 'age_of_property', fromJson: parseInt)
  final int? ageOfProperty;
  @override
  @JsonKey(
    name: 'furnishing_level',
    fromJson: FurnishingLevel.fromJson,
    toJson: FurnishingLevel.toJsonValue,
  )
  final FurnishingLevel? furnishingLevel;
  @override
  @JsonKey(name: 'is_available')
  final bool? isAvailable;
  @override
  @JsonKey(name: 'is_managed')
  final bool? isManaged;
  @override
  @JsonKey(
    name: 'management_status',
    fromJson: ManagedPropertyStatus.fromJson,
    toJson: ManagedPropertyStatus.toJsonValue,
  )
  final ManagedPropertyStatus? managementStatus;
  @override
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  final int? paymentDueDay;
  @override
  @JsonKey(name: 'grace_period_days', fromJson: parseInt)
  final int? gracePeriodDays;
  final Map<String, dynamic>? _lateFeePolicy;
  @override
  @JsonKey(name: 'late_fee_policy')
  Map<String, dynamic>? get lateFeePolicy {
    final value = _lateFeePolicy;
    if (value == null) return null;
    if (_lateFeePolicy is EqualUnmodifiableMapView) return _lateFeePolicy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'current_lease_id', fromJson: parseInt)
  final int? currentLeaseId;
  @override
  @JsonKey(name: 'current_tenant_id', fromJson: parseInt)
  final int? currentTenantId;
  @override
  @JsonKey(name: 'main_image_url')
  final String? mainImageUrl;
  final List<PropertyImage>? _images;
  @override
  List<PropertyImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PropertyImage>? _floorPlans;
  @override
  @JsonKey(name: 'floor_plans')
  List<PropertyImage>? get floorPlans {
    final value = _floorPlans;
    if (value == null) return null;
    if (_floorPlans is EqualUnmodifiableListView) return _floorPlans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PropertyAmenity>? _amenities;
  @override
  List<PropertyAmenity>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'owner_name')
  final String? ownerName;
  // The owner's number for the owner and admins only. Anyone else gets the
  // assigned agent's number, else the company number, else null.
  @override
  @JsonKey(name: 'owner_contact')
  final String? ownerContact;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Property(id: $id, ownerId: $ownerId, title: $title, description: $description, propertyType: $propertyType, purpose: $purpose, listingStatus: $listingStatus, basePrice: $basePrice, monthlyRent: $monthlyRent, securityDeposit: $securityDeposit, maintenanceCharges: $maintenanceCharges, latitude: $latitude, longitude: $longitude, city: $city, state: $state, pincode: $pincode, locality: $locality, fullAddress: $fullAddress, areaSqft: $areaSqft, bedrooms: $bedrooms, bathrooms: $bathrooms, balconies: $balconies, ageOfProperty: $ageOfProperty, furnishingLevel: $furnishingLevel, isAvailable: $isAvailable, isManaged: $isManaged, managementStatus: $managementStatus, paymentDueDay: $paymentDueDay, gracePeriodDays: $gracePeriodDays, lateFeePolicy: $lateFeePolicy, currentLeaseId: $currentLeaseId, currentTenantId: $currentTenantId, mainImageUrl: $mainImageUrl, images: $images, floorPlans: $floorPlans, amenities: $amenities, ownerName: $ownerName, ownerContact: $ownerContact, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.propertyType, propertyType) ||
                other.propertyType == propertyType) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.listingStatus, listingStatus) ||
                other.listingStatus == listingStatus) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.monthlyRent, monthlyRent) ||
                other.monthlyRent == monthlyRent) &&
            (identical(other.securityDeposit, securityDeposit) ||
                other.securityDeposit == securityDeposit) &&
            (identical(other.maintenanceCharges, maintenanceCharges) ||
                other.maintenanceCharges == maintenanceCharges) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.areaSqft, areaSqft) ||
                other.areaSqft == areaSqft) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            (identical(other.balconies, balconies) ||
                other.balconies == balconies) &&
            (identical(other.ageOfProperty, ageOfProperty) ||
                other.ageOfProperty == ageOfProperty) &&
            (identical(other.furnishingLevel, furnishingLevel) ||
                other.furnishingLevel == furnishingLevel) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isManaged, isManaged) ||
                other.isManaged == isManaged) &&
            (identical(other.managementStatus, managementStatus) ||
                other.managementStatus == managementStatus) &&
            (identical(other.paymentDueDay, paymentDueDay) ||
                other.paymentDueDay == paymentDueDay) &&
            (identical(other.gracePeriodDays, gracePeriodDays) ||
                other.gracePeriodDays == gracePeriodDays) &&
            const DeepCollectionEquality().equals(
              other._lateFeePolicy,
              _lateFeePolicy,
            ) &&
            (identical(other.currentLeaseId, currentLeaseId) ||
                other.currentLeaseId == currentLeaseId) &&
            (identical(other.currentTenantId, currentTenantId) ||
                other.currentTenantId == currentTenantId) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(
              other._floorPlans,
              _floorPlans,
            ) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerContact, ownerContact) ||
                other.ownerContact == ownerContact) &&
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
    ownerId,
    title,
    description,
    propertyType,
    purpose,
    listingStatus,
    basePrice,
    monthlyRent,
    securityDeposit,
    maintenanceCharges,
    latitude,
    longitude,
    city,
    state,
    pincode,
    locality,
    fullAddress,
    areaSqft,
    bedrooms,
    bathrooms,
    balconies,
    ageOfProperty,
    furnishingLevel,
    isAvailable,
    isManaged,
    managementStatus,
    paymentDueDay,
    gracePeriodDays,
    const DeepCollectionEquality().hash(_lateFeePolicy),
    currentLeaseId,
    currentTenantId,
    mainImageUrl,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_floorPlans),
    const DeepCollectionEquality().hash(_amenities),
    ownerName,
    ownerContact,
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
    @JsonKey(name: 'owner_id', fromJson: parseInt) final int? ownerId,
    final String? title,
    final String? description,
    @JsonKey(
      name: 'property_type',
      fromJson: PropertyType.fromJson,
      toJson: PropertyType.toJsonValue,
    )
    final PropertyType? propertyType,
    @JsonKey(
      fromJson: PropertyPurpose.fromJson,
      toJson: PropertyPurpose.toJsonValue,
    )
    final PropertyPurpose? purpose,
    @JsonKey(
      name: 'status',
      fromJson: PropertyStatus.fromJson,
      toJson: PropertyStatus.toJsonValue,
    )
    final PropertyStatus? listingStatus,
    @JsonKey(name: 'base_price', fromJson: parseDouble) final double? basePrice,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
    final double? monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    final double? securityDeposit,
    @JsonKey(name: 'maintenance_charges', fromJson: parseDouble)
    final double? maintenanceCharges,
    @JsonKey(fromJson: parseDouble) final double? latitude,
    @JsonKey(fromJson: parseDouble) final double? longitude,
    final String? city,
    final String? state,
    final String? pincode,
    final String? locality,
    @JsonKey(name: 'full_address') final String? fullAddress,
    @JsonKey(name: 'area_sqft', fromJson: parseDouble) final double? areaSqft,
    @JsonKey(fromJson: parseInt) final int? bedrooms,
    @JsonKey(fromJson: parseInt) final int? bathrooms,
    @JsonKey(fromJson: parseInt) final int? balconies,
    @JsonKey(name: 'age_of_property', fromJson: parseInt)
    final int? ageOfProperty,
    @JsonKey(
      name: 'furnishing_level',
      fromJson: FurnishingLevel.fromJson,
      toJson: FurnishingLevel.toJsonValue,
    )
    final FurnishingLevel? furnishingLevel,
    @JsonKey(name: 'is_available') final bool? isAvailable,
    @JsonKey(name: 'is_managed') final bool? isManaged,
    @JsonKey(
      name: 'management_status',
      fromJson: ManagedPropertyStatus.fromJson,
      toJson: ManagedPropertyStatus.toJsonValue,
    )
    final ManagedPropertyStatus? managementStatus,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt)
    final int? paymentDueDay,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    final int? gracePeriodDays,
    @JsonKey(name: 'late_fee_policy') final Map<String, dynamic>? lateFeePolicy,
    @JsonKey(name: 'current_lease_id', fromJson: parseInt)
    final int? currentLeaseId,
    @JsonKey(name: 'current_tenant_id', fromJson: parseInt)
    final int? currentTenantId,
    @JsonKey(name: 'main_image_url') final String? mainImageUrl,
    final List<PropertyImage>? images,
    @JsonKey(name: 'floor_plans') final List<PropertyImage>? floorPlans,
    final List<PropertyAmenity>? amenities,
    @JsonKey(name: 'owner_name') final String? ownerName,
    @JsonKey(name: 'owner_contact') final String? ownerContact,
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
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @JsonKey(
    name: 'property_type',
    fromJson: PropertyType.fromJson,
    toJson: PropertyType.toJsonValue,
  )
  PropertyType? get propertyType;
  @override
  @JsonKey(
    fromJson: PropertyPurpose.fromJson,
    toJson: PropertyPurpose.toJsonValue,
  )
  PropertyPurpose? get purpose;
  @override
  @JsonKey(
    name: 'status',
    fromJson: PropertyStatus.fromJson,
    toJson: PropertyStatus.toJsonValue,
  )
  PropertyStatus? get listingStatus;
  @override
  @JsonKey(name: 'base_price', fromJson: parseDouble)
  double? get basePrice;
  @override
  @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
  double? get monthlyRent;
  @override
  @JsonKey(name: 'security_deposit', fromJson: parseDouble)
  double? get securityDeposit;
  @override
  @JsonKey(name: 'maintenance_charges', fromJson: parseDouble)
  double? get maintenanceCharges;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get latitude;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get longitude;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get pincode;
  @override
  String? get locality;
  @override
  @JsonKey(name: 'full_address')
  String? get fullAddress;
  @override
  @JsonKey(name: 'area_sqft', fromJson: parseDouble)
  double? get areaSqft;
  @override
  @JsonKey(fromJson: parseInt)
  int? get bedrooms;
  @override
  @JsonKey(fromJson: parseInt)
  int? get bathrooms;
  @override
  @JsonKey(fromJson: parseInt)
  int? get balconies;
  @override
  @JsonKey(name: 'age_of_property', fromJson: parseInt)
  int? get ageOfProperty;
  @override
  @JsonKey(
    name: 'furnishing_level',
    fromJson: FurnishingLevel.fromJson,
    toJson: FurnishingLevel.toJsonValue,
  )
  FurnishingLevel? get furnishingLevel;
  @override
  @JsonKey(name: 'is_available')
  bool? get isAvailable;
  @override
  @JsonKey(name: 'is_managed')
  bool? get isManaged;
  @override
  @JsonKey(
    name: 'management_status',
    fromJson: ManagedPropertyStatus.fromJson,
    toJson: ManagedPropertyStatus.toJsonValue,
  )
  ManagedPropertyStatus? get managementStatus;
  @override
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  int? get paymentDueDay;
  @override
  @JsonKey(name: 'grace_period_days', fromJson: parseInt)
  int? get gracePeriodDays;
  @override
  @JsonKey(name: 'late_fee_policy')
  Map<String, dynamic>? get lateFeePolicy;
  @override
  @JsonKey(name: 'current_lease_id', fromJson: parseInt)
  int? get currentLeaseId;
  @override
  @JsonKey(name: 'current_tenant_id', fromJson: parseInt)
  int? get currentTenantId;
  @override
  @JsonKey(name: 'main_image_url')
  String? get mainImageUrl;
  @override
  List<PropertyImage>? get images;
  @override
  @JsonKey(name: 'floor_plans')
  List<PropertyImage>? get floorPlans;
  @override
  List<PropertyAmenity>? get amenities;
  @override
  @JsonKey(name: 'owner_name')
  String? get ownerName; // The owner's number for the owner and admins only. Anyone else gets the
  // assigned agent's number, else the company number, else null.
  @override
  @JsonKey(name: 'owner_contact')
  String? get ownerContact;
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

PropertyDetail _$PropertyDetailFromJson(Map<String, dynamic> json) {
  return _PropertyDetail.fromJson(json);
}

/// @nodoc
mixin _$PropertyDetail {
  Property get property => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_lease')
  Lease? get activeLease => throw _privateConstructorUsedError;

  /// Serializes this PropertyDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyDetailCopyWith<PropertyDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyDetailCopyWith<$Res> {
  factory $PropertyDetailCopyWith(
    PropertyDetail value,
    $Res Function(PropertyDetail) then,
  ) = _$PropertyDetailCopyWithImpl<$Res, PropertyDetail>;
  @useResult
  $Res call({
    Property property,
    @JsonKey(name: 'active_lease') Lease? activeLease,
  });

  $PropertyCopyWith<$Res> get property;
  $LeaseCopyWith<$Res>? get activeLease;
}

/// @nodoc
class _$PropertyDetailCopyWithImpl<$Res, $Val extends PropertyDetail>
    implements $PropertyDetailCopyWith<$Res> {
  _$PropertyDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? property = null, Object? activeLease = freezed}) {
    return _then(
      _value.copyWith(
            property: null == property
                ? _value.property
                : property // ignore: cast_nullable_to_non_nullable
                      as Property,
            activeLease: freezed == activeLease
                ? _value.activeLease
                : activeLease // ignore: cast_nullable_to_non_nullable
                      as Lease?,
          )
          as $Val,
    );
  }

  /// Create a copy of PropertyDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyCopyWith<$Res> get property {
    return $PropertyCopyWith<$Res>(_value.property, (value) {
      return _then(_value.copyWith(property: value) as $Val);
    });
  }

  /// Create a copy of PropertyDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeaseCopyWith<$Res>? get activeLease {
    if (_value.activeLease == null) {
      return null;
    }

    return $LeaseCopyWith<$Res>(_value.activeLease!, (value) {
      return _then(_value.copyWith(activeLease: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PropertyDetailImplCopyWith<$Res>
    implements $PropertyDetailCopyWith<$Res> {
  factory _$$PropertyDetailImplCopyWith(
    _$PropertyDetailImpl value,
    $Res Function(_$PropertyDetailImpl) then,
  ) = __$$PropertyDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Property property,
    @JsonKey(name: 'active_lease') Lease? activeLease,
  });

  @override
  $PropertyCopyWith<$Res> get property;
  @override
  $LeaseCopyWith<$Res>? get activeLease;
}

/// @nodoc
class __$$PropertyDetailImplCopyWithImpl<$Res>
    extends _$PropertyDetailCopyWithImpl<$Res, _$PropertyDetailImpl>
    implements _$$PropertyDetailImplCopyWith<$Res> {
  __$$PropertyDetailImplCopyWithImpl(
    _$PropertyDetailImpl _value,
    $Res Function(_$PropertyDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? property = null, Object? activeLease = freezed}) {
    return _then(
      _$PropertyDetailImpl(
        property: null == property
            ? _value.property
            : property // ignore: cast_nullable_to_non_nullable
                  as Property,
        activeLease: freezed == activeLease
            ? _value.activeLease
            : activeLease // ignore: cast_nullable_to_non_nullable
                  as Lease?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyDetailImpl implements _PropertyDetail {
  const _$PropertyDetailImpl({
    required this.property,
    @JsonKey(name: 'active_lease') this.activeLease,
  });

  factory _$PropertyDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyDetailImplFromJson(json);

  @override
  final Property property;
  @override
  @JsonKey(name: 'active_lease')
  final Lease? activeLease;

  @override
  String toString() {
    return 'PropertyDetail(property: $property, activeLease: $activeLease)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyDetailImpl &&
            (identical(other.property, property) ||
                other.property == property) &&
            (identical(other.activeLease, activeLease) ||
                other.activeLease == activeLease));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, property, activeLease);

  /// Create a copy of PropertyDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyDetailImplCopyWith<_$PropertyDetailImpl> get copyWith =>
      __$$PropertyDetailImplCopyWithImpl<_$PropertyDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyDetailImplToJson(this);
  }
}

abstract class _PropertyDetail implements PropertyDetail {
  const factory _PropertyDetail({
    required final Property property,
    @JsonKey(name: 'active_lease') final Lease? activeLease,
  }) = _$PropertyDetailImpl;

  factory _PropertyDetail.fromJson(Map<String, dynamic> json) =
      _$PropertyDetailImpl.fromJson;

  @override
  Property get property;
  @override
  @JsonKey(name: 'active_lease')
  Lease? get activeLease;

  /// Create a copy of PropertyDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyDetailImplCopyWith<_$PropertyDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
