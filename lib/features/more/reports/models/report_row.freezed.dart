// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportRow _$ReportRowFromJson(Map<String, dynamic> json) {
  return _ReportRow.fromJson(json);
}

/// @nodoc
mixin _$ReportRow {
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get amount => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;

  /// Serializes this ReportRow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportRowCopyWith<ReportRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportRowCopyWith<$Res> {
  factory $ReportRowCopyWith(ReportRow value, $Res Function(ReportRow) then) =
      _$ReportRowCopyWithImpl<$Res, ReportRow>;
  @useResult
  $Res call({
    String? label,
    @JsonKey(fromJson: parseDouble) double? amount,
    String? value,
  });
}

/// @nodoc
class _$ReportRowCopyWithImpl<$Res, $Val extends ReportRow>
    implements $ReportRowCopyWith<$Res> {
  _$ReportRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? amount = freezed,
    Object? value = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            value: freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportRowImplCopyWith<$Res>
    implements $ReportRowCopyWith<$Res> {
  factory _$$ReportRowImplCopyWith(
    _$ReportRowImpl value,
    $Res Function(_$ReportRowImpl) then,
  ) = __$$ReportRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? label,
    @JsonKey(fromJson: parseDouble) double? amount,
    String? value,
  });
}

/// @nodoc
class __$$ReportRowImplCopyWithImpl<$Res>
    extends _$ReportRowCopyWithImpl<$Res, _$ReportRowImpl>
    implements _$$ReportRowImplCopyWith<$Res> {
  __$$ReportRowImplCopyWithImpl(
    _$ReportRowImpl _value,
    $Res Function(_$ReportRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? amount = freezed,
    Object? value = freezed,
  }) {
    return _then(
      _$ReportRowImpl(
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        value: freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportRowImpl implements _ReportRow {
  const _$ReportRowImpl({
    this.label,
    @JsonKey(fromJson: parseDouble) this.amount,
    this.value,
  });

  factory _$ReportRowImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportRowImplFromJson(json);

  @override
  final String? label;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? amount;
  @override
  final String? value;

  @override
  String toString() {
    return 'ReportRow(label: $label, amount: $amount, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportRowImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, amount, value);

  /// Create a copy of ReportRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportRowImplCopyWith<_$ReportRowImpl> get copyWith =>
      __$$ReportRowImplCopyWithImpl<_$ReportRowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportRowImplToJson(this);
  }
}

abstract class _ReportRow implements ReportRow {
  const factory _ReportRow({
    final String? label,
    @JsonKey(fromJson: parseDouble) final double? amount,
    final String? value,
  }) = _$ReportRowImpl;

  factory _ReportRow.fromJson(Map<String, dynamic> json) =
      _$ReportRowImpl.fromJson;

  @override
  String? get label;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get amount;
  @override
  String? get value;

  /// Create a copy of ReportRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportRowImplCopyWith<_$ReportRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
