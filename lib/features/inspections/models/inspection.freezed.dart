// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InspectionItem _$InspectionItemFromJson(Map<String, dynamic> json) {
  return _InspectionItem.fromJson(json);
}

/// @nodoc
mixin _$InspectionItem {
  String? get title => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_required')
  bool? get isRequired => throw _privateConstructorUsedError;

  /// Serializes this InspectionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InspectionItemCopyWith<InspectionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionItemCopyWith<$Res> {
  factory $InspectionItemCopyWith(
    InspectionItem value,
    $Res Function(InspectionItem) then,
  ) = _$InspectionItemCopyWithImpl<$Res, InspectionItem>;
  @useResult
  $Res call({
    String? title,
    String? status,
    String? notes,
    @JsonKey(name: 'is_required') bool? isRequired,
  });
}

/// @nodoc
class _$InspectionItemCopyWithImpl<$Res, $Val extends InspectionItem>
    implements $InspectionItemCopyWith<$Res> {
  _$InspectionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? status = freezed,
    Object? notes = freezed,
    Object? isRequired = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRequired: freezed == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InspectionItemImplCopyWith<$Res>
    implements $InspectionItemCopyWith<$Res> {
  factory _$$InspectionItemImplCopyWith(
    _$InspectionItemImpl value,
    $Res Function(_$InspectionItemImpl) then,
  ) = __$$InspectionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? title,
    String? status,
    String? notes,
    @JsonKey(name: 'is_required') bool? isRequired,
  });
}

