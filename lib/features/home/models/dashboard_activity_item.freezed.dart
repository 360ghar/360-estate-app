// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_activity_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardActivityItem _$DashboardActivityItemFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardActivityItem.fromJson(json);
}

/// @nodoc
mixin _$DashboardActivityItem {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'at')
  String? get at => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get amount => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DashboardActivityItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardActivityItemCopyWith<DashboardActivityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardActivityItemCopyWith<$Res> {
  factory $DashboardActivityItemCopyWith(
    DashboardActivityItem value,
    $Res Function(DashboardActivityItem) then,
  ) = _$DashboardActivityItemCopyWithImpl<$Res, DashboardActivityItem>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? type,
    String? title,
    String? message,
    @JsonKey(name: 'at') String? at,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(fromJson: parseDouble) double? amount,
    String? status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class _$DashboardActivityItemCopyWithImpl<
  $Res,
  $Val extends DashboardActivityItem
>
    implements $DashboardActivityItemCopyWith<$Res> {
  _$DashboardActivityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? message = freezed,
    Object? at = freezed,
    Object? propertyId = freezed,
    Object? leaseId = freezed,
    Object? amount = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            at: freezed == at
                ? _value.at
                : at // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyId: freezed == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            leaseId: freezed == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$DashboardActivityItemImplCopyWith<$Res>
    implements $DashboardActivityItemCopyWith<$Res> {
  factory _$$DashboardActivityItemImplCopyWith(
    _$DashboardActivityItemImpl value,
    $Res Function(_$DashboardActivityItemImpl) then,
  ) = __$$DashboardActivityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? type,
    String? title,
    String? message,
    @JsonKey(name: 'at') String? at,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(fromJson: parseDouble) double? amount,
    String? status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class __$$DashboardActivityItemImplCopyWithImpl<$Res>
    extends
        _$DashboardActivityItemCopyWithImpl<$Res, _$DashboardActivityItemImpl>
    implements _$$DashboardActivityItemImplCopyWith<$Res> {
  __$$DashboardActivityItemImplCopyWithImpl(
    _$DashboardActivityItemImpl _value,
    $Res Function(_$DashboardActivityItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? message = freezed,
    Object? at = freezed,
    Object? propertyId = freezed,
    Object? leaseId = freezed,
    Object? amount = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$DashboardActivityItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        at: freezed == at
            ? _value.at
            : at // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyId: freezed == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        leaseId: freezed == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$DashboardActivityItemImpl implements _DashboardActivityItem {
  const _$DashboardActivityItemImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.type,
    this.title,
    this.message,
    @JsonKey(name: 'at') this.at,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) this.leaseId,
    @JsonKey(fromJson: parseDouble) this.amount,
    this.status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  });

  factory _$DashboardActivityItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardActivityItemImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? type;
  @override
  final String? title;
  @override
  final String? message;
  @override
  @JsonKey(name: 'at')
  final String? at;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  final int? propertyId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  final int? leaseId;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? amount;
  @override
  final String? status;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'DashboardActivityItem(id: $id, type: $type, title: $title, message: $message, at: $at, propertyId: $propertyId, leaseId: $leaseId, amount: $amount, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardActivityItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.at, at) || other.at == at) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    title,
    message,
    at,
    propertyId,
    leaseId,
    amount,
    status,
    createdAt,
  );

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardActivityItemImplCopyWith<_$DashboardActivityItemImpl>
  get copyWith =>
      __$$DashboardActivityItemImplCopyWithImpl<_$DashboardActivityItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardActivityItemImplToJson(this);
  }
}

abstract class _DashboardActivityItem implements DashboardActivityItem {
  const factory _DashboardActivityItem({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? type,
    final String? title,
    final String? message,
    @JsonKey(name: 'at') final String? at,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) final int? leaseId,
    @JsonKey(fromJson: parseDouble) final double? amount,
    final String? status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$DashboardActivityItemImpl;

  factory _DashboardActivityItem.fromJson(Map<String, dynamic> json) =
      _$DashboardActivityItemImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get type;
  @override
  String? get title;
  @override
  String? get message;
  @override
  @JsonKey(name: 'at')
  String? get at;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get amount;
  @override
  String? get status;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardActivityItemImplCopyWith<_$DashboardActivityItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}
