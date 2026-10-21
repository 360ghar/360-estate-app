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
  @JsonKey(name: 'charge_id', fromJson: parseInt)
  int? get chargeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
  int? get tenantUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at', fromJson: parseDateTime)
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_paid', fromJson: parseDouble)
  double? get amountPaid => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'payment_method',
    fromJson: PaymentMethod.fromJson,
    toJson: PaymentMethod.toJsonValue,
  )
  PaymentMethod? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: RentPaymentStatus.fromJson,
    toJson: RentPaymentStatus.toJsonValue,
  )
  RentPaymentStatus? get status => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'charge_id', fromJson: parseInt) int? chargeId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) DateTime? paidAt,
    @JsonKey(name: 'amount_paid', fromJson: parseDouble) double? amountPaid,
    @JsonKey(
      name: 'payment_method',
      fromJson: PaymentMethod.fromJson,
      toJson: PaymentMethod.toJsonValue,
    )
    PaymentMethod? paymentMethod,
    @JsonKey(
      fromJson: RentPaymentStatus.fromJson,
      toJson: RentPaymentStatus.toJsonValue,
    )
    RentPaymentStatus? status,
    String? reference,
    String? notes,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
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
    Object? chargeId = freezed,
    Object? leaseId = freezed,
    Object? propertyId = freezed,
    Object? tenantUserId = freezed,
    Object? paidAt = freezed,
    Object? amountPaid = freezed,
    Object? paymentMethod = freezed,
    Object? status = freezed,
    Object? reference = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            chargeId: freezed == chargeId
                ? _value.chargeId
                : chargeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            leaseId: freezed == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            propertyId: freezed == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            tenantUserId: freezed == tenantUserId
                ? _value.tenantUserId
                : tenantUserId // ignore: cast_nullable_to_non_nullable
                      as int?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            amountPaid: freezed == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as double?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RentPaymentStatus?,
            reference: freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: 'charge_id', fromJson: parseInt) int? chargeId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) DateTime? paidAt,
    @JsonKey(name: 'amount_paid', fromJson: parseDouble) double? amountPaid,
    @JsonKey(
      name: 'payment_method',
      fromJson: PaymentMethod.fromJson,
      toJson: PaymentMethod.toJsonValue,
    )
    PaymentMethod? paymentMethod,
    @JsonKey(
      fromJson: RentPaymentStatus.fromJson,
      toJson: RentPaymentStatus.toJsonValue,
    )
    RentPaymentStatus? status,
    String? reference,
    String? notes,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
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
    Object? chargeId = freezed,
    Object? leaseId = freezed,
    Object? propertyId = freezed,
    Object? tenantUserId = freezed,
    Object? paidAt = freezed,
    Object? amountPaid = freezed,
    Object? paymentMethod = freezed,
    Object? status = freezed,
    Object? reference = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$RentPaymentImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        chargeId: freezed == chargeId
            ? _value.chargeId
            : chargeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        leaseId: freezed == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        propertyId: freezed == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        tenantUserId: freezed == tenantUserId
            ? _value.tenantUserId
            : tenantUserId // ignore: cast_nullable_to_non_nullable
                  as int?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        amountPaid: freezed == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as double?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RentPaymentStatus?,
        reference: freezed == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
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
class _$RentPaymentImpl implements _RentPayment {
  const _$RentPaymentImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'charge_id', fromJson: parseInt) this.chargeId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) this.leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) this.tenantUserId,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) this.paidAt,
    @JsonKey(name: 'amount_paid', fromJson: parseDouble) this.amountPaid,
    @JsonKey(
      name: 'payment_method',
      fromJson: PaymentMethod.fromJson,
      toJson: PaymentMethod.toJsonValue,
    )
    this.paymentMethod,
    @JsonKey(
      fromJson: RentPaymentStatus.fromJson,
      toJson: RentPaymentStatus.toJsonValue,
    )
    this.status,
    this.reference,
    this.notes,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  });

  factory _$RentPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentPaymentImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'charge_id', fromJson: parseInt)
  final int? chargeId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  final int? leaseId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  final int? propertyId;
  @override
  @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
  final int? tenantUserId;
  @override
  @JsonKey(name: 'paid_at', fromJson: parseDateTime)
  final DateTime? paidAt;
  @override
  @JsonKey(name: 'amount_paid', fromJson: parseDouble)
  final double? amountPaid;
  @override
  @JsonKey(
    name: 'payment_method',
    fromJson: PaymentMethod.fromJson,
    toJson: PaymentMethod.toJsonValue,
  )
  final PaymentMethod? paymentMethod;
  @override
  @JsonKey(
    fromJson: RentPaymentStatus.fromJson,
    toJson: RentPaymentStatus.toJsonValue,
  )
  final RentPaymentStatus? status;
  @override
  final String? reference;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'RentPayment(id: $id, chargeId: $chargeId, leaseId: $leaseId, propertyId: $propertyId, tenantUserId: $tenantUserId, paidAt: $paidAt, amountPaid: $amountPaid, paymentMethod: $paymentMethod, status: $status, reference: $reference, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chargeId, chargeId) ||
                other.chargeId == chargeId) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.tenantUserId, tenantUserId) ||
                other.tenantUserId == tenantUserId) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    chargeId,
    leaseId,
    propertyId,
    tenantUserId,
    paidAt,
    amountPaid,
    paymentMethod,
    status,
    reference,
    notes,
    createdAt,
  );

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
    @JsonKey(name: 'charge_id', fromJson: parseInt) final int? chargeId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) final int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
    final int? tenantUserId,
    @JsonKey(name: 'paid_at', fromJson: parseDateTime) final DateTime? paidAt,
    @JsonKey(name: 'amount_paid', fromJson: parseDouble)
    final double? amountPaid,
    @JsonKey(
      name: 'payment_method',
      fromJson: PaymentMethod.fromJson,
      toJson: PaymentMethod.toJsonValue,
    )
    final PaymentMethod? paymentMethod,
    @JsonKey(
      fromJson: RentPaymentStatus.fromJson,
      toJson: RentPaymentStatus.toJsonValue,
    )
    final RentPaymentStatus? status,
    final String? reference,
    final String? notes,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$RentPaymentImpl;

  factory _RentPayment.fromJson(Map<String, dynamic> json) =
      _$RentPaymentImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'charge_id', fromJson: parseInt)
  int? get chargeId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId;
  @override
  @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
  int? get tenantUserId;
  @override
  @JsonKey(name: 'paid_at', fromJson: parseDateTime)
  DateTime? get paidAt;
  @override
  @JsonKey(name: 'amount_paid', fromJson: parseDouble)
  double? get amountPaid;
  @override
  @JsonKey(
    name: 'payment_method',
    fromJson: PaymentMethod.fromJson,
    toJson: PaymentMethod.toJsonValue,
  )
  PaymentMethod? get paymentMethod;
  @override
  @JsonKey(
    fromJson: RentPaymentStatus.fromJson,
    toJson: RentPaymentStatus.toJsonValue,
  )
  RentPaymentStatus? get status;
  @override
  String? get reference;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of RentPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentPaymentImplCopyWith<_$RentPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RentChargeGenerateResult _$RentChargeGenerateResultFromJson(
  Map<String, dynamic> json,
) {
  return _RentChargeGenerateResult.fromJson(json);
}

