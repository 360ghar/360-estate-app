// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rent_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RentPayment _$RentPaymentFromJson(Map<String, dynamic> json) {
  return _RentPayment.fromJson(json);
}

/// @nodoc
mixin _$RentPayment {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_name')
  String? get tenantName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at', fromJson: parseDateTime)
  DateTime? get paidAt => throw _privateConstructorUsedError;
  String? get method => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this RentPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RentPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentPaymentCopyWith<RentPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentPaymentCopyWith<$Res> {
  factory $RentPaymentCopyWith(
    RentPayment value,
    $Res Function(RentPayment) then,
  ) = _$RentPaymentCopyWithImpl<$Res, RentPayment>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) DateTime? paidAt,
    String? method,
    String? notes,
  });
}

/// @nodoc
class _$RentPaymentCopyWithImpl<$Res, $Val extends RentPayment>
    implements $RentPaymentCopyWith<$Res> {
  _$RentPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tenantName = freezed,
    Object? amount = freezed,
    Object? paidAt = freezed,
    Object? method = freezed,
    Object? notes = freezed,
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
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            method: freezed == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RentPaymentImplCopyWith<$Res>
    implements $RentPaymentCopyWith<$Res> {
  factory _$$RentPaymentImplCopyWith(
    _$RentPaymentImpl value,
    $Res Function(_$RentPaymentImpl) then,
  ) = __$$RentPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) DateTime? paidAt,
    String? method,
    String? notes,
  });
}

/// @nodoc
class __$$RentPaymentImplCopyWithImpl<$Res>
    extends _$RentPaymentCopyWithImpl<$Res, _$RentPaymentImpl>
    implements _$$RentPaymentImplCopyWith<$Res> {
  __$$RentPaymentImplCopyWithImpl(
    _$RentPaymentImpl _value,
    $Res Function(_$RentPaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RentPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tenantName = freezed,
    Object? amount = freezed,
    Object? paidAt = freezed,
    Object? method = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$RentPaymentImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        tenantName: freezed == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        method: freezed == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RentPaymentImpl implements _RentPayment {
  const _$RentPaymentImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'tenant_name') this.tenantName,
    @JsonKey(fromJson: parseDouble) this.amount,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) this.paidAt,
    this.method,
    this.notes,
  });

  factory _$RentPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentPaymentImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'tenant_name')
  final String? tenantName;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? amount;
  @override
  @JsonKey(name: 'paid_at', fromJson: parseDateTime)
  final DateTime? paidAt;
  @override
  final String? method;
  @override
  final String? notes;

  @override
  String toString() {
    return 'RentPayment(id: $id, tenantName: $tenantName, amount: $amount, paidAt: $paidAt, method: $method, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tenantName, amount, paidAt, method, notes);

  /// Create a copy of RentPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentPaymentImplCopyWith<_$RentPaymentImpl> get copyWith =>
      __$$RentPaymentImplCopyWithImpl<_$RentPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RentPaymentImplToJson(this);
  }
}

abstract class _RentPayment implements RentPayment {
  const factory _RentPayment({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'tenant_name') final String? tenantName,
    @JsonKey(fromJson: parseDouble) final double? amount,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) final DateTime? paidAt,
    final String? method,
    final String? notes,
  }) = _$RentPaymentImpl;

  factory _RentPayment.fromJson(Map<String, dynamic> json) =
      _$RentPaymentImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'tenant_name')
  String? get tenantName;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get amount;
  @override
  @JsonKey(name: 'paid_at', fromJson: parseDateTime)
  DateTime? get paidAt;
  @override
  String? get method;
  @override
  String? get notes;

  /// Create a copy of RentPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentPaymentImplCopyWith<_$RentPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
