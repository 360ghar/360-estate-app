import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/finance/domain/entities/expense.dart';

final class ExpenseDto {
  const ExpenseDto({
    required this.id,
    this.propertyId,
    this.propertyTitle,
    required this.category,
    required this.amount,
    required this.expenseDate,
    required this.description,
    this.vendor,
    this.receiptUrl,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    return ExpenseDto(
      id: parseInt(json['id']) ?? 0,
      propertyId: json['property_id'] as int? ?? json['propertyId'] as int?,
      propertyTitle:
          json['property_title'] as String? ?? json['propertyTitle'] as String?,
      category: json['category'] as String? ?? 'other',
      amount: _parseDouble(json['amount']),
      expenseDate:
          parseDateTime(
            json['expense_date'] as String? ??
                json['expenseDate'] as String? ??
                DateTime.now().toIso8601String(),
          ) ??
          DateTime.now(),
      description: json['description'] as String? ?? '',
      vendor: json['vendor'] as String?,
      receiptUrl:
          json['receipt_url'] as String? ?? json['receiptUrl'] as String?,
      notes: json['notes'] as String?,
      createdAt: parseDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: parseDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  final int id;
  final int? propertyId;
  final String? propertyTitle;
  final String category;
  final double amount;
  final DateTime expenseDate;
  final String description;
  final String? vendor;
  final String? receiptUrl;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (propertyId != null) 'property_id': propertyId,
      'category': category,
      'amount': amount,
      'expense_date': toApiDateOnly(expenseDate),
      'description': description,
      if (vendor != null) 'vendor': vendor,
      if (notes != null) 'notes': notes,
    };
  }

  Expense toEntity() {
    return Expense(
      id: id,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      category: ExpenseCategory.fromString(category),
      amount: amount,
      expenseDate: expenseDate,
      description: description,
      vendor: vendor,
      receiptUrl: receiptUrl,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
