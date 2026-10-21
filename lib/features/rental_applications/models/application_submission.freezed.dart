// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplicationSubmission _$ApplicationSubmissionFromJson(
  Map<String, dynamic> json,
) {
  return _ApplicationSubmission.fromJson(json);
}

/// @nodoc
mixin _$ApplicationSubmission {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'form_id', fromJson: parseInt)
  int? get formId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_address')
  String? get propertyAddress => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: RentalApplicationStatus.fromJson,
    toJson: RentalApplicationStatus.toJsonValue,
  )
  RentalApplicationStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'applicant_full_name')
  String? get applicantFullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'applicant_email')
  String? get applicantEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'applicant_phone')
  String? get applicantPhone => throw _privateConstructorUsedError;
  Map<String, dynamic>? get answers => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_data')
  Map<String, dynamic>? get applicationData =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'decision_at', fromJson: parseDateTime)
  DateTime? get decisionAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'decision_notes')
  String? get decisionNotes => throw _privateConstructorUsedError;

  /// Serializes this ApplicationSubmission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationSubmissionCopyWith<ApplicationSubmission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationSubmissionCopyWith<$Res> {
  factory $ApplicationSubmissionCopyWith(
    ApplicationSubmission value,
    $Res Function(ApplicationSubmission) then,
  ) = _$ApplicationSubmissionCopyWithImpl<$Res, ApplicationSubmission>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'form_id', fromJson: parseInt) int? formId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'property_address') String? propertyAddress,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    RentalApplicationStatus? status,
    @JsonKey(name: 'applicant_full_name') String? applicantFullName,
    @JsonKey(name: 'applicant_email') String? applicantEmail,
    @JsonKey(name: 'applicant_phone') String? applicantPhone,
    Map<String, dynamic>? answers,
    @JsonKey(name: 'application_data') Map<String, dynamic>? applicationData,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
    @JsonKey(name: 'decision_at', fromJson: parseDateTime) DateTime? decisionAt,
    @JsonKey(name: 'decision_notes') String? decisionNotes,
  });
}

/// @nodoc
class _$ApplicationSubmissionCopyWithImpl<
  $Res,
  $Val extends ApplicationSubmission
>
    implements $ApplicationSubmissionCopyWith<$Res> {
  _$ApplicationSubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? formId = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? propertyAddress = freezed,
    Object? status = freezed,
    Object? applicantFullName = freezed,
    Object? applicantEmail = freezed,
    Object? applicantPhone = freezed,
    Object? answers = freezed,
    Object? applicationData = freezed,
    Object? submittedAt = freezed,
    Object? decisionAt = freezed,
    Object? decisionNotes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            formId: freezed == formId
                ? _value.formId
                : formId // ignore: cast_nullable_to_non_nullable
                      as int?,
            propertyId: freezed == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyAddress: freezed == propertyAddress
                ? _value.propertyAddress
                : propertyAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RentalApplicationStatus?,
            applicantFullName: freezed == applicantFullName
                ? _value.applicantFullName
                : applicantFullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            applicantEmail: freezed == applicantEmail
                ? _value.applicantEmail
                : applicantEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            applicantPhone: freezed == applicantPhone
                ? _value.applicantPhone
                : applicantPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            answers: freezed == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            applicationData: freezed == applicationData
                ? _value.applicationData
                : applicationData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            decisionAt: freezed == decisionAt
                ? _value.decisionAt
                : decisionAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            decisionNotes: freezed == decisionNotes
                ? _value.decisionNotes
                : decisionNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationSubmissionImplCopyWith<$Res>
    implements $ApplicationSubmissionCopyWith<$Res> {
  factory _$$ApplicationSubmissionImplCopyWith(
    _$ApplicationSubmissionImpl value,
    $Res Function(_$ApplicationSubmissionImpl) then,
  ) = __$$ApplicationSubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'form_id', fromJson: parseInt) int? formId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'property_address') String? propertyAddress,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    RentalApplicationStatus? status,
    @JsonKey(name: 'applicant_full_name') String? applicantFullName,
    @JsonKey(name: 'applicant_email') String? applicantEmail,
    @JsonKey(name: 'applicant_phone') String? applicantPhone,
    Map<String, dynamic>? answers,
    @JsonKey(name: 'application_data') Map<String, dynamic>? applicationData,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
    @JsonKey(name: 'decision_at', fromJson: parseDateTime) DateTime? decisionAt,
    @JsonKey(name: 'decision_notes') String? decisionNotes,
  });
}

