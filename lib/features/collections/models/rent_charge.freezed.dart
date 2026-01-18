// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rent_charge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RentCharge _$RentChargeFromJson(Map<String, dynamic> json) {
  return _RentCharge.fromJson(json);
}

/// @nodoc
mixin _$RentCharge {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_name')
  String? get tenantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date', fromJson: parseDateTime)
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this RentCharge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RentCharge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentChargeCopyWith<RentCharge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentChargeCopyWith<$Res> {
  factory $RentChargeCopyWith(
    RentCharge value,
    $Res Function(RentCharge) then,
  ) = _$RentChargeCopyWithImpl<$Res, RentCharge>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) DateTime? dueDate,
    String? status,
  });
}

/// @nodoc
class _$RentChargeCopyWithImpl<$Res, $Val extends RentCharge>
    implements $RentChargeCopyWith<$Res> {
  _$RentChargeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentCharge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tenantName = freezed,
    Object? propertyName = freezed,
    Object? amount = freezed,
    Object? dueDate = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            tenantName: freezed == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RentChargeImplCopyWith<$Res>
    implements $RentChargeCopyWith<$Res> {
  factory _$$RentChargeImplCopyWith(
    _$RentChargeImpl value,
    $Res Function(_$RentChargeImpl) then,
  ) = __$$RentChargeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) DateTime? dueDate,
    String? status,
  });
}

/// @nodoc
class __$$RentChargeImplCopyWithImpl<$Res>
    extends _$RentChargeCopyWithImpl<$Res, _$RentChargeImpl>
    implements _$$RentChargeImplCopyWith<$Res> {
  __$$RentChargeImplCopyWithImpl(
    _$RentChargeImpl _value,
    $Res Function(_$RentChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RentCharge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tenantName = freezed,
    Object? propertyName = freezed,
    Object? amount = freezed,
    Object? dueDate = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _$RentChargeImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        tenantName: freezed == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RentChargeImpl implements _RentCharge {
  const _$RentChargeImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'tenant_name') this.tenantName,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(fromJson: parseDouble) this.amount,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) this.dueDate,
    this.status,
  });

  factory _$RentChargeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentChargeImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'tenant_name')
  final String? tenantName;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? amount;
  @override
  @JsonKey(name: 'due_date', fromJson: parseDateTime)
  final DateTime? dueDate;
  @override
  final String? status;

  @override
  String toString() {
    return 'RentCharge(id: $id, tenantName: $tenantName, propertyName: $propertyName, amount: $amount, dueDate: $dueDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentChargeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tenantName,
    propertyName,
    amount,
    dueDate,
    status,
  );

  /// Create a copy of RentCharge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentChargeImplCopyWith<_$RentChargeImpl> get copyWith =>
      __$$RentChargeImplCopyWithImpl<_$RentChargeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RentChargeImplToJson(this);
  }
}

abstract class _RentCharge implements RentCharge {
  const factory _RentCharge({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'tenant_name') final String? tenantName,
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(fromJson: parseDouble) final double? amount,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) final DateTime? dueDate,
    final String? status,
  }) = _$RentChargeImpl;

  factory _RentCharge.fromJson(Map<String, dynamic> json) =
      _$RentChargeImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'tenant_name')
  String? get tenantName;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get amount;
  @override
  @JsonKey(name: 'due_date', fromJson: parseDateTime)
  DateTime? get dueDate;
  @override
  String? get status;

  /// Create a copy of RentCharge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentChargeImplCopyWith<_$RentChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
