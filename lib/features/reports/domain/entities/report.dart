import 'package:flutter/material.dart';

/// Report type enum with display information
enum ReportType {
  rentRoll,
  income,
  expenses,
  profitAndLoss,
  occupancy,
  maintenance;

  String get displayName => switch (this) {
        rentRoll => 'Rent Roll',
        income => 'Income Report',
        expenses => 'Expenses Report',
        profitAndLoss => 'Profit & Loss',
        occupancy => 'Occupancy Report',
        maintenance => 'Maintenance Report',
      };

  String get description => switch (this) {
        rentRoll => 'Current rent status for all properties',
        income => 'Revenue breakdown by source',
        expenses => 'Expense breakdown by category',
        profitAndLoss => 'Net income and profit margins',
        occupancy => 'Vacancy rates and trends',
        maintenance => 'Maintenance costs and completion rates',
      };

  IconData get icon => switch (this) {
        rentRoll => Icons.receipt_long,
        income => Icons.trending_up,
        expenses => Icons.trending_down,
        profitAndLoss => Icons.analytics,
        occupancy => Icons.apartment,
        maintenance => Icons.build,
      };

  String get apiValue => switch (this) {
        rentRoll => 'rent-roll',
        income => 'income',
        expenses => 'expenses',
        profitAndLoss => 'pnl',
        occupancy => 'occupancy',
        maintenance => 'maintenance',
      };

  bool get requiresDateRange => switch (this) {
        rentRoll => false,
        income => true,
        expenses => true,
        profitAndLoss => true,
        occupancy => false,
        maintenance => false,
      };
}

/// Rent Roll Report - Current rent status for all properties
final class RentRollReport {
  const RentRollReport({
    required this.generatedAt,
    required this.totalProperties,
    required this.totalMonthlyRent,
    required this.totalCollected,
    required this.totalOutstanding,
    required this.items,
  });

  final DateTime? generatedAt;
  final int totalProperties;
  final double totalMonthlyRent;
  final double totalCollected;
  final double totalOutstanding;
  final List<RentRollItem> items;

  double get collectionRate =>
      totalMonthlyRent > 0 ? (totalCollected / totalMonthlyRent) * 100 : 0;
}

final class RentRollItem {
  const RentRollItem({
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyAddress,
    required this.tenantName,
    required this.leaseId,
    required this.monthlyRent,
    required this.amountPaid,
    required this.amountDue,
    required this.status,
    required this.dueDate,
  });

  final int propertyId;
  final String propertyTitle;
  final String? propertyAddress;
  final String? tenantName;
  final int? leaseId;
  final double monthlyRent;
  final double amountPaid;
  final double amountDue;
  final String status; // paid, partial, overdue, vacant
  final DateTime? dueDate;

  bool get isVacant => tenantName == null;
  bool get isPaid => status == 'paid';
  bool get isOverdue => status == 'overdue';
}

/// Income Report - Revenue breakdown
final class IncomeReport {
  const IncomeReport({
    required this.generatedAt,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.byCategory,
    required this.byMonth,
    required this.items,
  });

  final DateTime? generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalIncome;
  final List<IncomeCategoryBreakdown> byCategory;
  final List<IncomeMonthlyBreakdown> byMonth;
  final List<IncomeItem> items;
}

final class IncomeCategoryBreakdown {
  const IncomeCategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final String category;
  final double amount;
  final double percentage;
}

final class IncomeMonthlyBreakdown {
  const IncomeMonthlyBreakdown({
    required this.month,
    required this.amount,
  });

  final DateTime? month;
  final double amount;
}

final class IncomeItem {
  const IncomeItem({
    required this.id,
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
    required this.propertyId,
    required this.propertyTitle,
  });

  final int id;
  final DateTime? date;
  final String category;
  final String description;
  final double amount;
  final int? propertyId;
  final String? propertyTitle;
}

/// Expenses Report - Expense breakdown
final class ExpensesReport {
  const ExpensesReport({
    required this.generatedAt,
    required this.startDate,
    required this.endDate,
    required this.totalExpenses,
    required this.byCategory,
    required this.byMonth,
    required this.items,
  });

  final DateTime? generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalExpenses;
  final List<ExpenseCategoryBreakdown> byCategory;
  final List<ExpenseMonthlyBreakdown> byMonth;
  final List<ExpenseItem> items;
}