/// @nodoc
mixin _$RentChargeGenerateResult {
  @JsonKey(fromJson: parseInt)
  int? get created => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseInt)
  int? get skipped => throw _privateConstructorUsedError;

  /// Serializes this RentChargeGenerateResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RentChargeGenerateResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentChargeGenerateResultCopyWith<RentChargeGenerateResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentChargeGenerateResultCopyWith<$Res> {
  factory $RentChargeGenerateResultCopyWith(
    RentChargeGenerateResult value,
    $Res Function(RentChargeGenerateResult) then,
  ) = _$RentChargeGenerateResultCopyWithImpl<$Res, RentChargeGenerateResult>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? created,
    @JsonKey(fromJson: parseInt) int? skipped,
  });
}

/// @nodoc
class _$RentChargeGenerateResultCopyWithImpl<
  $Res,
  $Val extends RentChargeGenerateResult
>
    implements $RentChargeGenerateResultCopyWith<$Res> {
  _$RentChargeGenerateResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentChargeGenerateResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? created = freezed, Object? skipped = freezed}) {
    return _then(
      _value.copyWith(
            created: freezed == created
                ? _value.created
                : created // ignore: cast_nullable_to_non_nullable
                      as int?,
            skipped: freezed == skipped
                ? _value.skipped
                : skipped // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RentChargeGenerateResultImplCopyWith<$Res>
    implements $RentChargeGenerateResultCopyWith<$Res> {
  factory _$$RentChargeGenerateResultImplCopyWith(
    _$RentChargeGenerateResultImpl value,
    $Res Function(_$RentChargeGenerateResultImpl) then,
  ) = __$$RentChargeGenerateResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? created,
    @JsonKey(fromJson: parseInt) int? skipped,
  });
}

/// @nodoc
class __$$RentChargeGenerateResultImplCopyWithImpl<$Res>
    extends
        _$RentChargeGenerateResultCopyWithImpl<
          $Res,
          _$RentChargeGenerateResultImpl
        >
    implements _$$RentChargeGenerateResultImplCopyWith<$Res> {
  __$$RentChargeGenerateResultImplCopyWithImpl(
    _$RentChargeGenerateResultImpl _value,
    $Res Function(_$RentChargeGenerateResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RentChargeGenerateResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? created = freezed, Object? skipped = freezed}) {
    return _then(
      _$RentChargeGenerateResultImpl(
        created: freezed == created
            ? _value.created
            : created // ignore: cast_nullable_to_non_nullable
                  as int?,
        skipped: freezed == skipped
            ? _value.skipped
            : skipped // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RentChargeGenerateResultImpl implements _RentChargeGenerateResult {
  const _$RentChargeGenerateResultImpl({
    @JsonKey(fromJson: parseInt) this.created,
    @JsonKey(fromJson: parseInt) this.skipped,
  });

  factory _$RentChargeGenerateResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentChargeGenerateResultImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? created;
  @override
  @JsonKey(fromJson: parseInt)
  final int? skipped;

  @override
  String toString() {
    return 'RentChargeGenerateResult(created: $created, skipped: $skipped)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentChargeGenerateResultImpl &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.skipped, skipped) || other.skipped == skipped));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, created, skipped);

  /// Create a copy of RentChargeGenerateResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentChargeGenerateResultImplCopyWith<_$RentChargeGenerateResultImpl>
  get copyWith =>
      __$$RentChargeGenerateResultImplCopyWithImpl<
        _$RentChargeGenerateResultImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RentChargeGenerateResultImplToJson(this);
  }
}

abstract class _RentChargeGenerateResult implements RentChargeGenerateResult {
  const factory _RentChargeGenerateResult({
    @JsonKey(fromJson: parseInt) final int? created,
    @JsonKey(fromJson: parseInt) final int? skipped,
  }) = _$RentChargeGenerateResultImpl;

  factory _RentChargeGenerateResult.fromJson(Map<String, dynamic> json) =
      _$RentChargeGenerateResultImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get created;
  @override
  @JsonKey(fromJson: parseInt)
  int? get skipped;

  /// Create a copy of RentChargeGenerateResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentChargeGenerateResultImplCopyWith<_$RentChargeGenerateResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
