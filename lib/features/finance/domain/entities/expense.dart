import 'package:flutter/material.dart';

enum ExpenseCategory {
  maintenance,
  repairs,
  utilities,
  insurance,
  taxes,
  mortgage,
  management,
  legal,
  advertising,
  supplies,
  other,
  ;

  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => ExpenseCategory.other,
    );
  }

  String get displayName {
    switch (this) {
      case ExpenseCategory.maintenance:
        return 'Maintenance';
      case ExpenseCategory.repairs:
        return 'Repairs';
      case ExpenseCategory.utilities:
        return 'Utilities';
      case ExpenseCategory.insurance:
        return 'Insurance';
      case ExpenseCategory.taxes:
        return 'Taxes';
      case ExpenseCategory.mortgage:
        return 'Mortgage';
      case ExpenseCategory.management:
        return 'Management';
      case ExpenseCategory.legal:
        return 'Legal';
      case ExpenseCategory.advertising:
        return 'Advertising';
      case ExpenseCategory.supplies:
        return 'Supplies';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.maintenance:
        return Icons.build;
      case ExpenseCategory.repairs:
        return Icons.handyman;
      case ExpenseCategory.utilities:
        return Icons.flash_on;
      case ExpenseCategory.insurance:
        return Icons.security;
      case ExpenseCategory.taxes:
        return Icons.account_balance;
      case ExpenseCategory.mortgage:
        return Icons.home;
      case ExpenseCategory.management:
        return Icons.business;
      case ExpenseCategory.legal:
        return Icons.gavel;
      case ExpenseCategory.advertising:
        return Icons.campaign;
      case ExpenseCategory.supplies:
        return Icons.shopping_bag;
      case ExpenseCategory.other:
        return Icons.receipt_long;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.maintenance:
        return Colors.orange;
      case ExpenseCategory.repairs:
        return Colors.red;
      case ExpenseCategory.utilities:
        return Colors.amber;
      case ExpenseCategory.insurance:
        return Colors.blue;
      case ExpenseCategory.taxes:
        return Colors.indigo;
      case ExpenseCategory.mortgage:
        return Colors.purple;
      case ExpenseCategory.management:
        return Colors.teal;
      case ExpenseCategory.legal:
        return Colors.brown;
      case ExpenseCategory.advertising:
        return Colors.pink;
      case ExpenseCategory.supplies:
        return Colors.green;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }
}

final class Expense {
  const Expense({
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

  final int id;
  final int? propertyId;
  final String? propertyTitle;
  final ExpenseCategory category;
  final double amount;
  final DateTime expenseDate;
  final String description;
  final String? vendor;
  final String? receiptUrl;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasReceipt => receiptUrl != null;
  bool get isPropertyExpense => propertyId != null;
}