final class ExpenseCategoryBreakdown {
  const ExpenseCategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final String category;
  final double amount;
  final double percentage;
}

final class ExpenseMonthlyBreakdown {
  const ExpenseMonthlyBreakdown({
    required this.month,
    required this.amount,
  });

  final DateTime? month;
  final double amount;
}

final class ExpenseItem {
  const ExpenseItem({
    required this.id,
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
    required this.vendor,
    required this.propertyId,
    required this.propertyTitle,
  });

  final int id;
  final DateTime? date;
  final String category;
  final String description;
  final double amount;
  final String? vendor;
  final int? propertyId;
  final String? propertyTitle;
}

/// Profit & Loss Report
final class ProfitAndLossReport {
  const ProfitAndLossReport({
    required this.generatedAt,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netIncome,
    required this.profitMargin,
    required this.incomeBreakdown,
    required this.expenseBreakdown,
    required this.byMonth,
  });

  final DateTime? generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalIncome;
  final double totalExpenses;
  final double netIncome;
  final double profitMargin;
  final List<IncomeCategoryBreakdown> incomeBreakdown;
  final List<ExpenseCategoryBreakdown> expenseBreakdown;
  final List<PnLMonthlyBreakdown> byMonth;
}

final class PnLMonthlyBreakdown {
  const PnLMonthlyBreakdown({
    required this.month,
    required this.income,
    required this.expenses,
    required this.netIncome,
  });

  final DateTime? month;
  final double income;
  final double expenses;
  final double netIncome;
}

/// Occupancy Report
final class OccupancyReport {
  const OccupancyReport({
    required this.generatedAt,
    required this.totalProperties,
    required this.occupiedProperties,
    required this.vacantProperties,
    required this.occupancyRate,
    required this.averageVacancyDays,
    required this.byPropertyType,
    required this.items,
  });

  final DateTime? generatedAt;
  final int totalProperties;
  final int occupiedProperties;
  final int vacantProperties;
  final double occupancyRate;
  final int averageVacancyDays;
  final List<OccupancyByType> byPropertyType;
  final List<OccupancyItem> items;
}

final class OccupancyByType {
  const OccupancyByType({
    required this.propertyType,
    required this.total,
    required this.occupied,
    required this.vacant,
    required this.occupancyRate,
  });

  final String propertyType;
  final int total;
  final int occupied;
  final int vacant;
  final double occupancyRate;
}

final class OccupancyItem {
  const OccupancyItem({
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyType,
    required this.isOccupied,
    required this.tenantName,
    required this.leaseEndDate,
    required this.vacantSince,
    required this.daysVacant,
  });

  final int propertyId;
  final String propertyTitle;
  final String propertyType;
  final bool isOccupied;
  final String? tenantName;
  final DateTime? leaseEndDate;
  final DateTime? vacantSince;
  final int? daysVacant;
}

/// Maintenance Report
final class MaintenanceReport {
  const MaintenanceReport({
    required this.generatedAt,
    required this.totalRequests,
    required this.openRequests,
    required this.completedRequests,
    required this.totalCost,
    required this.averageCompletionDays,
    required this.byPriority,
    required this.byCategory,
    required this.items,
  });

  final DateTime? generatedAt;
  final int totalRequests;
  final int openRequests;
  final int completedRequests;
  final double totalCost;
  final double averageCompletionDays;
  final List<MaintenanceByPriority> byPriority;
  final List<MaintenanceByCategory> byCategory;
  final List<MaintenanceReportItem> items;

  double get completionRate =>
      totalRequests > 0 ? (completedRequests / totalRequests) * 100 : 0;
}

final class MaintenanceByPriority {
  const MaintenanceByPriority({
    required this.priority,
    required this.count,
    required this.percentage,
  });

  final String priority;
  final int count;
  final double percentage;
}

final class MaintenanceByCategory {
  const MaintenanceByCategory({
    required this.category,
    required this.count,
    required this.totalCost,
  });

  final String category;
  final int count;
  final double totalCost;
}

final class MaintenanceReportItem {
  const MaintenanceReportItem({
    required this.id,
    required this.title,
    required this.propertyId,
    required this.propertyTitle,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.completedAt,
    required this.cost,
    required this.daysToComplete,
  });

  final int id;
  final String title;
  final int propertyId;
  final String propertyTitle;
  final String priority;
  final String status;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final double? cost;
  final int? daysToComplete;
}
