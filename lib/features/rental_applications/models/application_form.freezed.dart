// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplicationFormField _$ApplicationFormFieldFromJson(Map<String, dynamic> json) {
  return _ApplicationFormField.fromJson(json);
}

/// @nodoc
mixin _$ApplicationFormField {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'field_type')
  String? get fieldType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_required')
  bool? get isRequired => throw _privateConstructorUsedError;
  List<String>? get options => throw _privateConstructorUsedError;

  /// Serializes this ApplicationFormField to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationFormField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationFormFieldCopyWith<ApplicationFormField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationFormFieldCopyWith<$Res> {
  factory $ApplicationFormFieldCopyWith(
    ApplicationFormField value,
    $Res Function(ApplicationFormField) then,
  ) = _$ApplicationFormFieldCopyWithImpl<$Res, ApplicationFormField>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? label,
    @JsonKey(name: 'field_type') String? fieldType,
    @JsonKey(name: 'is_required') bool? isRequired,
    List<String>? options,
  });
}

/// @nodoc
class _$ApplicationFormFieldCopyWithImpl<
  $Res,
  $Val extends ApplicationFormField
>
    implements $ApplicationFormFieldCopyWith<$Res> {
  _$ApplicationFormFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationFormField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? fieldType = freezed,
    Object? isRequired = freezed,
    Object? options = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            fieldType: freezed == fieldType
                ? _value.fieldType
                : fieldType // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRequired: freezed == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool?,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationFormFieldImplCopyWith<$Res>
    implements $ApplicationFormFieldCopyWith<$Res> {
  factory _$$ApplicationFormFieldImplCopyWith(
    _$ApplicationFormFieldImpl value,
    $Res Function(_$ApplicationFormFieldImpl) then,
  ) = __$$ApplicationFormFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? label,
    @JsonKey(name: 'field_type') String? fieldType,
    @JsonKey(name: 'is_required') bool? isRequired,
    List<String>? options,
  });
}

/// @nodoc
class __$$ApplicationFormFieldImplCopyWithImpl<$Res>
    extends _$ApplicationFormFieldCopyWithImpl<$Res, _$ApplicationFormFieldImpl>
    implements _$$ApplicationFormFieldImplCopyWith<$Res> {
  __$$ApplicationFormFieldImplCopyWithImpl(
    _$ApplicationFormFieldImpl _value,
    $Res Function(_$ApplicationFormFieldImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationFormField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? fieldType = freezed,
    Object? isRequired = freezed,
    Object? options = freezed,
  }) {
    return _then(
      _$ApplicationFormFieldImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        fieldType: freezed == fieldType
            ? _value.fieldType
            : fieldType // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRequired: freezed == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool?,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationFormFieldImpl implements _ApplicationFormField {
  const _$ApplicationFormFieldImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.label,
    @JsonKey(name: 'field_type') this.fieldType,
    @JsonKey(name: 'is_required') this.isRequired,
    final List<String>? options,
  }) : _options = options;

  factory _$ApplicationFormFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationFormFieldImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? label;
  @override
  @JsonKey(name: 'field_type')
  final String? fieldType;
  @override
  @JsonKey(name: 'is_required')
  final bool? isRequired;
  final List<String>? _options;
  @override
  List<String>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApplicationFormField(id: $id, label: $label, fieldType: $fieldType, isRequired: $isRequired, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationFormFieldImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fieldType, fieldType) ||
                other.fieldType == fieldType) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    fieldType,
    isRequired,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of ApplicationFormField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationFormFieldImplCopyWith<_$ApplicationFormFieldImpl>
  get copyWith =>
      __$$ApplicationFormFieldImplCopyWithImpl<_$ApplicationFormFieldImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationFormFieldImplToJson(this);
  }
}

abstract class _ApplicationFormField implements ApplicationFormField {
  const factory _ApplicationFormField({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? label,
    @JsonKey(name: 'field_type') final String? fieldType,
    @JsonKey(name: 'is_required') final bool? isRequired,
    final List<String>? options,
  }) = _$ApplicationFormFieldImpl;

  factory _ApplicationFormField.fromJson(Map<String, dynamic> json) =
      _$ApplicationFormFieldImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get label;
  @override
  @JsonKey(name: 'field_type')
  String? get fieldType;
  @override
  @JsonKey(name: 'is_required')
  bool? get isRequired;
  @override
  List<String>? get options;

  /// Create a copy of ApplicationFormField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationFormFieldImplCopyWith<_$ApplicationFormFieldImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ApplicationForm _$ApplicationFormFromJson(Map<String, dynamic> json) {
  return _ApplicationForm.fromJson(json);
}

