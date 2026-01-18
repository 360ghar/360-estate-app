// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MaintenanceRequest _$MaintenanceRequestFromJson(Map<String, dynamic> json) {
  return _MaintenanceRequest.fromJson(json);
}

/// @nodoc
mixin _$MaintenanceRequest {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_name')
  String? get tenantName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringList)
  List<String>? get attachments => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MaintenanceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaintenanceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceRequestCopyWith<MaintenanceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceRequestCopyWith<$Res> {
  factory $MaintenanceRequestCopyWith(
    MaintenanceRequest value,
    $Res Function(MaintenanceRequest) then,
  ) = _$MaintenanceRequestCopyWithImpl<$Res, MaintenanceRequest>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(fromJson: parseStringList) List<String>? attachments,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  });
}

/// @nodoc
class _$MaintenanceRequestCopyWithImpl<$Res, $Val extends MaintenanceRequest>
    implements $MaintenanceRequestCopyWith<$Res> {
  _$MaintenanceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenanceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? priority = freezed,
    Object? propertyName = freezed,
    Object? tenantName = freezed,
    Object? attachments = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenantName: freezed == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            attachments: freezed == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
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
abstract class _$$MaintenanceRequestImplCopyWith<$Res>
    implements $MaintenanceRequestCopyWith<$Res> {
  factory _$$MaintenanceRequestImplCopyWith(
    _$MaintenanceRequestImpl value,
    $Res Function(_$MaintenanceRequestImpl) then,
  ) = __$$MaintenanceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(fromJson: parseStringList) List<String>? attachments,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$MaintenanceRequestImplCopyWithImpl<$Res>
    extends _$MaintenanceRequestCopyWithImpl<$Res, _$MaintenanceRequestImpl>
    implements _$$MaintenanceRequestImplCopyWith<$Res> {
  __$$MaintenanceRequestImplCopyWithImpl(
    _$MaintenanceRequestImpl _value,
    $Res Function(_$MaintenanceRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaintenanceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? priority = freezed,
    Object? propertyName = freezed,
    Object? tenantName = freezed,
    Object? attachments = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$MaintenanceRequestImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenantName: freezed == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        attachments: freezed == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
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
class _$MaintenanceRequestImpl implements _MaintenanceRequest {
  const _$MaintenanceRequestImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.title,
    this.description,
    this.status,
    this.priority,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(name: 'tenant_name') this.tenantName,
    @JsonKey(fromJson: parseStringList) final List<String>? attachments,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) this.updatedAt,
  }) : _attachments = attachments;

  factory _$MaintenanceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaintenanceRequestImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? status;
  @override
  final String? priority;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'tenant_name')
  final String? tenantName;
  final List<String>? _attachments;
  @override
  @JsonKey(fromJson: parseStringList)
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MaintenanceRequest(id: $id, title: $title, description: $description, status: $status, priority: $priority, propertyName: $propertyName, tenantName: $tenantName, attachments: $attachments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
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
    title,
    description,
    status,
    priority,
    propertyName,
    tenantName,
    const DeepCollectionEquality().hash(_attachments),
    createdAt,
    updatedAt,
  );

  /// Create a copy of MaintenanceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceRequestImplCopyWith<_$MaintenanceRequestImpl> get copyWith =>
      __$$MaintenanceRequestImplCopyWithImpl<_$MaintenanceRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceRequestImplToJson(this);
  }
}

abstract class _MaintenanceRequest implements MaintenanceRequest {
  const factory _MaintenanceRequest({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? title,
    final String? description,
    final String? status,
    final String? priority,
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(name: 'tenant_name') final String? tenantName,
    @JsonKey(fromJson: parseStringList) final List<String>? attachments,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime)
    final DateTime? updatedAt,
  }) = _$MaintenanceRequestImpl;

  factory _MaintenanceRequest.fromJson(Map<String, dynamic> json) =
      _$MaintenanceRequestImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get status;
  @override
  String? get priority;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'tenant_name')
  String? get tenantName;
  @override
  @JsonKey(fromJson: parseStringList)
  List<String>? get attachments;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: parseDateTime)
  DateTime? get updatedAt;

  /// Create a copy of MaintenanceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceRequestImplCopyWith<_$MaintenanceRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
