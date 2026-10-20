// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DocumentItem _$DocumentItemFromJson(Map<String, dynamic> json) {
  return _DocumentItem.fromJson(json);
}

/// @nodoc
mixin _$DocumentItem {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'document_type',
    fromJson: DocumentType.fromJson,
    toJson: DocumentType.toJsonValue,
  )
  DocumentType? get documentType => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_url')
  String? get fileUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'mime_type')
  String? get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size', fromJson: parseInt)
  int? get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'shared_with_tenant')
  bool? get sharedWithTenant => throw _privateConstructorUsedError;
  @JsonKey(name: 'shared_with_agent')
  bool? get sharedWithAgent => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DocumentItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentItemCopyWith<DocumentItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentItemCopyWith<$Res> {
  factory $DocumentItemCopyWith(
    DocumentItem value,
    $Res Function(DocumentItem) then,
  ) = _$DocumentItemCopyWithImpl<$Res, DocumentItem>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(
      name: 'document_type',
      fromJson: DocumentType.fromJson,
      toJson: DocumentType.toJsonValue,
    )
    DocumentType? documentType,
    String? title,
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'file_size', fromJson: parseInt) int? fileSize,
    @JsonKey(name: 'shared_with_tenant') bool? sharedWithTenant,
    @JsonKey(name: 'shared_with_agent') bool? sharedWithAgent,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class _$DocumentItemCopyWithImpl<$Res, $Val extends DocumentItem>
    implements $DocumentItemCopyWith<$Res> {
  _$DocumentItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? propertyId = freezed,
    Object? leaseId = freezed,
    Object? documentType = freezed,
    Object? title = freezed,
    Object? fileUrl = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? sharedWithTenant = freezed,
    Object? sharedWithAgent = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            propertyId: freezed == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            leaseId: freezed == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            documentType: freezed == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as DocumentType?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileUrl: freezed == fileUrl
                ? _value.fileUrl
                : fileUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mimeType: freezed == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            sharedWithTenant: freezed == sharedWithTenant
                ? _value.sharedWithTenant
                : sharedWithTenant // ignore: cast_nullable_to_non_nullable
                      as bool?,
            sharedWithAgent: freezed == sharedWithAgent
                ? _value.sharedWithAgent
                : sharedWithAgent // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$DocumentItemImplCopyWith<$Res>
    implements $DocumentItemCopyWith<$Res> {
  factory _$$DocumentItemImplCopyWith(
    _$DocumentItemImpl value,
    $Res Function(_$DocumentItemImpl) then,
  ) = __$$DocumentItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(
      name: 'document_type',
      fromJson: DocumentType.fromJson,
      toJson: DocumentType.toJsonValue,
    )
    DocumentType? documentType,
    String? title,
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'file_size', fromJson: parseInt) int? fileSize,
    @JsonKey(name: 'shared_with_tenant') bool? sharedWithTenant,
    @JsonKey(name: 'shared_with_agent') bool? sharedWithAgent,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class __$$DocumentItemImplCopyWithImpl<$Res>
    extends _$DocumentItemCopyWithImpl<$Res, _$DocumentItemImpl>
    implements _$$DocumentItemImplCopyWith<$Res> {
  __$$DocumentItemImplCopyWithImpl(
    _$DocumentItemImpl _value,
    $Res Function(_$DocumentItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? propertyId = freezed,
    Object? leaseId = freezed,
    Object? documentType = freezed,
    Object? title = freezed,
    Object? fileUrl = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? sharedWithTenant = freezed,
    Object? sharedWithAgent = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$DocumentItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        propertyId: freezed == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        leaseId: freezed == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        documentType: freezed == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as DocumentType?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileUrl: freezed == fileUrl
            ? _value.fileUrl
            : fileUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mimeType: freezed == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        sharedWithTenant: freezed == sharedWithTenant
            ? _value.sharedWithTenant
            : sharedWithTenant // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sharedWithAgent: freezed == sharedWithAgent
            ? _value.sharedWithAgent
            : sharedWithAgent // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
class _$DocumentItemImpl implements _DocumentItem {
  const _$DocumentItemImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'owner_id', fromJson: parseInt) this.ownerId,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) this.leaseId,
    @JsonKey(
      name: 'document_type',
      fromJson: DocumentType.fromJson,
      toJson: DocumentType.toJsonValue,
    )
    this.documentType,
    this.title,
    @JsonKey(name: 'file_url') this.fileUrl,
    @JsonKey(name: 'mime_type') this.mimeType,
    @JsonKey(name: 'file_size', fromJson: parseInt) this.fileSize,
    @JsonKey(name: 'shared_with_tenant') this.sharedWithTenant,
    @JsonKey(name: 'shared_with_agent') this.sharedWithAgent,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  });

  factory _$DocumentItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentItemImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  final int? ownerId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  final int? propertyId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  final int? leaseId;
  @override
  @JsonKey(
    name: 'document_type',
    fromJson: DocumentType.fromJson,
    toJson: DocumentType.toJsonValue,
  )
  final DocumentType? documentType;
  @override
  final String? title;
  @override
  @JsonKey(name: 'file_url')
  final String? fileUrl;
  @override
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  @override
  @JsonKey(name: 'file_size', fromJson: parseInt)
  final int? fileSize;
  @override
  @JsonKey(name: 'shared_with_tenant')
  final bool? sharedWithTenant;
  @override
  @JsonKey(name: 'shared_with_agent')
  final bool? sharedWithAgent;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'DocumentItem(id: $id, ownerId: $ownerId, propertyId: $propertyId, leaseId: $leaseId, documentType: $documentType, title: $title, fileUrl: $fileUrl, mimeType: $mimeType, fileSize: $fileSize, sharedWithTenant: $sharedWithTenant, sharedWithAgent: $sharedWithAgent, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.sharedWithTenant, sharedWithTenant) ||
                other.sharedWithTenant == sharedWithTenant) &&
            (identical(other.sharedWithAgent, sharedWithAgent) ||
                other.sharedWithAgent == sharedWithAgent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    propertyId,
    leaseId,
    documentType,
    title,
    fileUrl,
    mimeType,
    fileSize,
    sharedWithTenant,
    sharedWithAgent,
    createdAt,
  );

  /// Create a copy of DocumentItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentItemImplCopyWith<_$DocumentItemImpl> get copyWith =>
      __$$DocumentItemImplCopyWithImpl<_$DocumentItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentItemImplToJson(this);
  }
}

