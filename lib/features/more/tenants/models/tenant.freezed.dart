// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Tenant _$TenantFromJson(Map<String, dynamic> json) {
  return _Tenant.fromJson(json);
}

/// @nodoc
mixin _$Tenant {
  @JsonKey(name: 'user_id', fromJson: parseInt)
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
  TenantStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_leases_count', fromJson: parseInt)
  int? get activeLeasesCount => throw _privateConstructorUsedError; // Only the detail route sends the leases.
  List<Lease>? get leases => throw _privateConstructorUsedError;

  /// Serializes this Tenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantCopyWith<Tenant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantCopyWith<$Res> {
  factory $TenantCopyWith(Tenant value, $Res Function(Tenant) then) =
      _$TenantCopyWithImpl<$Res, Tenant>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id', fromJson: parseInt) int? userId,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    String? email,
    @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
    TenantStatus? status,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'active_leases_count', fromJson: parseInt)
    int? activeLeasesCount,
    List<Lease>? leases,
  });
}

/// @nodoc
class _$TenantCopyWithImpl<$Res, $Val extends Tenant>
    implements $TenantCopyWith<$Res> {
  _$TenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? status = freezed,
    Object? propertyName = freezed,
    Object? activeLeasesCount = freezed,
    Object? leases = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TenantStatus?,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            activeLeasesCount: freezed == activeLeasesCount
                ? _value.activeLeasesCount
                : activeLeasesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            leases: freezed == leases
                ? _value.leases
                : leases // ignore: cast_nullable_to_non_nullable
                      as List<Lease>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantImplCopyWith<$Res> implements $TenantCopyWith<$Res> {
  factory _$$TenantImplCopyWith(
    _$TenantImpl value,
    $Res Function(_$TenantImpl) then,
  ) = __$$TenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id', fromJson: parseInt) int? userId,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    String? email,
    @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
    TenantStatus? status,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'active_leases_count', fromJson: parseInt)
    int? activeLeasesCount,
    List<Lease>? leases,
  });
}

/// @nodoc
class __$$TenantImplCopyWithImpl<$Res>
    extends _$TenantCopyWithImpl<$Res, _$TenantImpl>
    implements _$$TenantImplCopyWith<$Res> {
  __$$TenantImplCopyWithImpl(
    _$TenantImpl _value,
    $Res Function(_$TenantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? status = freezed,
    Object? propertyName = freezed,
    Object? activeLeasesCount = freezed,
    Object? leases = freezed,
  }) {
    return _then(
      _$TenantImpl(
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TenantStatus?,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        activeLeasesCount: freezed == activeLeasesCount
            ? _value.activeLeasesCount
            : activeLeasesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        leases: freezed == leases
            ? _value._leases
            : leases // ignore: cast_nullable_to_non_nullable
                  as List<Lease>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantImpl implements _Tenant {
  const _$TenantImpl({
    @JsonKey(name: 'user_id', fromJson: parseInt) this.userId,
    @JsonKey(name: 'full_name') this.fullName,
    this.phone,
    this.email,
    @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
    this.status,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(name: 'active_leases_count', fromJson: parseInt)
    this.activeLeasesCount,
    final List<Lease>? leases,
  }) : _leases = leases;

  factory _$TenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantImplFromJson(json);

  @override
  @JsonKey(name: 'user_id', fromJson: parseInt)
  final int? userId;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
  final TenantStatus? status;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'active_leases_count', fromJson: parseInt)
  final int? activeLeasesCount;
  // Only the detail route sends the leases.
  final List<Lease>? _leases;
  // Only the detail route sends the leases.
  @override
  List<Lease>? get leases {
    final value = _leases;
    if (value == null) return null;
    if (_leases is EqualUnmodifiableListView) return _leases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Tenant(userId: $userId, fullName: $fullName, phone: $phone, email: $email, status: $status, propertyName: $propertyName, activeLeasesCount: $activeLeasesCount, leases: $leases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.activeLeasesCount, activeLeasesCount) ||
                other.activeLeasesCount == activeLeasesCount) &&
            const DeepCollectionEquality().equals(other._leases, _leases));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    fullName,
    phone,
    email,
    status,
    propertyName,
    activeLeasesCount,
    const DeepCollectionEquality().hash(_leases),
  );

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      __$$TenantImplCopyWithImpl<_$TenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantImplToJson(this);
  }
}

abstract class _Tenant implements Tenant {
  const factory _Tenant({
    @JsonKey(name: 'user_id', fromJson: parseInt) final int? userId,
    @JsonKey(name: 'full_name') final String? fullName,
    final String? phone,
    final String? email,
    @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
    final TenantStatus? status,
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(name: 'active_leases_count', fromJson: parseInt)
    final int? activeLeasesCount,
    final List<Lease>? leases,
  }) = _$TenantImpl;

  factory _Tenant.fromJson(Map<String, dynamic> json) = _$TenantImpl.fromJson;

  @override
  @JsonKey(name: 'user_id', fromJson: parseInt)
  int? get userId;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
  TenantStatus? get status;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'active_leases_count', fromJson: parseInt)
  int? get activeLeasesCount; // Only the detail route sends the leases.
  @override
  List<Lease>? get leases;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
