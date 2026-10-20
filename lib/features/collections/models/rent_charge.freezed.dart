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
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
  int? get tenantUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'billing_month', fromJson: parseDateTime)
  DateTime? get billingMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_start', fromJson: parseDateTime)
  DateTime? get periodStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_end', fromJson: parseDateTime)
  DateTime? get periodEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date', fromJson: parseDateTime)
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_due', fromJson: parseDouble)
  double? get amountDue => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
  double? get lateFeeAssessed => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: RentChargeStatus.fromJson,
    toJson: RentChargeStatus.toJsonValue,
  )
  RentChargeStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'billing_month', fromJson: parseDateTime)
    DateTime? billingMonth,
    @JsonKey(name: 'period_start', fromJson: parseDateTime)
    DateTime? periodStart,
    @JsonKey(name: 'period_end', fromJson: parseDateTime) DateTime? periodEnd,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) DateTime? dueDate,
    @JsonKey(name: 'amount_due', fromJson: parseDouble) double? amountDue,
    @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
    double? lateFeeAssessed,
    @JsonKey(
      fromJson: RentChargeStatus.fromJson,
      toJson: RentChargeStatus.toJsonValue,
    )
    RentChargeStatus? status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
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
    Object? leaseId = freezed,
    Object? propertyId = freezed,
    Object? ownerId = freezed,
    Object? tenantUserId = freezed,
    Object? billingMonth = freezed,
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
    Object? dueDate = freezed,
    Object? amountDue = freezed,
    Object? lateFeeAssessed = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            leaseId: freezed == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            propertyId: freezed == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            tenantUserId: freezed == tenantUserId
                ? _value.tenantUserId
                : tenantUserId // ignore: cast_nullable_to_non_nullable
                      as int?,
            billingMonth: freezed == billingMonth
                ? _value.billingMonth
                : billingMonth // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            periodStart: freezed == periodStart
                ? _value.periodStart
                : periodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            periodEnd: freezed == periodEnd
                ? _value.periodEnd
                : periodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            amountDue: freezed == amountDue
                ? _value.amountDue
                : amountDue // ignore: cast_nullable_to_non_nullable
                      as double?,
            lateFeeAssessed: freezed == lateFeeAssessed
                ? _value.lateFeeAssessed
                : lateFeeAssessed // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RentChargeStatus?,
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
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'billing_month', fromJson: parseDateTime)
    DateTime? billingMonth,
    @JsonKey(name: 'period_start', fromJson: parseDateTime)
    DateTime? periodStart,
    @JsonKey(name: 'period_end', fromJson: parseDateTime) DateTime? periodEnd,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) DateTime? dueDate,
    @JsonKey(name: 'amount_due', fromJson: parseDouble) double? amountDue,
    @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
    double? lateFeeAssessed,
    @JsonKey(
      fromJson: RentChargeStatus.fromJson,
      toJson: RentChargeStatus.toJsonValue,
    )
    RentChargeStatus? status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
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
    Object? leaseId = freezed,
    Object? propertyId = freezed,
    Object? ownerId = freezed,
    Object? tenantUserId = freezed,
    Object? billingMonth = freezed,
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
    Object? dueDate = freezed,
    Object? amountDue = freezed,
    Object? lateFeeAssessed = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$RentChargeImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        leaseId: freezed == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        propertyId: freezed == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        tenantUserId: freezed == tenantUserId
            ? _value.tenantUserId
            : tenantUserId // ignore: cast_nullable_to_non_nullable
                  as int?,
        billingMonth: freezed == billingMonth
            ? _value.billingMonth
            : billingMonth // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        periodStart: freezed == periodStart
            ? _value.periodStart
            : periodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        periodEnd: freezed == periodEnd
            ? _value.periodEnd
            : periodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        amountDue: freezed == amountDue
            ? _value.amountDue
            : amountDue // ignore: cast_nullable_to_non_nullable
                  as double?,
        lateFeeAssessed: freezed == lateFeeAssessed
            ? _value.lateFeeAssessed
            : lateFeeAssessed // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RentChargeStatus?,
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
class _$RentChargeImpl implements _RentCharge {
  const _$RentChargeImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'lease_id', fromJson: parseInt) this.leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) this.ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) this.tenantUserId,
    @JsonKey(name: 'billing_month', fromJson: parseDateTime) this.billingMonth,
    @JsonKey(name: 'period_start', fromJson: parseDateTime) this.periodStart,
    @JsonKey(name: 'period_end', fromJson: parseDateTime) this.periodEnd,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) this.dueDate,
    @JsonKey(name: 'amount_due', fromJson: parseDouble) this.amountDue,
    @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
    this.lateFeeAssessed,
    @JsonKey(
      fromJson: RentChargeStatus.fromJson,
      toJson: RentChargeStatus.toJsonValue,
    )
    this.status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  });

  factory _$RentChargeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentChargeImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  final int? leaseId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  final int? propertyId;
  @override
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  final int? ownerId;
  @override
  @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
  final int? tenantUserId;
  @override
  @JsonKey(name: 'billing_month', fromJson: parseDateTime)
  final DateTime? billingMonth;
  @override
  @JsonKey(name: 'period_start', fromJson: parseDateTime)
  final DateTime? periodStart;
  @override
  @JsonKey(name: 'period_end', fromJson: parseDateTime)
  final DateTime? periodEnd;
  @override
  @JsonKey(name: 'due_date', fromJson: parseDateTime)
  final DateTime? dueDate;
  @override
  @JsonKey(name: 'amount_due', fromJson: parseDouble)
  final double? amountDue;
  @override
  @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
  final double? lateFeeAssessed;
  @override
  @JsonKey(
    fromJson: RentChargeStatus.fromJson,
    toJson: RentChargeStatus.toJsonValue,
  )
  final RentChargeStatus? status;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'RentCharge(id: $id, leaseId: $leaseId, propertyId: $propertyId, ownerId: $ownerId, tenantUserId: $tenantUserId, billingMonth: $billingMonth, periodStart: $periodStart, periodEnd: $periodEnd, dueDate: $dueDate, amountDue: $amountDue, lateFeeAssessed: $lateFeeAssessed, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentChargeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.tenantUserId, tenantUserId) ||
                other.tenantUserId == tenantUserId) &&
            (identical(other.billingMonth, billingMonth) ||
                other.billingMonth == billingMonth) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.amountDue, amountDue) ||
                other.amountDue == amountDue) &&
            (identical(other.lateFeeAssessed, lateFeeAssessed) ||
                other.lateFeeAssessed == lateFeeAssessed) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    leaseId,
    propertyId,
    ownerId,
    tenantUserId,
    billingMonth,
    periodStart,
    periodEnd,
    dueDate,
    amountDue,
    lateFeeAssessed,
    status,
    createdAt,
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
    @JsonKey(name: 'lease_id', fromJson: parseInt) final int? leaseId,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) final int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
    final int? tenantUserId,
    @JsonKey(name: 'billing_month', fromJson: parseDateTime)
    final DateTime? billingMonth,
    @JsonKey(name: 'period_start', fromJson: parseDateTime)
    final DateTime? periodStart,
    @JsonKey(name: 'period_end', fromJson: parseDateTime)
    final DateTime? periodEnd,
    @JsonKey(name: 'due_date', fromJson: parseDateTime) final DateTime? dueDate,
    @JsonKey(name: 'amount_due', fromJson: parseDouble) final double? amountDue,
    @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
    final double? lateFeeAssessed,
    @JsonKey(
      fromJson: RentChargeStatus.fromJson,
      toJson: RentChargeStatus.toJsonValue,
    )
    final RentChargeStatus? status,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$RentChargeImpl;

  factory _RentCharge.fromJson(Map<String, dynamic> json) =
      _$RentChargeImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId;
  @override
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId;
  @override
  @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
  int? get tenantUserId;
  @override
  @JsonKey(name: 'billing_month', fromJson: parseDateTime)
  DateTime? get billingMonth;
  @override
  @JsonKey(name: 'period_start', fromJson: parseDateTime)
  DateTime? get periodStart;
  @override
  @JsonKey(name: 'period_end', fromJson: parseDateTime)
  DateTime? get periodEnd;
  @override
  @JsonKey(name: 'due_date', fromJson: parseDateTime)
  DateTime? get dueDate;
  @override
  @JsonKey(name: 'amount_due', fromJson: parseDouble)
  double? get amountDue;
  @override
  @JsonKey(name: 'late_fee_assessed', fromJson: parseDouble)
  double? get lateFeeAssessed;
  @override
  @JsonKey(
    fromJson: RentChargeStatus.fromJson,
    toJson: RentChargeStatus.toJsonValue,
  )
  RentChargeStatus? get status;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of RentCharge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentChargeImplCopyWith<_$RentChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RentChargeWithTotals _$RentChargeWithTotalsFromJson(Map<String, dynamic> json) {
  return _RentChargeWithTotals.fromJson(json);
}