abstract class _DocumentItem implements DocumentItem {
  const factory _DocumentItem({
    @JsonKey(fromJson: parseInt) final int? id,
    @JsonKey(name: 'owner_id', fromJson: parseInt) final int? ownerId,
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) final int? leaseId,
    @JsonKey(
      name: 'document_type',
      fromJson: DocumentType.fromJson,
      toJson: DocumentType.toJsonValue,
    )
    final DocumentType? documentType,
    final String? title,
    @JsonKey(name: 'file_url') final String? fileUrl,
    @JsonKey(name: 'mime_type') final String? mimeType,
    @JsonKey(name: 'file_size', fromJson: parseInt) final int? fileSize,
    @JsonKey(name: 'shared_with_tenant') final bool? sharedWithTenant,
    @JsonKey(name: 'shared_with_agent') final bool? sharedWithAgent,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$DocumentItemImpl;

  factory _DocumentItem.fromJson(Map<String, dynamic> json) =
      _$DocumentItemImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId;
  @override
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId;
  @override
  @JsonKey(name: 'lease_id', fromJson: parseInt)
  int? get leaseId;
  @override
  @JsonKey(
    name: 'document_type',
    fromJson: DocumentType.fromJson,
    toJson: DocumentType.toJsonValue,
  )
  DocumentType? get documentType;
  @override
  String? get title;
  @override
  @JsonKey(name: 'file_url')
  String? get fileUrl;
  @override
  @JsonKey(name: 'mime_type')
  String? get mimeType;
  @override
  @JsonKey(name: 'file_size', fromJson: parseInt)
  int? get fileSize;
  @override
  @JsonKey(name: 'shared_with_tenant')
  bool? get sharedWithTenant;
  @override
  @JsonKey(name: 'shared_with_agent')
  bool? get sharedWithAgent;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of DocumentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentItemImplCopyWith<_$DocumentItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
