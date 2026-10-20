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
  @JsonKey(name: 'property_id', fromJson: parseInt)
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: ExpenseCategory.fromJson,
    toJson: ExpenseCategory.toJsonValue,
  )
  ExpenseCategory? get category => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_date', fromJson: parseDateTime)
  DateTime? get date => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_document_id', fromJson: parseInt)
  int? get receiptDocumentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(
      fromJson: ExpenseCategory.fromJson,
      toJson: ExpenseCategory.toJsonValue,
    )
    ExpenseCategory? category,
    String? title,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime) DateTime? date,
    String? description,
    String? notes,
    @JsonKey(name: 'receipt_document_id', fromJson: parseInt)
    int? receiptDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
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
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? ownerId = freezed,
    Object? category = freezed,
    Object? title = freezed,
    Object? amount = freezed,
    Object? date = freezed,
    Object? description = freezed,
    Object? notes = freezed,
    Object? receiptDocumentId = freezed,
    Object? createdAt = freezed,
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
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as int?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as ExpenseCategory?,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiptDocumentId: freezed == receiptDocumentId
                ? _value.receiptDocumentId
                : receiptDocumentId // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$ExpenseImplCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$$ExpenseImplCopyWith(
    _$ExpenseImpl value,
    $Res Function(_$ExpenseImpl) then,
  ) = __$$ExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(
      fromJson: ExpenseCategory.fromJson,
      toJson: ExpenseCategory.toJsonValue,
    )
    ExpenseCategory? category,
    String? title,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime) DateTime? date,
    String? description,
    String? notes,
    @JsonKey(name: 'receipt_document_id', fromJson: parseInt)
    int? receiptDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
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
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? ownerId = freezed,
    Object? category = freezed,
    Object? title = freezed,
    Object? amount = freezed,
    Object? date = freezed,
    Object? description = freezed,
    Object? notes = freezed,
    Object? receiptDocumentId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ExpenseImpl(
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
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as int?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as ExpenseCategory?,
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiptDocumentId: freezed == receiptDocumentId
            ? _value.receiptDocumentId
            : receiptDocumentId // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$ExpenseImpl implements _Expense {
  const _$ExpenseImpl({
    @JsonKey(fromJson: parseInt) this.id,
    @JsonKey(name: 'property_id', fromJson: parseInt) this.propertyId,
    @JsonKey(name: 'property_name') this.propertyName,
    @JsonKey(name: 'owner_id', fromJson: parseInt) this.ownerId,
    @JsonKey(
      fromJson: ExpenseCategory.fromJson,
      toJson: ExpenseCategory.toJsonValue,
    )
    this.category,
    this.title,
    @JsonKey(fromJson: parseDouble) this.amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime) this.date,
    this.description,
    this.notes,
    @JsonKey(name: 'receipt_document_id', fromJson: parseInt)
    this.receiptDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) this.createdAt,
  });

  factory _$ExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseImplFromJson(json);

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
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  final int? ownerId;
  @override
  @JsonKey(
    fromJson: ExpenseCategory.fromJson,
    toJson: ExpenseCategory.toJsonValue,
  )
  final ExpenseCategory? category;
  @override
  final String? title;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? amount;
  @override
  @JsonKey(name: 'expense_date', fromJson: parseDateTime)
  final DateTime? date;
  @override
  final String? description;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'receipt_document_id', fromJson: parseInt)
  final int? receiptDocumentId;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Expense(id: $id, propertyId: $propertyId, propertyName: $propertyName, ownerId: $ownerId, category: $category, title: $title, amount: $amount, date: $date, description: $description, notes: $notes, receiptDocumentId: $receiptDocumentId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.receiptDocumentId, receiptDocumentId) ||
                other.receiptDocumentId == receiptDocumentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    propertyId,
    propertyName,
    ownerId,
    category,
    title,
    amount,
    date,
    description,
    notes,
    receiptDocumentId,
    createdAt,
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
    @JsonKey(name: 'property_id', fromJson: parseInt) final int? propertyId,
    @JsonKey(name: 'property_name') final String? propertyName,
    @JsonKey(name: 'owner_id', fromJson: parseInt) final int? ownerId,
    @JsonKey(
      fromJson: ExpenseCategory.fromJson,
      toJson: ExpenseCategory.toJsonValue,
    )
    final ExpenseCategory? category,
    final String? title,
    @JsonKey(fromJson: parseDouble) final double? amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime)
    final DateTime? date,
    final String? description,
    final String? notes,
    @JsonKey(name: 'receipt_document_id', fromJson: parseInt)
    final int? receiptDocumentId,
    @JsonKey(name: 'created_at', fromJson: parseDateTime)
    final DateTime? createdAt,
  }) = _$ExpenseImpl;

  factory _Expense.fromJson(Map<String, dynamic> json) = _$ExpenseImpl.fromJson;

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
  @JsonKey(name: 'owner_id', fromJson: parseInt)
  int? get ownerId;
  @override
  @JsonKey(
    fromJson: ExpenseCategory.fromJson,
    toJson: ExpenseCategory.toJsonValue,
  )
  ExpenseCategory? get category;
  @override
  String? get title;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get amount;
  @override
  @JsonKey(name: 'expense_date', fromJson: parseDateTime)
  DateTime? get date;
  @override
  String? get description;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'receipt_document_id', fromJson: parseInt)
  int? get receiptDocumentId;
  @override
  @JsonKey(name: 'created_at', fromJson: parseDateTime)
  DateTime? get createdAt;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
