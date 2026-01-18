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
  @JsonKey(name: 'applicant_name')
  String? get applicantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'applicant_email')
  String? get applicantEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'applicant_phone')
  String? get applicantPhone => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_field_responses')
  Map<String, dynamic>? get customFieldResponses =>
      throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'applicant_name') String? applicantName,
    @JsonKey(name: 'applicant_email') String? applicantEmail,
    @JsonKey(name: 'applicant_phone') String? applicantPhone,
    String? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
    @JsonKey(name: 'custom_field_responses')
    Map<String, dynamic>? customFieldResponses,
    String? notes,
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
    Object? applicantName = freezed,
    Object? applicantEmail = freezed,
    Object? applicantPhone = freezed,
    Object? status = freezed,
    Object? submittedAt = freezed,
    Object? customFieldResponses = freezed,
    Object? notes = freezed,
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
            applicantName: freezed == applicantName
                ? _value.applicantName
                : applicantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            applicantEmail: freezed == applicantEmail
                ? _value.applicantEmail
                : applicantEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            applicantPhone: freezed == applicantPhone
                ? _value.applicantPhone
                : applicantPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            customFieldResponses: freezed == customFieldResponses
                ? _value.customFieldResponses
                : customFieldResponses // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    @JsonKey(name: 'applicant_name') String? applicantName,
    @JsonKey(name: 'applicant_email') String? applicantEmail,
    @JsonKey(name: 'applicant_phone') String? applicantPhone,
    String? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    DateTime? submittedAt,
    @JsonKey(name: 'custom_field_responses')
    Map<String, dynamic>? customFieldResponses,
    String? notes,
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
    Object? applicantName = freezed,
    Object? applicantEmail = freezed,
    Object? applicantPhone = freezed,
    Object? status = freezed,
    Object? submittedAt = freezed,
    Object? customFieldResponses = freezed,
    Object? notes = freezed,
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
        applicantName: freezed == applicantName
            ? _value.applicantName
            : applicantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        applicantEmail: freezed == applicantEmail
            ? _value.applicantEmail
            : applicantEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        applicantPhone: freezed == applicantPhone
            ? _value.applicantPhone
            : applicantPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        customFieldResponses: freezed == customFieldResponses
            ? _value._customFieldResponses
            : customFieldResponses // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    @JsonKey(name: 'applicant_name') this.applicantName,
    @JsonKey(name: 'applicant_email') this.applicantEmail,
    @JsonKey(name: 'applicant_phone') this.applicantPhone,
    this.status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime) this.submittedAt,
    @JsonKey(name: 'custom_field_responses')
    final Map<String, dynamic>? customFieldResponses,
    this.notes,
    @JsonKey(name: 'decision_notes') this.decisionNotes,
  }) : _customFieldResponses = customFieldResponses;

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
  @JsonKey(name: 'applicant_name')
  final String? applicantName;
  @override
  @JsonKey(name: 'applicant_email')
  final String? applicantEmail;
  @override
  @JsonKey(name: 'applicant_phone')
  final String? applicantPhone;
  @override
  final String? status;
  @override
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  final DateTime? submittedAt;
  final Map<String, dynamic>? _customFieldResponses;
  @override
  @JsonKey(name: 'custom_field_responses')
  Map<String, dynamic>? get customFieldResponses {
    final value = _customFieldResponses;
    if (value == null) return null;
    if (_customFieldResponses is EqualUnmodifiableMapView)
      return _customFieldResponses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? notes;
  @override
  @JsonKey(name: 'decision_notes')
  final String? decisionNotes;

  @override
  String toString() {
    return 'ApplicationSubmission(id: $id, formId: $formId, propertyId: $propertyId, propertyName: $propertyName, propertyAddress: $propertyAddress, applicantName: $applicantName, applicantEmail: $applicantEmail, applicantPhone: $applicantPhone, status: $status, submittedAt: $submittedAt, customFieldResponses: $customFieldResponses, notes: $notes, decisionNotes: $decisionNotes)';
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
            (identical(other.applicantName, applicantName) ||
                other.applicantName == applicantName) &&
            (identical(other.applicantEmail, applicantEmail) ||
                other.applicantEmail == applicantEmail) &&
            (identical(other.applicantPhone, applicantPhone) ||
                other.applicantPhone == applicantPhone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            const DeepCollectionEquality().equals(
              other._customFieldResponses,
              _customFieldResponses,
            ) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
    applicantName,
    applicantEmail,
    applicantPhone,
    status,
    submittedAt,
    const DeepCollectionEquality().hash(_customFieldResponses),
    notes,
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
    @JsonKey(name: 'applicant_name') final String? applicantName,
    @JsonKey(name: 'applicant_email') final String? applicantEmail,
    @JsonKey(name: 'applicant_phone') final String? applicantPhone,
    final String? status,
    @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
    final DateTime? submittedAt,
    @JsonKey(name: 'custom_field_responses')
    final Map<String, dynamic>? customFieldResponses,
    final String? notes,
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
  @JsonKey(name: 'applicant_name')
  String? get applicantName;
  @override
  @JsonKey(name: 'applicant_email')
  String? get applicantEmail;
  @override
  @JsonKey(name: 'applicant_phone')
  String? get applicantPhone;
  @override
  String? get status;
  @override
  @JsonKey(name: 'submitted_at', fromJson: parseDateTime)
  DateTime? get submittedAt;
  @override
  @JsonKey(name: 'custom_field_responses')
  Map<String, dynamic>? get customFieldResponses;
  @override
  String? get notes;
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
