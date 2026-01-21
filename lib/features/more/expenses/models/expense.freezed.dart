// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return _Expense.fromJson(json);
}

/// @nodoc
mixin _$Expense {
  @JsonKey(fromJson: parseInt)
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_date', fromJson: parseDateTime)
  DateTime? get date => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCopyWith<Expense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res, Expense>;
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime) DateTime? date,
    String? category,
    String? notes,
    @JsonKey(name: 'property_name') String? propertyName,
  });
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res, $Val extends Expense>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? amount = freezed,
    Object? date = freezed,
    Object? category = freezed,
    Object? notes = freezed,
    Object? propertyName = freezed,
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
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpenseImplCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$$ExpenseImplCopyWith(
    _$ExpenseImpl value,
    $Res Function(_$ExpenseImpl) then,
  ) = __$$ExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime) DateTime? date,
    String? category,
    String? notes,
    @JsonKey(name: 'property_name') String? propertyName,
  });
}

/// @nodoc
class __$$ExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$ExpenseImpl>
    implements _$$ExpenseImplCopyWith<$Res> {
  __$$ExpenseImplCopyWithImpl(
    _$ExpenseImpl _value,
    $Res Function(_$ExpenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? amount = freezed,
    Object? date = freezed,
    Object? category = freezed,
    Object? notes = freezed,
    Object? propertyName = freezed,
  }) {
    return _then(
      _$ExpenseImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseImpl implements _Expense {
  const _$ExpenseImpl({
    @JsonKey(fromJson: parseInt) this.id,
    this.title,
    @JsonKey(fromJson: parseDouble) this.amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime) this.date,
    this.category,
    this.notes,
    @JsonKey(name: 'property_name') this.propertyName,
  });

  factory _$ExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int? id;
  @override
  final String? title;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? amount;
  @override
  @JsonKey(name: 'expense_date', fromJson: parseDateTime)
  final DateTime? date;
  @override
  final String? category;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, date: $date, category: $category, notes: $notes, propertyName: $propertyName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    amount,
    date,
    category,
    notes,
    propertyName,
  );

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      __$$ExpenseImplCopyWithImpl<_$ExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseImplToJson(this);
  }
}

abstract class _Expense implements Expense {
  const factory _Expense({
    @JsonKey(fromJson: parseInt) final int? id,
    final String? title,
    @JsonKey(fromJson: parseDouble) final double? amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime)
    final DateTime? date,
    final String? category,
    final String? notes,
    @JsonKey(name: 'property_name') final String? propertyName,
  }) = _$ExpenseImpl;

  factory _Expense.fromJson(Map<String, dynamic> json) = _$ExpenseImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int? get id;
  @override
  String? get title;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get amount;
  @override
  @JsonKey(name: 'expense_date', fromJson: parseDateTime)
  DateTime? get date;
  @override
  String? get category;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
