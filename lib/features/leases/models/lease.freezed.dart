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
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id', fromJson: parseInt)
  int? get tenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_name')
  String? get tenantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date', fromJson: parseDateTime)
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', fromJson: parseDateTime)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'rent_amount', fromJson: parseDouble)
  double? get rentAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'deposit_amount', fromJson: parseDouble)
  double? get depositAmount => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'signed_document_url')
  String? get signedDocumentUrl => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) int? tenantId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) DateTime? endDate,
    @JsonKey(name: 'rent_amount', fromJson: parseDouble) double? rentAmount,
    @JsonKey(name: 'deposit_amount', fromJson: parseDouble)
    double? depositAmount,
    String? status,
    @JsonKey(name: 'signed_document_url') String? signedDocumentUrl,
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
    Object? propertyName = freezed,
    Object? tenantId = freezed,
    Object? tenantName = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? rentAmount = freezed,
    Object? depositAmount = freezed,
    Object? status = freezed,
    Object? signedDocumentUrl = freezed,
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
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rentAmount: freezed == rentAmount
                ? _value.rentAmount
                : rentAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            depositAmount: freezed == depositAmount
                ? _value.depositAmount
                : depositAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            signedDocumentUrl: freezed == signedDocumentUrl
                ? _value.signedDocumentUrl
                : signedDocumentUrl // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) int? tenantId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) DateTime? endDate,
    @JsonKey(name: 'rent_amount', fromJson: parseDouble) double? rentAmount,
    @JsonKey(name: 'deposit_amount', fromJson: parseDouble)
    double? depositAmount,
    String? status,
    @JsonKey(name: 'signed_document_url') String? signedDocumentUrl,
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
    Object? propertyName = freezed,
    Object? tenantId = freezed,
    Object? tenantName = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? rentAmount = freezed,
    Object? depositAmount = freezed,
    Object? status = freezed,
    Object? signedDocumentUrl = freezed,
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
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rentAmount: freezed == rentAmount
            ? _value.rentAmount
            : rentAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        depositAmount: freezed == depositAmount
            ? _value.depositAmount
            : depositAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        signedDocumentUrl: freezed == signedDocumentUrl
            ? _value.signedDocumentUrl
            : signedDocumentUrl // ignore: cast_nullable_to_non_nullable
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
class _$LeaseImpl implements _Lease {
  const _$LeaseImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) this.tenantId,
    @JsonKey(name: 'tenant_name') this.tenantName,
    @JsonKey(name: 'start_date', fromJson: parseDateTime) this.startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) this.endDate,
    @JsonKey(name: 'rent_amount', fromJson: parseDouble) this.rentAmount,
    @JsonKey(name: 'deposit_amount', fromJson: parseDouble) this.depositAmount,
    this.status,
    @JsonKey(name: 'signed_document_url') this.signedDocumentUrl,
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
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'tenant_id', fromJson: parseInt)
  final int? tenantId;
  @override
  @JsonKey(name: 'tenant_name')
  final String? tenantName;
  @override
  @JsonKey(name: 'start_date', fromJson: parseDateTime)
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: parseDateTime)
  final DateTime? endDate;
  @override
  @JsonKey(name: 'rent_amount', fromJson: parseDouble)
  final double? rentAmount;
  @override
  @JsonKey(name: 'deposit_amount', fromJson: parseDouble)
  final double? depositAmount;
  @override
  final String? status;
  @override
  @JsonKey(name: 'signed_document_url')
  final String? signedDocumentUrl;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Lease(id: $id, propertyId: $propertyId, propertyName: $propertyName, tenantId: $tenantId, tenantName: $tenantName, startDate: $startDate, endDate: $endDate, rentAmount: $rentAmount, depositAmount: $depositAmount, status: $status, signedDocumentUrl: $signedDocumentUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.rentAmount, rentAmount) ||
                other.rentAmount == rentAmount) &&
            (identical(other.depositAmount, depositAmount) ||
                other.depositAmount == depositAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.signedDocumentUrl, signedDocumentUrl) ||
                other.signedDocumentUrl == signedDocumentUrl) &&
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
    startDate,
    endDate,
    rentAmount,
    depositAmount,
    status,
    signedDocumentUrl,
    createdAt,
    updatedAt,
  );

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
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) final int? tenantId,
    @JsonKey(name: 'tenant_name') final String? tenantName,
    @JsonKey(name: 'start_date', fromJson: parseDateTime)
    final DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: parseDateTime) final DateTime? endDate,
    @JsonKey(name: 'rent_amount', fromJson: parseDouble)
    final double? rentAmount,
    @JsonKey(name: 'deposit_amount', fromJson: parseDouble)
    final double? depositAmount,
    final String? status,
    @JsonKey(name: 'signed_document_url') final String? signedDocumentUrl,
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
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'tenant_id', fromJson: parseInt)
  int? get tenantId;
  @override
  @JsonKey(name: 'tenant_name')
  String? get tenantName;
  @override
  @JsonKey(name: 'start_date', fromJson: parseDateTime)
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: parseDateTime)
  DateTime? get endDate;
  @override
  @JsonKey(name: 'rent_amount', fromJson: parseDouble)
  double? get rentAmount;
  @override
  @JsonKey(name: 'deposit_amount', fromJson: parseDouble)
  double? get depositAmount;
  @override
  String? get status;
  @override
  @JsonKey(name: 'signed_document_url')
  String? get signedDocumentUrl;
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