/// @nodoc
class __$$ApplicationSubmissionImplCopyWithImpl<$Res>
    extends
        _$ApplicationSubmissionCopyWithImpl<$Res, _$ApplicationSubmissionImpl>
    implements _$$ApplicationSubmissionImplCopyWith<$Res> {
  __$$ApplicationSubmissionImplCopyWithImpl(
    _$ApplicationSubmissionImpl _value,
    $Res Function(_$ApplicationSubmissionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationSubmission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? formId = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? propertyAddress = freezed,
    Object? status = freezed,
    Object? applicantFullName = freezed,
    Object? applicantEmail = freezed,
    Object? applicantPhone = freezed,
    Object? answers = freezed,
    Object? applicationData = freezed,
    Object? submittedAt = freezed,
    Object? decisionAt = freezed,
    Object? decisionNotes = freezed,
  }) {
    return _then(
      _$ApplicationSubmissionImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        formId: freezed == formId
            ? _value.formId
            : formId // ignore: cast_nullable_to_non_nullable
                  as int?,
        propertyId: freezed == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyAddress: freezed == propertyAddress
            ? _value.propertyAddress
            : propertyAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RentalApplicationStatus?,
        applicantFullName: freezed == applicantFullName
            ? _value.applicantFullName
            : applicantFullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        applicantEmail: freezed == applicantEmail
            ? _value.applicantEmail
            : applicantEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        applicantPhone: freezed == applicantPhone
            ? _value.applicantPhone
            : applicantPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        answers: freezed == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        applicationData: freezed == applicationData
            ? _value._applicationData
            : applicationData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        decisionAt: freezed == decisionAt
            ? _value.decisionAt
            : decisionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        decisionNotes: freezed == decisionNotes
            ? _value.decisionNotes
            : decisionNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationSubmissionImpl implements _ApplicationSubmission {
  const _$ApplicationSubmissionImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'form_id', fromJson: parseInt) this.formId,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(name: 'property_address') this.propertyAddress,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    this.status,
    @JsonKey(name: 'applicant_full_name') this.applicantFullName,
    @JsonKey(name: 'applicant_email') this.applicantEmail,
    @JsonKey(name: 'applicant_phone') this.applicantPhone,
    final Map<String, dynamic>? answers,
    @JsonKey(name: 'application_data')
    final Map<String, dynamic>? applicationData,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime) this.submittedAt,
    @JsonKey(name: 'decision_at', fromJson: parseDateTime) this.decisionAt,
    @JsonKey(name: 'decision_notes') this.decisionNotes,
  }) : _answers = answers,
       _applicationData = applicationData;

  factory _$ApplicationSubmissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationSubmissionImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'form_id', fromJson: parseInt)
  final int? formId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'property_address')
  final String? propertyAddress;
  @override
  @JsonKey(
    fromJson: RentalApplicationStatus.fromJson,
    toJson: RentalApplicationStatus.toJsonValue,
  )
  final RentalApplicationStatus? status;
  @override
  @JsonKey(name: 'applicant_full_name')
  final String? applicantFullName;
  @override
  @JsonKey(name: 'applicant_email')
  final String? applicantEmail;
  @override
  @JsonKey(name: 'applicant_phone')
  final String? applicantPhone;
  final Map<String, dynamic>? _answers;
  @override
  Map<String, dynamic>? get answers {
    final value = _answers;
    if (value == null) return null;
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _applicationData;
  @override
  @JsonKey(name: 'application_data')
  Map<String, dynamic>? get applicationData {
    final value = _applicationData;
    if (value == null) return null;
    if (_applicationData is EqualUnmodifiableMapView) return _applicationData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  final DateTime? submittedAt;
  @override
  @JsonKey(name: 'decision_at', fromJson: parseDateTime)
  final DateTime? decisionAt;
  @override
  @JsonKey(name: 'decision_notes')
  final String? decisionNotes;

  @override
  String toString() {
    return 'ApplicationSubmission(id: $id, formId: $formId, propertyId: $propertyId, propertyName: $propertyName, propertyAddress: $propertyAddress, status: $status, applicantFullName: $applicantFullName, applicantEmail: $applicantEmail, applicantPhone: $applicantPhone, answers: $answers, applicationData: $applicationData, submittedAt: $submittedAt, decisionAt: $decisionAt, decisionNotes: $decisionNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationSubmissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.formId, formId) || other.formId == formId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.propertyAddress, propertyAddress) ||
                other.propertyAddress == propertyAddress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.applicantFullName, applicantFullName) ||
                other.applicantFullName == applicantFullName) &&
            (identical(other.applicantEmail, applicantEmail) ||
                other.applicantEmail == applicantEmail) &&
            (identical(other.applicantPhone, applicantPhone) ||
                other.applicantPhone == applicantPhone) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            const DeepCollectionEquality().equals(
              other._applicationData,
              _applicationData,
            ) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.decisionAt, decisionAt) ||
                other.decisionAt == decisionAt) &&
            (identical(other.decisionNotes, decisionNotes) ||
                other.decisionNotes == decisionNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    formId,
    propertyId,
    propertyName,
    propertyAddress,
    status,
    applicantFullName,
    applicantEmail,
    applicantPhone,
    const DeepCollectionEquality().hash(_answers),
    const DeepCollectionEquality().hash(_applicationData),
    submittedAt,
    decisionAt,
    decisionNotes,
  );

  /// Create a copy of ApplicationSubmission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationSubmissionImplCopyWith<_$ApplicationSubmissionImpl>
  get copyWith =>
      __$$ApplicationSubmissionImplCopyWithImpl<_$ApplicationSubmissionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationSubmissionImplToJson(this);
  }
}

