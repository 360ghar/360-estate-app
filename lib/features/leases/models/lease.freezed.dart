// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lease.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Lease _$LeaseFromJson(Map<String, dynamic> json) {
  return _Lease.fromJson(json);
}

/// @nodoc
mixin _$Lease {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
  int? get tenantUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_name')
  String? get tenantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_phone')
  String? get tenantPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_email')
  String? get tenantEmail => throw _privateConstructorUsedError;
  @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
  LeaseStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date', fromJson: parseDateTime)
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', fromJson: parseDateTime)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
  double? get monthlyRent => throw _privateConstructorUsedError;
  @JsonKey(name: 'security_deposit', fromJson: parseDouble)
  double? get securityDeposit => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_fee_amount', fromJson: parseDouble)
  double? get lateFeeAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
  double? get lateFeePercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'grace_period_days', fromJson: parseInt)
  int? get gracePeriodDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  int? get paymentDueDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_clauses')
  String? get specialClauses => throw _privateConstructorUsedError;
  @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
  DateTime? get signedByTenantAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
  DateTime? get signedByOwnerAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'termination_date', fromJson: parseDateTime)
  DateTime? get terminationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'termination_reason')
  String? get terminationReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'lease_document_id', fromJson: parseInt)
  int? get leaseDocumentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Lease to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaseCopyWith<Lease> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaseCopyWith<$Res> {
  factory $LeaseCopyWith(Lease value, $Res Function(Lease) then) =
      _$LeaseCopyWithImpl<$Res, Lease>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'tenant_phone') String? tenantPhone,
    @JsonKey(name: 'tenant_email') String? tenantEmail,
    @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
    LeaseStatus? status,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) DateTime? endDate,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble) double? monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    double? securityDeposit,
    @JsonKey(name: 'late_fee_amount', fromJson: parseDouble)
    double? lateFeeAmount,
    @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
    double? lateFeePercentage,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    int? gracePeriodDays,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) int? paymentDueDay,
    @JsonKey(name: 'special_clauses') String? specialClauses,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    DateTime? signedByOwnerAt,
    @JsonKey(name: 'termination_date', fromJson: parseDateTime)
    DateTime? terminationDate,
    @JsonKey(name: 'termination_reason') String? terminationReason,
    @JsonKey(name: 'lease_document_id', fromJson: parseInt)
    int? leaseDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  });
}