/// @nodoc
mixin _$RentChargeWithTotals {
  RentCharge get charge => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
  double? get amountPaidTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
  double? get amountDueTotal => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get outstanding => throw _privateConstructorUsedError;

  /// Serializes this RentChargeWithTotals to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RentChargeWithTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentChargeWithTotalsCopyWith<RentChargeWithTotals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentChargeWithTotalsCopyWith<$Res> {
  factory $RentChargeWithTotalsCopyWith(
    RentChargeWithTotals value,
    $Res Function(RentChargeWithTotals) then,
  ) = _$RentChargeWithTotalsCopyWithImpl<$Res, RentChargeWithTotals>;
  @useResult
  $Res call({
    RentCharge charge,
    @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
    double? amountPaidTotal,
    @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
    double? amountDueTotal,
    @JsonKey(fromJson: parseDouble) double? outstanding,
  });

  $RentChargeCopyWith<$Res> get charge;
}

/// @nodoc
class _$RentChargeWithTotalsCopyWithImpl<
  $Res,
  $Val extends RentChargeWithTotals
>
    implements $RentChargeWithTotalsCopyWith<$Res> {
  _$RentChargeWithTotalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentChargeWithTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? charge = null,
    Object? amountPaidTotal = freezed,
    Object? amountDueTotal = freezed,
    Object? outstanding = freezed,
  }) {
    return _then(
      _value.copyWith(
            charge: null == charge
                ? _value.charge
                : charge // ignore: cast_nullable_to_non_nullable
                      as RentCharge,
            amountPaidTotal: freezed == amountPaidTotal
                ? _value.amountPaidTotal
                : amountPaidTotal // ignore: cast_nullable_to_non_nullable
                      as double?,
            amountDueTotal: freezed == amountDueTotal
                ? _value.amountDueTotal
                : amountDueTotal // ignore: cast_nullable_to_non_nullable
                      as double?,
            outstanding: freezed == outstanding
                ? _value.outstanding
                : outstanding // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }

  /// Create a copy of RentChargeWithTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RentChargeCopyWith<$Res> get charge {
    return $RentChargeCopyWith<$Res>(_value.charge, (value) {
      return _then(_value.copyWith(charge: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RentChargeWithTotalsImplCopyWith<$Res>
    implements $RentChargeWithTotalsCopyWith<$Res> {
  factory _$$RentChargeWithTotalsImplCopyWith(
    _$RentChargeWithTotalsImpl value,
    $Res Function(_$RentChargeWithTotalsImpl) then,
  ) = __$$RentChargeWithTotalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RentCharge charge,
    @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
    double? amountPaidTotal,
    @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
    double? amountDueTotal,
    @JsonKey(fromJson: parseDouble) double? outstanding,
  });

  @override
  $RentChargeCopyWith<$Res> get charge;
}

/// @nodoc
class __$$RentChargeWithTotalsImplCopyWithImpl<$Res>
    extends _$RentChargeWithTotalsCopyWithImpl<$Res, _$RentChargeWithTotalsImpl>
    implements _$$RentChargeWithTotalsImplCopyWith<$Res> {
  __$$RentChargeWithTotalsImplCopyWithImpl(
    _$RentChargeWithTotalsImpl _value,
    $Res Function(_$RentChargeWithTotalsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RentChargeWithTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? charge = null,
    Object? amountPaidTotal = freezed,
    Object? amountDueTotal = freezed,
    Object? outstanding = freezed,
  }) {
    return _then(
      _$RentChargeWithTotalsImpl(
        charge: null == charge
            ? _value.charge
            : charge // ignore: cast_nullable_to_non_nullable
                  as RentCharge,
        amountPaidTotal: freezed == amountPaidTotal
            ? _value.amountPaidTotal
            : amountPaidTotal // ignore: cast_nullable_to_non_nullable
                  as double?,
        amountDueTotal: freezed == amountDueTotal
            ? _value.amountDueTotal
            : amountDueTotal // ignore: cast_nullable_to_non_nullable
                  as double?,
        outstanding: freezed == outstanding
            ? _value.outstanding
            : outstanding // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RentChargeWithTotalsImpl implements _RentChargeWithTotals {
  const _$RentChargeWithTotalsImpl({
    required this.charge,
    @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
    this.amountPaidTotal,
    @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
    this.amountDueTotal,
    @JsonKey(fromJson: parseDouble) this.outstanding,
  });

  factory _$RentChargeWithTotalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentChargeWithTotalsImplFromJson(json);

  @override
  final RentCharge charge;
  @override
  @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
  final double? amountPaidTotal;
  @override
  @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
  final double? amountDueTotal;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? outstanding;

  @override
  String toString() {
    return 'RentChargeWithTotals(charge: $charge, amountPaidTotal: $amountPaidTotal, amountDueTotal: $amountDueTotal, outstanding: $outstanding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentChargeWithTotalsImpl &&
            (identical(other.charge, charge) || other.charge == charge) &&
            (identical(other.amountPaidTotal, amountPaidTotal) ||
                other.amountPaidTotal == amountPaidTotal) &&
            (identical(other.amountDueTotal, amountDueTotal) ||
                other.amountDueTotal == amountDueTotal) &&
            (identical(other.outstanding, outstanding) ||
                other.outstanding == outstanding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    charge,
    amountPaidTotal,
    amountDueTotal,
    outstanding,
  );

  /// Create a copy of RentChargeWithTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentChargeWithTotalsImplCopyWith<_$RentChargeWithTotalsImpl>
  get copyWith =>
      __$$RentChargeWithTotalsImplCopyWithImpl<_$RentChargeWithTotalsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RentChargeWithTotalsImplToJson(this);
  }
}

abstract class _RentChargeWithTotals implements RentChargeWithTotals {
  const factory _RentChargeWithTotals({
    required final RentCharge charge,
    @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
    final double? amountPaidTotal,
    @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
    final double? amountDueTotal,
    @JsonKey(fromJson: parseDouble) final double? outstanding,
  }) = _$RentChargeWithTotalsImpl;

  factory _RentChargeWithTotals.fromJson(Map<String, dynamic> json) =
      _$RentChargeWithTotalsImpl.fromJson;

  @override
  RentCharge get charge;
  @override
  @JsonKey(name: 'amount_paid_total', fromJson: parseDouble)
  double? get amountPaidTotal;
  @override
  @JsonKey(name: 'amount_due_total', fromJson: parseDouble)
  double? get amountDueTotal;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get outstanding;

  /// Create a copy of RentChargeWithTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentChargeWithTotalsImplCopyWith<_$RentChargeWithTotalsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
