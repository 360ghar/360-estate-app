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
  String? get title => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_name')
  String? get fileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_at', fromJson: parseDateTime)
  DateTime? get uploadedAt => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

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
    String? title,
    String? type,
    @JsonKey(name: 'file_name') String? fileName,
    @JsonKey(name: 'uploaded_at', fromJson: parseDateTime) DateTime? uploadedAt,
    String? url,
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
    Object? title = freezed,
    Object? type = freezed,
    Object? fileName = freezed,
    Object? uploadedAt = freezed,
    Object? url = freezed,
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
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileName: freezed == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String?,
            uploadedAt: freezed == uploadedAt
                ? _value.uploadedAt
                : uploadedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String? title,
    String? type,
    @JsonKey(name: 'file_name') String? fileName,
    @JsonKey(name: 'uploaded_at', fromJson: parseDateTime) DateTime? uploadedAt,
    String? url,
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
    Object? title = freezed,
    Object? type = freezed,
    Object? fileName = freezed,
    Object? uploadedAt = freezed,
    Object? url = freezed,
  }) {
    return _then(
      _$DocumentItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileName: freezed == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String?,
        uploadedAt: freezed == uploadedAt
            ? _value.uploadedAt
            : uploadedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentItemImpl implements _DocumentItem {
  const _$DocumentItemImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.title,
    this.type,
    @JsonKey(name: 'file_name') this.fileName,
    @JsonKey(name: 'uploaded_at', fromJson: parseDateTime) this.uploadedAt,
    this.url,
  });

  factory _$DocumentItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentItemImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? title;
  @override
  final String? type;
  @override
  @JsonKey(name: 'file_name')
  final String? fileName;
  @override
  @JsonKey(name: 'uploaded_at', fromJson: parseDateTime)
  final DateTime? uploadedAt;
  @override
  final String? url;

  @override
  String toString() {
    return 'DocumentItem(id: $id, title: $title, type: $type, fileName: $fileName, uploadedAt: $uploadedAt, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, type, fileName, uploadedAt, url);

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
    final String? title,
    final String? type,
    @JsonKey(name: 'file_name') final String? fileName,
    @JsonKey(name: 'uploaded_at', fromJson: parseDateTime)
    final DateTime? uploadedAt,
    final String? url,
  }) = _$DocumentItemImpl;

  factory _DocumentItem.fromJson(Map<String, dynamic> json) =
      _$DocumentItemImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get title;
  @override
  String? get type;
  @override
  @JsonKey(name: 'file_name')
  String? get fileName;
  @override
  @JsonKey(name: 'uploaded_at', fromJson: parseDateTime)
  DateTime? get uploadedAt;
  @override
  String? get url;

  /// Create a copy of DocumentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentItemImplCopyWith<_$DocumentItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