/// @nodoc
class _$LeaseCopyWithImpl<$Res, $Val extends Lease>
    implements $LeaseCopyWith<$Res> {
  _$LeaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? propertyId = freezed,
    Object? ownerId = freezed,
    Object? tenantUserId = freezed,
    Object? tenantName = freezed,
    Object? tenantPhone = freezed,
    Object? tenantEmail = freezed,
    Object? status = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? monthlyRent = freezed,
    Object? securityDeposit = freezed,
    Object? lateFeeAmount = freezed,
    Object? lateFeePercentage = freezed,
    Object? gracePeriodDays = freezed,
    Object? paymentDueDay = freezed,
    Object? specialClauses = freezed,
    Object? signedByTenantAt = freezed,
    Object? signedByOwnerAt = freezed,
    Object? terminationDate = freezed,
    Object? terminationReason = freezed,
    Object? leaseDocumentId = freezed,
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
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            tenantUserId: freezed == tenantUserId
                ? _value.tenantUserId
                : tenantUserId // ignore: cast_nullable_to_non_nullable
                      as int?,
            tenantName: freezed == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenantPhone: freezed == tenantPhone
                ? _value.tenantPhone
                : tenantPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenantEmail: freezed == tenantEmail
                ? _value.tenantEmail
                : tenantEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as LeaseStatus?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            monthlyRent: freezed == monthlyRent
                ? _value.monthlyRent
                : monthlyRent // ignore: cast_nullable_to_non_nullable
                      as double?,
            securityDeposit: freezed == securityDeposit
                ? _value.securityDeposit
                : securityDeposit // ignore: cast_nullable_to_non_nullable
                      as double?,
            lateFeeAmount: freezed == lateFeeAmount
                ? _value.lateFeeAmount
                : lateFeeAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            lateFeePercentage: freezed == lateFeePercentage
                ? _value.lateFeePercentage
                : lateFeePercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            gracePeriodDays: freezed == gracePeriodDays
                ? _value.gracePeriodDays
                : gracePeriodDays // ignore: cast_nullable_to_non_nullable
                      as int?,
            paymentDueDay: freezed == paymentDueDay
                ? _value.paymentDueDay
                : paymentDueDay // ignore: cast_nullable_to_non_nullable
                      as int?,
            specialClauses: freezed == specialClauses
                ? _value.specialClauses
                : specialClauses // ignore: cast_nullable_to_non_nullable
                      as String?,
            signedByTenantAt: freezed == signedByTenantAt
                ? _value.signedByTenantAt
                : signedByTenantAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            signedByOwnerAt: freezed == signedByOwnerAt
                ? _value.signedByOwnerAt
                : signedByOwnerAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            terminationDate: freezed == terminationDate
                ? _value.terminationDate
                : terminationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            terminationReason: freezed == terminationReason
                ? _value.terminationReason
                : terminationReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            leaseDocumentId: freezed == leaseDocumentId
                ? _value.leaseDocumentId
                : leaseDocumentId // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$LeaseImplCopyWith<$Res> implements $LeaseCopyWith<$Res> {
  factory _$$LeaseImplCopyWith(
    _$LeaseImpl value,
    $Res Function(_$LeaseImpl) then,
  ) = __$$LeaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) int? tenantUserId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'tenant_phone') String? tenantPhone,
    @JsonKey(name: 'tenant_email') String? tenantEmail,
    @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
    LeaseStatus? status,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) DateTime? endDate,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble) double? monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    double? securityDeposit,
    @JsonKey(name: 'late_fee_amount', fromJson: parseDouble)
    double? lateFeeAmount,
    @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
    double? lateFeePercentage,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    int? gracePeriodDays,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) int? paymentDueDay,
    @JsonKey(name: 'special_clauses') String? specialClauses,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    DateTime? signedByOwnerAt,
    @JsonKey(name: 'termination_date', fromJson: parseDateTime)
    DateTime? terminationDate,
    @JsonKey(name: 'termination_reason') String? terminationReason,
    @JsonKey(name: 'lease_document_id', fromJson: parseInt)
    int? leaseDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$LeaseImplCopyWithImpl<$Res>
    extends _$LeaseCopyWithImpl<$Res, _$LeaseImpl>
    implements _$$LeaseImplCopyWith<$Res> {
  __$$LeaseImplCopyWithImpl(
    _$LeaseImpl _value,
    $Res Function(_$LeaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? propertyId = freezed,
    Object? ownerId = freezed,
    Object? tenantUserId = freezed,
    Object? tenantName = freezed,
    Object? tenantPhone = freezed,
    Object? tenantEmail = freezed,
    Object? status = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? monthlyRent = freezed,
    Object? securityDeposit = freezed,
    Object? lateFeeAmount = freezed,
    Object? lateFeePercentage = freezed,
    Object? gracePeriodDays = freezed,
    Object? paymentDueDay = freezed,
    Object? specialClauses = freezed,
    Object? signedByTenantAt = freezed,
    Object? signedByOwnerAt = freezed,
    Object? terminationDate = freezed,
    Object? terminationReason = freezed,
    Object? leaseDocumentId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$LeaseImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
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
        tenantName: freezed == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenantPhone: freezed == tenantPhone
            ? _value.tenantPhone
            : tenantPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenantEmail: freezed == tenantEmail
            ? _value.tenantEmail
            : tenantEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as LeaseStatus?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        monthlyRent: freezed == monthlyRent
            ? _value.monthlyRent
            : monthlyRent // ignore: cast_nullable_to_non_nullable
                  as double?,
        securityDeposit: freezed == securityDeposit
            ? _value.securityDeposit
            : securityDeposit // ignore: cast_nullable_to_non_nullable
                  as double?,
        lateFeeAmount: freezed == lateFeeAmount
            ? _value.lateFeeAmount
            : lateFeeAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        lateFeePercentage: freezed == lateFeePercentage
            ? _value.lateFeePercentage
            : lateFeePercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        gracePeriodDays: freezed == gracePeriodDays
            ? _value.gracePeriodDays
            : gracePeriodDays // ignore: cast_nullable_to_non_nullable
                  as int?,
        paymentDueDay: freezed == paymentDueDay
            ? _value.paymentDueDay
            : paymentDueDay // ignore: cast_nullable_to_non_nullable
                  as int?,
        specialClauses: freezed == specialClauses
            ? _value.specialClauses
            : specialClauses // ignore: cast_nullable_to_non_nullable
                  as String?,
        signedByTenantAt: freezed == signedByTenantAt
            ? _value.signedByTenantAt
            : signedByTenantAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        signedByOwnerAt: freezed == signedByOwnerAt
            ? _value.signedByOwnerAt
            : signedByOwnerAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        terminationDate: freezed == terminationDate
            ? _value.terminationDate
            : terminationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        terminationReason: freezed == terminationReason
            ? _value.terminationReason
            : terminationReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        leaseDocumentId: freezed == leaseDocumentId
            ? _value.leaseDocumentId
            : leaseDocumentId // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$LeaseImpl implements _Lease {
  const _$LeaseImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) this.ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt) this.tenantUserId,
    @JsonKey(name: 'tenant_name') this.tenantName,
    @JsonKey(name: 'tenant_phone') this.tenantPhone,
    @JsonKey(name: 'tenant_email') this.tenantEmail,
    @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
    this.status,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) this.startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) this.endDate,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble) this.monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    this.securityDeposit,
    @JsonKey(name: 'late_fee_amount', fromJson: parseDouble) this.lateFeeAmount,
    @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
    this.lateFeePercentage,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    this.gracePeriodDays,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt) this.paymentDueDay,
    @JsonKey(name: 'special_clauses') this.specialClauses,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    this.signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    this.signedByOwnerAt,
    @JsonKey(name: 'termination_date', fromJson: parseDateTime)
    this.terminationDate,
    @JsonKey(name: 'termination_reason') this.terminationReason,
    @JsonKey(name: 'lease_document_id', fromJson: parseInt)
    this.leaseDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) this.updatedAt,
  });

  factory _$LeaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaseImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
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
  @JsonKey(name: 'tenant_name')
  final String? tenantName;
  @override
  @JsonKey(name: 'tenant_phone')
  final String? tenantPhone;
  @override
  @JsonKey(name: 'tenant_email')
  final String? tenantEmail;
  @override
  @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
  final LeaseStatus? status;
  @override
  @JsonKey(name: 'start_date', fromJson: parseDateTime)
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: parseDateTime)
  final DateTime? endDate;
  @override
  @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
  final double? monthlyRent;
  @override
  @JsonKey(name: 'security_deposit', fromJson: parseDouble)
  final double? securityDeposit;
  @override
  @JsonKey(name: 'late_fee_amount', fromJson: parseDouble)
  final double? lateFeeAmount;
  @override
  @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
  final double? lateFeePercentage;
  @override
  @JsonKey(name: 'grace_period_days', fromJson: parseInt)
  final int? gracePeriodDays;
  @override
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  final int? paymentDueDay;
  @override
  @JsonKey(name: 'special_clauses')
  final String? specialClauses;
  @override
  @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
  final DateTime? signedByTenantAt;
  @override
  @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
  final DateTime? signedByOwnerAt;
  @override
  @JsonKey(name: 'termination_date', fromJson: parseDateTime)
  final DateTime? terminationDate;
  @override
  @JsonKey(name: 'termination_reason')
  final String? terminationReason;
  @override
  @JsonKey(name: 'lease_document_id', fromJson: parseInt)
  final int? leaseDocumentId;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Lease(id: $id, propertyId: $propertyId, ownerId: $ownerId, tenantUserId: $tenantUserId, tenantName: $tenantName, tenantPhone: $tenantPhone, tenantEmail: $tenantEmail, status: $status, startDate: $startDate, endDate: $endDate, monthlyRent: $monthlyRent, securityDeposit: $securityDeposit, lateFeeAmount: $lateFeeAmount, lateFeePercentage: $lateFeePercentage, gracePeriodDays: $gracePeriodDays, paymentDueDay: $paymentDueDay, specialClauses: $specialClauses, signedByTenantAt: $signedByTenantAt, signedByOwnerAt: $signedByOwnerAt, terminationDate: $terminationDate, terminationReason: $terminationReason, leaseDocumentId: $leaseDocumentId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.tenantUserId, tenantUserId) ||
                other.tenantUserId == tenantUserId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.tenantPhone, tenantPhone) ||
                other.tenantPhone == tenantPhone) &&
            (identical(other.tenantEmail, tenantEmail) ||
                other.tenantEmail == tenantEmail) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.monthlyRent, monthlyRent) ||
                other.monthlyRent == monthlyRent) &&
            (identical(other.securityDeposit, securityDeposit) ||
                other.securityDeposit == securityDeposit) &&
            (identical(other.lateFeeAmount, lateFeeAmount) ||
                other.lateFeeAmount == lateFeeAmount) &&
            (identical(other.lateFeePercentage, lateFeePercentage) ||
                other.lateFeePercentage == lateFeePercentage) &&
            (identical(other.gracePeriodDays, gracePeriodDays) ||
                other.gracePeriodDays == gracePeriodDays) &&
            (identical(other.paymentDueDay, paymentDueDay) ||
                other.paymentDueDay == paymentDueDay) &&
            (identical(other.specialClauses, specialClauses) ||
                other.specialClauses == specialClauses) &&
            (identical(other.signedByTenantAt, signedByTenantAt) ||
                other.signedByTenantAt == signedByTenantAt) &&
            (identical(other.signedByOwnerAt, signedByOwnerAt) ||
                other.signedByOwnerAt == signedByOwnerAt) &&
            (identical(other.terminationDate, terminationDate) ||
                other.terminationDate == terminationDate) &&
            (identical(other.terminationReason, terminationReason) ||
                other.terminationReason == terminationReason) &&
            (identical(other.leaseDocumentId, leaseDocumentId) ||
                other.leaseDocumentId == leaseDocumentId) &&
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
    propertyId,
    ownerId,
    tenantUserId,
    tenantName,
    tenantPhone,
    tenantEmail,
    status,
    startDate,
    endDate,
    monthlyRent,
    securityDeposit,
    lateFeeAmount,
    lateFeePercentage,
    gracePeriodDays,
    paymentDueDay,
    specialClauses,
    signedByTenantAt,
    signedByOwnerAt,
    terminationDate,
    terminationReason,
    leaseDocumentId,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaseImplCopyWith<_$LeaseImpl> get copyWith =>
      __$$LeaseImplCopyWithImpl<_$LeaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaseImplToJson(this);
  }
}

