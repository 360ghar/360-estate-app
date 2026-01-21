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
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id', fromJson: parseInt)
  int? get tenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_name')
  String? get tenantName => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_at', fromJson: parseDateTime)
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'signed_at', fromJson: parseDateTime)
  DateTime? get signedAt => throw _privateConstructorUsedError;
  List<InspectionItem>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) int? tenantId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    String? title,
    String? status,
    @JsonKey(name: 'scheduled_at', fromJson: parseDateTime)
    DateTime? scheduledAt,
    @JsonKey(name: 'signed_at', fromJson: parseDateTime) DateTime? signedAt,
    List<InspectionItem>? items,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
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
    Object? propertyName = freezed,
    Object? tenantId = freezed,
    Object? tenantName = freezed,
    Object? title = freezed,
    Object? status = freezed,
    Object? scheduledAt = freezed,
    Object? signedAt = freezed,
    Object? items = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenantId: freezed == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            tenantName: freezed == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            signedAt: freezed == signedAt
                ? _value.signedAt
                : signedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            items: freezed == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<InspectionItem>?,
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
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) int? tenantId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    String? title,
    String? status,
    @JsonKey(name: 'scheduled_at', fromJson: parseDateTime)
    DateTime? scheduledAt,
    @JsonKey(name: 'signed_at', fromJson: parseDateTime) DateTime? signedAt,
    List<InspectionItem>? items,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
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
    Object? propertyName = freezed,
    Object? tenantId = freezed,
    Object? tenantName = freezed,
    Object? title = freezed,
    Object? status = freezed,
    Object? scheduledAt = freezed,
    Object? signedAt = freezed,
    Object? items = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenantId: freezed == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        tenantName: freezed == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        signedAt: freezed == signedAt
            ? _value.signedAt
            : signedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        items: freezed == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<InspectionItem>?,
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
class _$InspectionImpl implements _Inspection {
  const _$InspectionImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) this.tenantId,
    @JsonKey(name: 'tenant_name') this.tenantName,
    this.title,
    this.status,
    @JsonKey(name: 'scheduled_at', fromJson: parseDateTime) this.scheduledAt,
    @JsonKey(name: 'signed_at', fromJson: parseDateTime) this.signedAt,
    final List<InspectionItem>? items,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) this.updatedAt,
  }) : _items = items;

  factory _$InspectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'tenant_id', fromJson: parseInt)
  final int? tenantId;
  @override
  @JsonKey(name: 'tenant_name')
  final String? tenantName;
  @override
  final String? title;
  @override
  final String? status;
  @override
  @JsonKey(name: 'scheduled_at', fromJson: parseDateTime)
  final DateTime? scheduledAt;
  @override
  @JsonKey(name: 'signed_at', fromJson: parseDateTime)
  final DateTime? signedAt;
  final List<InspectionItem>? _items;
  @override
  List<InspectionItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Inspection(id: $id, propertyId: $propertyId, propertyName: $propertyName, tenantId: $tenantId, tenantName: $tenantName, title: $title, status: $status, scheduledAt: $scheduledAt, signedAt: $signedAt, items: $items, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.signedAt, signedAt) ||
                other.signedAt == signedAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    propertyId,
    propertyName,
    tenantId,
    tenantName,
    title,
    status,
    scheduledAt,
    signedAt,
    const DeepCollectionEquality().hash(_items),
    createdAt,
    updatedAt,
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
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) final int? tenantId,
    @JsonKey(name: 'tenant_name') final String? tenantName,
    final String? title,
    final String? status,
    @JsonKey(name: 'scheduled_at', fromJson: parseDateTime)
    final DateTime? scheduledAt,
    @JsonKey(name: 'signed_at', fromJson: parseDateTime)
    final DateTime? signedAt,
    final List<InspectionItem>? items,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime)
    final DateTime? updatedAt,
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
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'tenant_id', fromJson: parseInt)
  int? get tenantId;
  @override
  @JsonKey(name: 'tenant_name')
  String? get tenantName;
  @override
  String? get title;
  @override
  String? get status;
  @override
  @JsonKey(name: 'scheduled_at', fromJson: parseDateTime)
  DateTime? get scheduledAt;
  @override
  @JsonKey(name: 'signed_at', fromJson: parseDateTime)
  DateTime? get signedAt;
  @override
  List<InspectionItem>? get items;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt;

  /// Create a copy of Inspection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InspectionImplCopyWith<_$InspectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