abstract class _ApplicationSubmission implements ApplicationSubmission {
  const factory _ApplicationSubmission({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'form_id', fromJson: parseInt) final int? formId,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(name: 'property_address') final String? propertyAddress,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    final RentalApplicationStatus? status,
    @JsonKey(name: 'applicant_full_name') final String? applicantFullName,
    @JsonKey(name: 'applicant_email') final String? applicantEmail,
    @JsonKey(name: 'applicant_phone') final String? applicantPhone,
    final Map<String, dynamic>? answers,
    @JsonKey(name: 'application_data')
    final Map<String, dynamic>? applicationData,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    final DateTime? submittedAt,
    @JsonKey(name: 'decision_at', fromJson: parseDateTime)
    final DateTime? decisionAt,
    @JsonKey(name: 'decision_notes') final String? decisionNotes,
  }) = _$ApplicationSubmissionImpl;

  factory _ApplicationSubmission.fromJson(Map<String, dynamic> json) =
      _$ApplicationSubmissionImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'form_id', fromJson: parseInt)
  int? get formId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'property_address')
  String? get propertyAddress;
  @override
  @JsonKey(
    fromJson: RentalApplicationStatus.fromJson,
    toJson: RentalApplicationStatus.toJsonValue,
  )
  RentalApplicationStatus? get status;
  @override
  @JsonKey(name: 'applicant_full_name')
  String? get applicantFullName;
  @override
  @JsonKey(name: 'applicant_email')
  String? get applicantEmail;
  @override
  @JsonKey(name: 'applicant_phone')
  String? get applicantPhone;
  @override
  Map<String, dynamic>? get answers;
  @override
  @JsonKey(name: 'application_data')
  Map<String, dynamic>? get applicationData;
  @override
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  DateTime? get submittedAt;
  @override
  @JsonKey(name: 'decision_at', fromJson: parseDateTime)
  DateTime? get decisionAt;
  @override
  @JsonKey(name: 'decision_notes')
  String? get decisionNotes;

  /// Create a copy of ApplicationSubmission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationSubmissionImplCopyWith<_$ApplicationSubmissionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ApplicationSubmitted _$ApplicationSubmittedFromJson(Map<String, dynamic> json) {
  return _ApplicationSubmitted.fromJson(json);
}