/// @nodoc
class __$$InspectionItemImplCopyWithImpl<$Res>
    extends _$InspectionItemCopyWithImpl<$Res, _$InspectionItemImpl>
    implements _$$InspectionItemImplCopyWith<$Res> {
  __$$InspectionItemImplCopyWithImpl(
    _$InspectionItemImpl _value,
    $Res Function(_$InspectionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? status = freezed,
    Object? notes = freezed,
    Object? isRequired = freezed,
  }) {
    return _then(
      _$InspectionItemImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRequired: freezed == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionItemImpl implements _InspectionItem {
  const _$InspectionItemImpl({
    this.title,
    this.status,
    this.notes,
    @JsonKey(name: 'is_required') this.isRequired,
  });

  factory _$InspectionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionItemImplFromJson(json);

  @override
  final String? title;
  @override
  final String? status;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'is_required')
  final bool? isRequired;

  @override
  String toString() {
    return 'InspectionItem(title: $title, status: $status, notes: $notes, isRequired: $isRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionItemImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, status, notes, isRequired);

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionItemImplCopyWith<_$InspectionItemImpl> get copyWith =>
      __$$InspectionItemImplCopyWithImpl<_$InspectionItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionItemImplToJson(this);
  }
}

abstract class _InspectionItem implements InspectionItem {
  const factory _InspectionItem({
    final String? title,
    final String? status,
    final String? notes,
    @JsonKey(name: 'is_required') final bool? isRequired,
  }) = _$InspectionItemImpl;

  factory _InspectionItem.fromJson(Map<String, dynamic> json) =
      _$InspectionItemImpl.fromJson;

  @override
  String? get title;
  @override
  String? get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'is_required')
  bool? get isRequired;

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InspectionItemImplCopyWith<_$InspectionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Inspection _$InspectionFromJson(Map<String, dynamic> json) {
  return _Inspection.fromJson(json);
}

/// @nodoc
mixin _$Inspection {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'inspection_type',
    fromJson: InspectionType.fromJson,
    toJson: InspectionType.toJsonValue,
  )
  InspectionType? get inspectionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'conducted_at', fromJson: parseDateTime)
  DateTime? get conductedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rooms_data')
  Map<String, dynamic>? get roomsData => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_notes')
  String? get overallNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
  DateTime? get signedByTenantAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
  DateTime? get signedByOwnerAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Inspection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Inspection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InspectionCopyWith<Inspection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionCopyWith<$Res> {
  factory $InspectionCopyWith(
    Inspection value,
    $Res Function(Inspection) then,
  ) = _$InspectionCopyWithImpl<$Res, Inspection>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(
      name: 'inspection_type',
      fromJson: InspectionType.fromJson,
      toJson: InspectionType.toJsonValue,
    )
    InspectionType? inspectionType,
    @JsonKey(name: 'conducted_at', fromJson: parseDateTime)
    DateTime? conductedAt,
    @JsonKey(name: 'rooms_data') Map<String, dynamic>? roomsData,
    @JsonKey(name: 'overall_notes') String? overallNotes,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    DateTime? signedByOwnerAt,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class _$InspectionCopyWithImpl<$Res, $Val extends Inspection>
    implements $InspectionCopyWith<$Res> {
  _$InspectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Inspection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? propertyId = freezed,
    Object? leaseId = freezed,
    Object? ownerId = freezed,
    Object? inspectionType = freezed,
    Object? conductedAt = freezed,
    Object? roomsData = freezed,
    Object? overallNotes = freezed,
    Object? signedByTenantAt = freezed,
    Object? signedByOwnerAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            propertyId: freezed == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            leaseId: freezed == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            inspectionType: freezed == inspectionType
                ? _value.inspectionType
                : inspectionType // ignore: cast_nullable_to_non_nullable
                      as InspectionType?,
            conductedAt: freezed == conductedAt
                ? _value.conductedAt
                : conductedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            roomsData: freezed == roomsData
                ? _value.roomsData
                : roomsData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            overallNotes: freezed == overallNotes
                ? _value.overallNotes
                : overallNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            signedByTenantAt: freezed == signedByTenantAt
                ? _value.signedByTenantAt
                : signedByTenantAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            signedByOwnerAt: freezed == signedByOwnerAt
                ? _value.signedByOwnerAt
                : signedByOwnerAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InspectionImplCopyWith<$Res>
    implements $InspectionCopyWith<$Res> {
  factory _$$InspectionImplCopyWith(
    _$InspectionImpl value,
    $Res Function(_$InspectionImpl) then,
  ) = __$$InspectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(
      name: 'inspection_type',
      fromJson: InspectionType.fromJson,
      toJson: InspectionType.toJsonValue,
    )
    InspectionType? inspectionType,
    @JsonKey(name: 'conducted_at', fromJson: parseDateTime)
    DateTime? conductedAt,
    @JsonKey(name: 'rooms_data') Map<String, dynamic>? roomsData,
    @JsonKey(name: 'overall_notes') String? overallNotes,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    DateTime? signedByOwnerAt,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class __$$InspectionImplCopyWithImpl<$Res>
    extends _$InspectionCopyWithImpl<$Res, _$InspectionImpl>
    implements _$$InspectionImplCopyWith<$Res> {
  __$$InspectionImplCopyWithImpl(
    _$InspectionImpl _value,
    $Res Function(_$InspectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Inspection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? propertyId = freezed,
    Object? leaseId = freezed,
    Object? ownerId = freezed,
    Object? inspectionType = freezed,
    Object? conductedAt = freezed,
    Object? roomsData = freezed,
    Object? overallNotes = freezed,
    Object? signedByTenantAt = freezed,
    Object? signedByOwnerAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$InspectionImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        propertyId: freezed == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        leaseId: freezed == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        inspectionType: freezed == inspectionType
            ? _value.inspectionType
            : inspectionType // ignore: cast_nullable_to_non_nullable
                  as InspectionType?,
        conductedAt: freezed == conductedAt
            ? _value.conductedAt
            : conductedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        roomsData: freezed == roomsData
            ? _value._roomsData
            : roomsData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        overallNotes: freezed == overallNotes
            ? _value.overallNotes
            : overallNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        signedByTenantAt: freezed == signedByTenantAt
            ? _value.signedByTenantAt
            : signedByTenantAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        signedByOwnerAt: freezed == signedByOwnerAt
            ? _value.signedByOwnerAt
            : signedByOwnerAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionImpl implements _Inspection {
  const _$InspectionImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) this.leaseId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) this.ownerId,
    @JsonKey(
      name: 'inspection_type',
      fromJson: InspectionType.fromJson,
      toJson: InspectionType.toJsonValue,
    )
    this.inspectionType,
    @JsonKey(name: 'conducted_at', fromJson: parseDateTime) this.conductedAt,
    @JsonKey(name: 'rooms_data') final Map<String, dynamic>? roomsData,
    @JsonKey(name: 'overall_notes') this.overallNotes,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    this.signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    this.signedByOwnerAt,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  }) : _roomsData = roomsData;

  factory _$InspectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  final int? propertyId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  final int? leaseId;
  @override
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  final int? ownerId;
  @override
  @JsonKey(
    name: 'inspection_type',
    fromJson: InspectionType.fromJson,
    toJson: InspectionType.toJsonValue,
  )
  final InspectionType? inspectionType;
  @override
  @JsonKey(name: 'conducted_at', fromJson: parseDateTime)
  final DateTime? conductedAt;
  final Map<String, dynamic>? _roomsData;
  @override
  @JsonKey(name: 'rooms_data')
  Map<String, dynamic>? get roomsData {
    final value = _roomsData;
    if (value == null) return null;
    if (_roomsData is EqualUnmodifiableMapView) return _roomsData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'overall_notes')
  final String? overallNotes;
  @override
  @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
  final DateTime? signedByTenantAt;
  @override
  @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
  final DateTime? signedByOwnerAt;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Inspection(id: $id, propertyId: $propertyId, leaseId: $leaseId, ownerId: $ownerId, inspectionType: $inspectionType, conductedAt: $conductedAt, roomsData: $roomsData, overallNotes: $overallNotes, signedByTenantAt: $signedByTenantAt, signedByOwnerAt: $signedByOwnerAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.inspectionType, inspectionType) ||
                other.inspectionType == inspectionType) &&
            (identical(other.conductedAt, conductedAt) ||
                other.conductedAt == conductedAt) &&
            const DeepCollectionEquality().equals(
              other._roomsData,
              _roomsData,
            ) &&
            (identical(other.overallNotes, overallNotes) ||
                other.overallNotes == overallNotes) &&
            (identical(other.signedByTenantAt, signedByTenantAt) ||
                other.signedByTenantAt == signedByTenantAt) &&
            (identical(other.signedByOwnerAt, signedByOwnerAt) ||
                other.signedByOwnerAt == signedByOwnerAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    propertyId,
    leaseId,
    ownerId,
    inspectionType,
    conductedAt,
    const DeepCollectionEquality().hash(_roomsData),
    overallNotes,
    signedByTenantAt,
    signedByOwnerAt,
    createdAt,
  );

  /// Create a copy of Inspection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionImplCopyWith<_$InspectionImpl> get copyWith =>
      __$$InspectionImplCopyWithImpl<_$InspectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionImplToJson(this);
  }
}

abstract class _Inspection implements Inspection {
  const factory _Inspection({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) final int? leaseId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) final int? ownerId,
    @JsonKey(
      name: 'inspection_type',
      fromJson: InspectionType.fromJson,
      toJson: InspectionType.toJsonValue,
    )
    final InspectionType? inspectionType,
    @JsonKey(name: 'conducted_at', fromJson: parseDateTime)
    final DateTime? conductedAt,
    @JsonKey(name: 'rooms_data') final Map<String, dynamic>? roomsData,
    @JsonKey(name: 'overall_notes') final String? overallNotes,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    final DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    final DateTime? signedByOwnerAt,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$InspectionImpl;

  factory _Inspection.fromJson(Map<String, dynamic> json) =
      _$InspectionImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId;
  @override
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId;
  @override
  @JsonKey(
    name: 'inspection_type',
    fromJson: InspectionType.fromJson,
    toJson: InspectionType.toJsonValue,
  )
  InspectionType? get inspectionType;
  @override
  @JsonKey(name: 'conducted_at', fromJson: parseDateTime)
  DateTime? get conductedAt;
  @override
  @JsonKey(name: 'rooms_data')
  Map<String, dynamic>? get roomsData;
  @override
  @JsonKey(name: 'overall_notes')
  String? get overallNotes;
  @override
  @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
  DateTime? get signedByTenantAt;
  @override
  @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
  DateTime? get signedByOwnerAt;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of Inspection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InspectionImplCopyWith<_$InspectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
