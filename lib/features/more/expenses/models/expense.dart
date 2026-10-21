import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// An expense of a property (`Expense`). `title` is the label the owner typed.
/// `expense_date` is a date (`YYYY-MM-DD`).
@freezed
class Expense with _$Expense {
  const factory Expense({
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
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}

extension ExpenseCategoryLabel on ExpenseCategory {
  String get label => switch (this) {
    ExpenseCategory.maintenance => 'Maintenance',
    ExpenseCategory.repairs => 'Repairs',
    ExpenseCategory.insurance => 'Insurance',
    ExpenseCategory.propertyTax => 'Property tax',
    ExpenseCategory.hoa => 'HOA',
    ExpenseCategory.utilities => 'Utilities',
    ExpenseCategory.marketing => 'Marketing',
    ExpenseCategory.legal => 'Legal',
    ExpenseCategory.other => 'Other',
  };
}