/// @nodoc
mixin _$ApplicationSubmitted {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: RentalApplicationStatus.fromJson,
    toJson: RentalApplicationStatus.toJsonValue,
  )
  RentalApplicationStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  DateTime? get submittedAt => throw _privateConstructorUsedError;

  /// Serializes this ApplicationSubmitted to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationSubmitted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationSubmittedCopyWith<ApplicationSubmitted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationSubmittedCopyWith<$Res> {
  factory $ApplicationSubmittedCopyWith(
    ApplicationSubmitted value,
    $Res Function(ApplicationSubmitted) then,
  ) = _$ApplicationSubmittedCopyWithImpl<$Res, ApplicationSubmitted>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    RentalApplicationStatus? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
  });
}

/// @nodoc
class _$ApplicationSubmittedCopyWithImpl<
  $Res,
  $Val extends ApplicationSubmitted
>
    implements $ApplicationSubmittedCopyWith<$Res> {
  _$ApplicationSubmittedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationSubmitted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? submittedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RentalApplicationStatus?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationSubmittedImplCopyWith<$Res>
    implements $ApplicationSubmittedCopyWith<$Res> {
  factory _$$ApplicationSubmittedImplCopyWith(
    _$ApplicationSubmittedImpl value,
    $Res Function(_$ApplicationSubmittedImpl) then,
  ) = __$$ApplicationSubmittedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    RentalApplicationStatus? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
  });
}

/// @nodoc
class __$$ApplicationSubmittedImplCopyWithImpl<$Res>
    extends _$ApplicationSubmittedCopyWithImpl<$Res, _$ApplicationSubmittedImpl>
    implements _$$ApplicationSubmittedImplCopyWith<$Res> {
  __$$ApplicationSubmittedImplCopyWithImpl(
    _$ApplicationSubmittedImpl _value,
    $Res Function(_$ApplicationSubmittedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationSubmitted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? submittedAt = freezed,
  }) {
    return _then(
      _$ApplicationSubmittedImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RentalApplicationStatus?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationSubmittedImpl implements _ApplicationSubmitted {
  const _$ApplicationSubmittedImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    this.status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime) this.submittedAt,
  });

  factory _$ApplicationSubmittedImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationSubmittedImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(
    fromJson: RentalApplicationStatus.fromJson,
    toJson: RentalApplicationStatus.toJsonValue,
  )
  final RentalApplicationStatus? status;
  @override
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  final DateTime? submittedAt;

  @override
  String toString() {
    return 'ApplicationSubmitted(id: $id, status: $status, submittedAt: $submittedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationSubmittedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, submittedAt);

  /// Create a copy of ApplicationSubmitted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationSubmittedImplCopyWith<_$ApplicationSubmittedImpl>
  get copyWith =>
      __$$ApplicationSubmittedImplCopyWithImpl<_$ApplicationSubmittedImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationSubmittedImplToJson(this);
  }
}

abstract class _ApplicationSubmitted implements ApplicationSubmitted {
  const factory _ApplicationSubmitted({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(
      fromJson: RentalApplicationStatus.fromJson,
      toJson: RentalApplicationStatus.toJsonValue,
    )
    final RentalApplicationStatus? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    final DateTime? submittedAt,
  }) = _$ApplicationSubmittedImpl;

  factory _ApplicationSubmitted.fromJson(Map<String, dynamic> json) =
      _$ApplicationSubmittedImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(
    fromJson: RentalApplicationStatus.fromJson,
    toJson: RentalApplicationStatus.toJsonValue,
  )
  RentalApplicationStatus? get status;
  @override
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  DateTime? get submittedAt;

  /// Create a copy of ApplicationSubmitted
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationSubmittedImplCopyWith<_$ApplicationSubmittedImpl>
  get copyWith => throw _privateConstructorUsedError;
}