/// @nodoc
mixin _$ApplicationForm {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_address')
  String? get propertyAddress => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
  List<ApplicationFormField>? get fields => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at', fromJson: parseDateTime)
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this ApplicationForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationFormCopyWith<ApplicationForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationFormCopyWith<$Res> {
  factory $ApplicationFormCopyWith(
    ApplicationForm value,
    $Res Function(ApplicationForm) then,
  ) = _$ApplicationFormCopyWithImpl<$Res, ApplicationForm>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'property_address') String? propertyAddress,
    String? title,
    String? description,
    String? slug,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
    List<ApplicationFormField>? fields,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'expires_at', fromJson: parseDateTime) DateTime? expiresAt,
  });
}

/// @nodoc
class _$ApplicationFormCopyWithImpl<$Res, $Val extends ApplicationForm>
    implements $ApplicationFormCopyWith<$Res> {
  _$ApplicationFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? propertyAddress = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? slug = freezed,
    Object? isActive = freezed,
    Object? fields = freezed,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
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
            propertyAddress: freezed == propertyAddress
                ? _value.propertyAddress
                : propertyAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool?,
            fields: freezed == fields
                ? _value.fields
                : fields // ignore: cast_nullable_to_non_nullable
                      as List<ApplicationFormField>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationFormImplCopyWith<$Res>
    implements $ApplicationFormCopyWith<$Res> {
  factory _$$ApplicationFormImplCopyWith(
    _$ApplicationFormImpl value,
    $Res Function(_$ApplicationFormImpl) then,
  ) = __$$ApplicationFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'property_address') String? propertyAddress,
    String? title,
    String? description,
    String? slug,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
    List<ApplicationFormField>? fields,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'expires_at', fromJson: parseDateTime) DateTime? expiresAt,
  });
}

/// @nodoc
class __$$ApplicationFormImplCopyWithImpl<$Res>
    extends _$ApplicationFormCopyWithImpl<$Res, _$ApplicationFormImpl>
    implements _$$ApplicationFormImplCopyWith<$Res> {
  __$$ApplicationFormImplCopyWithImpl(
    _$ApplicationFormImpl _value,
    $Res Function(_$ApplicationFormImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? propertyAddress = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? slug = freezed,
    Object? isActive = freezed,
    Object? fields = freezed,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$ApplicationFormImpl(
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
        propertyAddress: freezed == propertyAddress
            ? _value.propertyAddress
            : propertyAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
        fields: freezed == fields
            ? _value._fields
            : fields // ignore: cast_nullable_to_non_nullable
                  as List<ApplicationFormField>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationFormImpl implements _ApplicationForm {
  const _$ApplicationFormImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(name: 'property_address') this.propertyAddress,
    this.title,
    this.description,
    this.slug,
    @JsonKey(name: 'is_active') this.isActive,
    @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
    final List<ApplicationFormField>? fields,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
    @JsonKey(name: 'expires_at', fromJson: parseDateTime) this.expiresAt,
  }) : _fields = fields;

  factory _$ApplicationFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationFormImplFromJson(json);

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
  @JsonKey(name: 'property_address')
  final String? propertyAddress;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? slug;
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;
  final List<ApplicationFormField>? _fields;
  @override
  @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
  List<ApplicationFormField>? get fields {
    final value = _fields;
    if (value == null) return null;
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'expires_at', fromJson: parseDateTime)
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'ApplicationForm(id: $id, propertyId: $propertyId, propertyName: $propertyName, propertyAddress: $propertyAddress, title: $title, description: $description, slug: $slug, isActive: $isActive, fields: $fields, createdAt: $createdAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationFormImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.propertyAddress, propertyAddress) ||
                other.propertyAddress == propertyAddress) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._fields, _fields) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    propertyId,
    propertyName,
    propertyAddress,
    title,
    description,
    slug,
    isActive,
    const DeepCollectionEquality().hash(_fields),
    createdAt,
    expiresAt,
  );

  /// Create a copy of ApplicationForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationFormImplCopyWith<_$ApplicationFormImpl> get copyWith =>
      __$$ApplicationFormImplCopyWithImpl<_$ApplicationFormImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationFormImplToJson(this);
  }
}

abstract class _ApplicationForm implements ApplicationForm {
  const factory _ApplicationForm({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(name: 'property_address') final String? propertyAddress,
    final String? title,
    final String? description,
    final String? slug,
    @JsonKey(name: 'is_active') final bool? isActive,
    @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
    final List<ApplicationFormField>? fields,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
    @JsonKey(name: 'expires_at', fromJson: parseDateTime)
    final DateTime? expiresAt,
  }) = _$ApplicationFormImpl;

  factory _ApplicationForm.fromJson(Map<String, dynamic> json) =
      _$ApplicationFormImpl.fromJson;

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
  @JsonKey(name: 'property_address')
  String? get propertyAddress;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get slug;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;
  @override
  @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
  List<ApplicationFormField>? get fields;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'expires_at', fromJson: parseDateTime)
  DateTime? get expiresAt;

  /// Create a copy of ApplicationForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationFormImplCopyWith<_$ApplicationFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
