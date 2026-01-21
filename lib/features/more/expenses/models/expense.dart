import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
class Expense with _$Expense {
  const factory Expense({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    @JsonKey(fromJson: parseDouble) double? amount,
    @JsonKey(name: 'expense_date', fromJson: parseDateTime) DateTime? date,
    String? category,
    String? notes,
    @JsonKey(name: 'property_name') String? propertyName,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