abstract class _Lease implements Lease {
  const factory _Lease({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) final int? ownerId,
    @JsonKey(name: 'tenant_user_id', fromJson: parseInt)
    final int? tenantUserId,
    @JsonKey(name: 'tenant_name') final String? tenantName,
    @JsonKey(name: 'tenant_phone') final String? tenantPhone,
    @JsonKey(name: 'tenant_email') final String? tenantEmail,
    @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
    final LeaseStatus? status,
    @JsonKey(name: 'start_date', fromJson: parseDateTime)
    final DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) final DateTime? endDate,
    @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
    final double? monthlyRent,
    @JsonKey(name: 'security_deposit', fromJson: parseDouble)
    final double? securityDeposit,
    @JsonKey(name: 'late_fee_amount', fromJson: parseDouble)
    final double? lateFeeAmount,
    @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
    final double? lateFeePercentage,
    @JsonKey(name: 'grace_period_days', fromJson: parseInt)
    final int? gracePeriodDays,
    @JsonKey(name: 'payment_due_day', fromJson: parseInt)
    final int? paymentDueDay,
    @JsonKey(name: 'special_clauses') final String? specialClauses,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    final DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    final DateTime? signedByOwnerAt,
    @JsonKey(name: 'termination_date', fromJson: parseDateTime)
    final DateTime? terminationDate,
    @JsonKey(name: 'termination_reason') final String? terminationReason,
    @JsonKey(name: 'lease_document_id', fromJson: parseInt)
    final int? leaseDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime)
    final DateTime? updatedAt,
  }) = _$LeaseImpl;

  factory _Lease.fromJson(Map<String, dynamic> json) = _$LeaseImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
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
  @JsonKey(name: 'tenant_name')
  String? get tenantName;
  @override
  @JsonKey(name: 'tenant_phone')
  String? get tenantPhone;
  @override
  @JsonKey(name: 'tenant_email')
  String? get tenantEmail;
  @override
  @JsonKey(fromJson: LeaseStatus.fromJson, toJson: LeaseStatus.toJsonValue)
  LeaseStatus? get status;
  @override
  @JsonKey(name: 'start_date', fromJson: parseDateTime)
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: parseDateTime)
  DateTime? get endDate;
  @override
  @JsonKey(name: 'monthly_rent', fromJson: parseDouble)
  double? get monthlyRent;
  @override
  @JsonKey(name: 'security_deposit', fromJson: parseDouble)
  double? get securityDeposit;
  @override
  @JsonKey(name: 'late_fee_amount', fromJson: parseDouble)
  double? get lateFeeAmount;
  @override
  @JsonKey(name: 'late_fee_percentage', fromJson: parseDouble)
  double? get lateFeePercentage;
  @override
  @JsonKey(name: 'grace_period_days', fromJson: parseInt)
  int? get gracePeriodDays;
  @override
  @JsonKey(name: 'payment_due_day', fromJson: parseInt)
  int? get paymentDueDay;
  @override
  @JsonKey(name: 'special_clauses')
  String? get specialClauses;
  @override
  @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
  DateTime? get signedByTenantAt;
  @override
  @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
  DateTime? get signedByOwnerAt;
  @override
  @JsonKey(name: 'termination_date', fromJson: parseDateTime)
  DateTime? get terminationDate;
  @override
  @JsonKey(name: 'termination_reason')
  String? get terminationReason;
  @override
  @JsonKey(name: 'lease_document_id', fromJson: parseInt)
  int? get leaseDocumentId;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt;

  /// Create a copy of Lease
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaseImplCopyWith<_$LeaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
