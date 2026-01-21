// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_activity_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardActivityItem _$DashboardActivityItemFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardActivityItem.fromJson(json);
}

/// @nodoc
mixin _$DashboardActivityItem {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DashboardActivityItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardActivityItemCopyWith<DashboardActivityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardActivityItemCopyWith<$Res> {
  factory $DashboardActivityItemCopyWith(
    DashboardActivityItem value,
    $Res Function(DashboardActivityItem) then,
  ) = _$DashboardActivityItemCopyWithImpl<$Res, DashboardActivityItem>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? type,
    String? title,
    String? message,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class _$DashboardActivityItemCopyWithImpl<
  $Res,
  $Val extends DashboardActivityItem
>
    implements $DashboardActivityItemCopyWith<$Res> {
  _$DashboardActivityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? message = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DashboardActivityItemImplCopyWith<$Res>
    implements $DashboardActivityItemCopyWith<$Res> {
  factory _$$DashboardActivityItemImplCopyWith(
    _$DashboardActivityItemImpl value,
    $Res Function(_$DashboardActivityItemImpl) then,
  ) = __$$DashboardActivityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? type,
    String? title,
    String? message,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  });
}

/// @nodoc
class __$$DashboardActivityItemImplCopyWithImpl<$Res>
    extends
        _$DashboardActivityItemCopyWithImpl<$Res, _$DashboardActivityItemImpl>
    implements _$$DashboardActivityItemImplCopyWith<$Res> {
  __$$DashboardActivityItemImplCopyWithImpl(
    _$DashboardActivityItemImpl _value,
    $Res Function(_$DashboardActivityItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? message = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$DashboardActivityItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
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
class _$DashboardActivityItemImpl implements _DashboardActivityItem {
  const _$DashboardActivityItemImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.type,
    this.title,
    this.message,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  });

  factory _$DashboardActivityItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardActivityItemImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? type;
  @override
  final String? title;
  @override
  final String? message;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'DashboardActivityItem(id: $id, type: $type, title: $title, message: $message, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardActivityItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, title, message, createdAt);

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardActivityItemImplCopyWith<_$DashboardActivityItemImpl>
  get copyWith =>
      __$$DashboardActivityItemImplCopyWithImpl<_$DashboardActivityItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardActivityItemImplToJson(this);
  }
}

abstract class _DashboardActivityItem implements DashboardActivityItem {
  const factory _DashboardActivityItem({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? type,
    final String? title,
    final String? message,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$DashboardActivityItemImpl;

  factory _DashboardActivityItem.fromJson(Map<String, dynamic> json) =
      _$DashboardActivityItemImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get type;
  @override
  String? get title;
  @override
  String? get message;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of DashboardActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardActivityItemImplCopyWith<_$DashboardActivityItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}
