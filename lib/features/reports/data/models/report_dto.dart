import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/reports/domain/entities/report.dart';

// Rent Roll DTOs
final class RentRollItemDto {
  const RentRollItemDto({
    required this.propertyId,
    required this.propertyTitle,
    this.propertyAddress,
    this.tenantName,
    this.leaseId,
    required this.monthlyRent,
    required this.amountPaid,
    required this.amountDue,
    required this.status,
    this.dueDate,
  });

  factory RentRollItemDto.fromJson(Map<String, dynamic> json) {
    return RentRollItemDto(
      propertyId: parseInt(json['property_id']) ?? 0,
      propertyTitle: parseString(json['property_title']) ?? '',
      propertyAddress: json['property_address'] as String?,
      tenantName: json['tenant_name'] as String?,
      leaseId: parseInt(json['lease_id']),
      monthlyRent: parseDouble(json['monthly_rent']) ?? 0,
      amountPaid: parseDouble(json['amount_paid']) ?? 0,
      amountDue: parseDouble(json['amount_due']) ?? 0,
      status: parseString(json['status']) ?? '',
      dueDate: parseDateTime(json['due_date']),
    );
  }

  final int propertyId;
  final String propertyTitle;
  final String? propertyAddress;
  final String? tenantName;
  final int? leaseId;
  final double monthlyRent;
  final double amountPaid;
  final double amountDue;
  final String status;
  final DateTime? dueDate;

  RentRollItem toEntity() => RentRollItem(
        propertyId: propertyId,
        propertyTitle: propertyTitle,
        propertyAddress: propertyAddress,
        tenantName: tenantName,
        leaseId: leaseId,
        monthlyRent: monthlyRent,
        amountPaid: amountPaid,
        amountDue: amountDue,
        status: status,
        dueDate: dueDate,
      );
}

final class RentRollReportDto {
  const RentRollReportDto({
    required this.generatedAt,
    required this.totalProperties,
    required this.totalMonthlyRent,
    required this.totalCollected,
    required this.totalOutstanding,
    required this.items,
  });

  factory RentRollReportDto.fromJson(Map<String, dynamic> json) {
    return RentRollReportDto(
      generatedAt: parseDateTime(json['generated_at']),
      totalProperties: parseInt(json['total_properties']) ?? 0,
      totalMonthlyRent: parseDouble(json['total_monthly_rent']) ?? 0,
      totalCollected: parseDouble(json['total_collected']) ?? 0,
      totalOutstanding: parseDouble(json['total_outstanding']) ?? 0,
      items: parseList(json['items'])
          .whereType<Map<String, dynamic>>()
          .map(RentRollItemDto.fromJson)
          .toList(),
    );
  }

  final DateTime? generatedAt;
  final int totalProperties;
  final double totalMonthlyRent;
  final double totalCollected;
  final double totalOutstanding;
  final List<RentRollItemDto> items;

  RentRollReport toEntity() => RentRollReport(
        generatedAt: generatedAt,
        totalProperties: totalProperties,
        totalMonthlyRent: totalMonthlyRent,
        totalCollected: totalCollected,
        totalOutstanding: totalOutstanding,
        items: items.map((e) => e.toEntity()).toList(),
      );
}

// Income Report DTOs
final class IncomeCategoryBreakdownDto {
  const IncomeCategoryBreakdownDto({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  factory IncomeCategoryBreakdownDto.fromJson(Map<String, dynamic> json) {
    return IncomeCategoryBreakdownDto(
      category: parseString(json['category']) ?? '',
      amount: parseDouble(json['amount']) ?? 0,
      percentage: parseDouble(json['percentage']) ?? 0,
    );
  }

  final String category;
  final double amount;
  final double percentage;

  IncomeCategoryBreakdown toEntity() => IncomeCategoryBreakdown(
        category: category,
        amount: amount,
        percentage: percentage,
      );
}

final class IncomeMonthlyBreakdownDto {
  const IncomeMonthlyBreakdownDto({
    required this.month,
    required this.amount,
  });

  factory IncomeMonthlyBreakdownDto.fromJson(Map<String, dynamic> json) {
    return IncomeMonthlyBreakdownDto(
      month: parseDateTime(json['month']),
      amount: parseDouble(json['amount']) ?? 0,
    );
  }

  final DateTime? month;
  final double amount;

  IncomeMonthlyBreakdown toEntity() => IncomeMonthlyBreakdown(
        month: month,
        amount: amount,
      );
}

final class IncomeItemDto {
  const IncomeItemDto({
    required this.id,
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
    this.propertyId,
    this.propertyTitle,
  });

  factory IncomeItemDto.fromJson(Map<String, dynamic> json) {
    return IncomeItemDto(
      id: parseInt(json['id']) ?? 0,
      date: parseDateTime(json['date']),
      category: parseString(json['category']) ?? '',
      description: parseString(json['description']) ?? '',
      amount: parseDouble(json['amount']) ?? 0,
      propertyId: parseInt(json['property_id']),
      propertyTitle: json['property_title'] as String?,
    );
  }

  final int id;
  final DateTime? date;
  final String category;
  final String description;
  final double amount;
  final int? propertyId;
  final String? propertyTitle;

  IncomeItem toEntity() => IncomeItem(
        id: id,
        date: date,
        category: category,
        description: description,
        amount: amount,
        propertyId: propertyId,
        propertyTitle: propertyTitle,
      );
}

final class IncomeReportDto {
  const IncomeReportDto({
    required this.generatedAt,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.byCategory,
    required this.byMonth,
    required this.items,
  });

  factory IncomeReportDto.fromJson(Map<String, dynamic> json) {
    return IncomeReportDto(
      generatedAt: parseDateTime(json['generated_at']),
      startDate: parseDateTime(json['start_date']),
      endDate: parseDateTime(json['end_date']),
      totalIncome: parseDouble(json['total_income']) ?? 0,
      byCategory: parseList(json['by_category'])
          .whereType<Map<String, dynamic>>()
          .map(IncomeCategoryBreakdownDto.fromJson)
          .toList(),
      byMonth: parseList(json['by_month'])
          .whereType<Map<String, dynamic>>()
          .map(IncomeMonthlyBreakdownDto.fromJson)
          .toList(),
      items: parseList(json['items'])
          .whereType<Map<String, dynamic>>()
          .map(IncomeItemDto.fromJson)
          .toList(),
    );
  }

  final DateTime? generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalIncome;
  final List<IncomeCategoryBreakdownDto> byCategory;
  final List<IncomeMonthlyBreakdownDto> byMonth;
  final List<IncomeItemDto> items;

  IncomeReport toEntity() => IncomeReport(
        generatedAt: generatedAt,
        startDate: startDate,
        endDate: endDate,
        totalIncome: totalIncome,
        byCategory: byCategory.map((e) => e.toEntity()).toList(),
        byMonth: byMonth.map((e) => e.toEntity()).toList(),
        items: items.map((e) => e.toEntity()).toList(),
      );
}

// Expenses Report DTOs
final class ExpenseCategoryBreakdownDto {
  const ExpenseCategoryBreakdownDto({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  factory ExpenseCategoryBreakdownDto.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryBreakdownDto(
      category: parseString(json['category']) ?? '',
      amount: parseDouble(json['amount']) ?? 0,
      percentage: parseDouble(json['percentage']) ?? 0,
    );
  }

  final String category;
  final double amount;
  final double percentage;

  ExpenseCategoryBreakdown toEntity() => ExpenseCategoryBreakdown(
        category: category,
        amount: amount,
        percentage: percentage,
      );
}

final class ExpenseMonthlyBreakdownDto {
  const ExpenseMonthlyBreakdownDto({
    required this.month,
    required this.amount,
  });

  factory ExpenseMonthlyBreakdownDto.fromJson(Map<String, dynamic> json) {
    return ExpenseMonthlyBreakdownDto(
      month: parseDateTime(json['month']),
      amount: parseDouble(json['amount']) ?? 0,
    );
  }

  final DateTime? month;
  final double amount;

  ExpenseMonthlyBreakdown toEntity() => ExpenseMonthlyBreakdown(
        month: month,
        amount: amount,
      );
}

final class ExpenseItemDto {
  const ExpenseItemDto({
    required this.id,
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
    this.vendor,
    this.propertyId,
    this.propertyTitle,
  });

  factory ExpenseItemDto.fromJson(Map<String, dynamic> json) {
    return ExpenseItemDto(
      id: parseInt(json['id']) ?? 0,
      date: parseDateTime(json['date']),
      category: parseString(json['category']) ?? '',
      description: parseString(json['description']) ?? '',
      amount: parseDouble(json['amount']) ?? 0,
      vendor: json['vendor'] as String?,
      propertyId: parseInt(json['property_id']),
      propertyTitle: json['property_title'] as String?,
    );
  }

  final int id;
  final DateTime? date;
  final String category;
  final String description;
  final double amount;
  final String? vendor;
  final int? propertyId;
  final String? propertyTitle;

  ExpenseItem toEntity() => ExpenseItem(
        id: id,
        date: date,
        category: category,
        description: description,
        amount: amount,
        vendor: vendor,
        propertyId: propertyId,
        propertyTitle: propertyTitle,
      );
}

final class ExpensesReportDto {
  const ExpensesReportDto({
    required this.generatedAt,
    required this.startDate,
    required this.endDate,
    required this.totalExpenses,
    required this.byCategory,
    required this.byMonth,
    required this.items,
  });

  factory ExpensesReportDto.fromJson(Map<String, dynamic> json) {
    return ExpensesReportDto(
      generatedAt: parseDateTime(json['generated_at']),
      startDate: parseDateTime(json['start_date']),
      endDate: parseDateTime(json['end_date']),
      totalExpenses: parseDouble(json['total_expenses']) ?? 0,
      byCategory: parseList(json['by_category'])
          .whereType<Map<String, dynamic>>()
          .map(ExpenseCategoryBreakdownDto.fromJson)
          .toList(),
      byMonth: parseList(json['by_month'])
          .whereType<Map<String, dynamic>>()
          .map(ExpenseMonthlyBreakdownDto.fromJson)
          .toList(),
      items: parseList(json['items'])
          .whereType<Map<String, dynamic>>()
          .map(ExpenseItemDto.fromJson)
          .toList(),
    );
  }

  final DateTime? generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalExpenses;
  final List<ExpenseCategoryBreakdownDto> byCategory;
  final List<ExpenseMonthlyBreakdownDto> byMonth;
  final List<ExpenseItemDto> items;

  ExpensesReport toEntity() => ExpensesReport(
        generatedAt: generatedAt,
        startDate: startDate,
        endDate: endDate,
        totalExpenses: totalExpenses,
        byCategory: byCategory.map((e) => e.toEntity()).toList(),
        byMonth: byMonth.map((e) => e.toEntity()).toList(),
        items: items.map((e) => e.toEntity()).toList(),
      );
}

// Profit & Loss Report DTOs
final class PnLMonthlyBreakdownDto {
  const PnLMonthlyBreakdownDto({
    required this.month,
    required this.income,
    required this.expenses,
    required this.netIncome,
  });

  factory PnLMonthlyBreakdownDto.fromJson(Map<String, dynamic> json) {
    return PnLMonthlyBreakdownDto(
      month: parseDateTime(json['month']),
      income: parseDouble(json['income']) ?? 0,
      expenses: parseDouble(json['expenses']) ?? 0,
      netIncome: parseDouble(json['net_income']) ?? 0,
    );
  }

  final DateTime? month;
  final double income;
  final double expenses;
  final double netIncome;

  PnLMonthlyBreakdown toEntity() => PnLMonthlyBreakdown(
        month: month,
        income: income,
        expenses: expenses,
        netIncome: netIncome,
      );
}

final class ProfitAndLossReportDto {
  const ProfitAndLossReportDto({
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

  factory ProfitAndLossReportDto.fromJson(Map<String, dynamic> json) {
    return ProfitAndLossReportDto(
      generatedAt: parseDateTime(json['generated_at']),
      startDate: parseDateTime(json['start_date']),
      endDate: parseDateTime(json['end_date']),
      totalIncome: parseDouble(json['total_income']) ?? 0,
      totalExpenses: parseDouble(json['total_expenses']) ?? 0,
      netIncome: parseDouble(json['net_income']) ?? 0,
      profitMargin: parseDouble(json['profit_margin']) ?? 0,
      incomeBreakdown: parseList(json['income_breakdown'])
          .whereType<Map<String, dynamic>>()
          .map(IncomeCategoryBreakdownDto.fromJson)
          .toList(),
      expenseBreakdown: parseList(json['expense_breakdown'])
          .whereType<Map<String, dynamic>>()
          .map(ExpenseCategoryBreakdownDto.fromJson)
          .toList(),
      byMonth: parseList(json['by_month'])
          .whereType<Map<String, dynamic>>()
          .map(PnLMonthlyBreakdownDto.fromJson)
          .toList(),
    );
  }

  final DateTime? generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalIncome;
  final double totalExpenses;
  final double netIncome;
  final double profitMargin;
  final List<IncomeCategoryBreakdownDto> incomeBreakdown;
  final List<ExpenseCategoryBreakdownDto> expenseBreakdown;
  final List<PnLMonthlyBreakdownDto> byMonth;

  ProfitAndLossReport toEntity() => ProfitAndLossReport(
        generatedAt: generatedAt,
        startDate: startDate,
        endDate: endDate,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netIncome: netIncome,
        profitMargin: profitMargin,
        incomeBreakdown: incomeBreakdown.map((e) => e.toEntity()).toList(),
        expenseBreakdown: expenseBreakdown.map((e) => e.toEntity()).toList(),
        byMonth: byMonth.map((e) => e.toEntity()).toList(),
      );
}

// Occupancy Report DTOs
final class OccupancyByTypeDto {
  const OccupancyByTypeDto({
    required this.propertyType,
    required this.total,
    required this.occupied,
    required this.vacant,
    required this.occupancyRate,
  });

  factory OccupancyByTypeDto.fromJson(Map<String, dynamic> json) {
    return OccupancyByTypeDto(
      propertyType: parseString(json['property_type']) ?? '',
      total: parseInt(json['total']) ?? 0,
      occupied: parseInt(json['occupied']) ?? 0,
      vacant: parseInt(json['vacant']) ?? 0,
      occupancyRate: parseDouble(json['occupancy_rate']) ?? 0,
    );
  }

  final String propertyType;
  final int total;
  final int occupied;
  final int vacant;
  final double occupancyRate;

  OccupancyByType toEntity() => OccupancyByType(
        propertyType: propertyType,
        total: total,
        occupied: occupied,
        vacant: vacant,
        occupancyRate: occupancyRate,
      );
}

final class OccupancyItemDto {
  const OccupancyItemDto({
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyType,
    required this.isOccupied,
    this.tenantName,
    this.leaseEndDate,
    this.vacantSince,
    this.daysVacant,
  });

  factory OccupancyItemDto.fromJson(Map<String, dynamic> json) {
    return OccupancyItemDto(
      propertyId: parseInt(json['property_id']) ?? 0,
      propertyTitle: parseString(json['property_title']) ?? '',
      propertyType: parseString(json['property_type']) ?? '',
      isOccupied: json['is_occupied'] as bool? ?? false,
      tenantName: json['tenant_name'] as String?,
      leaseEndDate: parseDateTime(json['lease_end_date']),
      vacantSince: parseDateTime(json['vacant_since']),
      daysVacant: parseInt(json['days_vacant']),
    );
  }

  final int propertyId;
  final String propertyTitle;
  final String propertyType;
  final bool isOccupied;
  final String? tenantName;
  final DateTime? leaseEndDate;
  final DateTime? vacantSince;
  final int? daysVacant;

  OccupancyItem toEntity() => OccupancyItem(
        propertyId: propertyId,
        propertyTitle: propertyTitle,
        propertyType: propertyType,
        isOccupied: isOccupied,
        tenantName: tenantName,
        leaseEndDate: leaseEndDate,
        vacantSince: vacantSince,
        daysVacant: daysVacant,
      );
}

final class OccupancyReportDto {
  const OccupancyReportDto({
    required this.generatedAt,
    required this.totalProperties,
    required this.occupiedProperties,
    required this.vacantProperties,
    required this.occupancyRate,
    required this.averageVacancyDays,
    required this.byPropertyType,
    required this.items,
  });

  factory OccupancyReportDto.fromJson(Map<String, dynamic> json) {
    return OccupancyReportDto(
      generatedAt: parseDateTime(json['generated_at']),
      totalProperties: parseInt(json['total_properties']) ?? 0,
      occupiedProperties: parseInt(json['occupied_properties']) ?? 0,
      vacantProperties: parseInt(json['vacant_properties']) ?? 0,
      occupancyRate: parseDouble(json['occupancy_rate']) ?? 0,
      averageVacancyDays: parseInt(json['average_vacancy_days']) ?? 0,
      byPropertyType: parseList(json['by_property_type'])
          .whereType<Map<String, dynamic>>()
          .map(OccupancyByTypeDto.fromJson)
          .toList(),
      items: parseList(json['items'])
          .whereType<Map<String, dynamic>>()
          .map(OccupancyItemDto.fromJson)
          .toList(),
    );
  }

  final DateTime? generatedAt;
  final int totalProperties;
  final int occupiedProperties;
  final int vacantProperties;
  final double occupancyRate;
  final int averageVacancyDays;
  final List<OccupancyByTypeDto> byPropertyType;
  final List<OccupancyItemDto> items;

  OccupancyReport toEntity() => OccupancyReport(
        generatedAt: generatedAt,
        totalProperties: totalProperties,
        occupiedProperties: occupiedProperties,
        vacantProperties: vacantProperties,
        occupancyRate: occupancyRate,
        averageVacancyDays: averageVacancyDays,
        byPropertyType: byPropertyType.map((e) => e.toEntity()).toList(),
        items: items.map((e) => e.toEntity()).toList(),
      );
}

// Maintenance Report DTOs
final class MaintenanceByPriorityDto {
  const MaintenanceByPriorityDto({
    required this.priority,
    required this.count,
    required this.percentage,
  });

  factory MaintenanceByPriorityDto.fromJson(Map<String, dynamic> json) {
    return MaintenanceByPriorityDto(
      priority: parseString(json['priority']) ?? '',
      count: parseInt(json['count']) ?? 0,
      percentage: parseDouble(json['percentage']) ?? 0,
    );
  }

  final String priority;
  final int count;
  final double percentage;

  MaintenanceByPriority toEntity() => MaintenanceByPriority(
        priority: priority,
        count: count,
        percentage: percentage,
      );
}

final class MaintenanceByCategoryDto {
  const MaintenanceByCategoryDto({
    required this.category,
    required this.count,
    required this.totalCost,
  });

  factory MaintenanceByCategoryDto.fromJson(Map<String, dynamic> json) {
    return MaintenanceByCategoryDto(
      category: parseString(json['category']) ?? '',
      count: parseInt(json['count']) ?? 0,
      totalCost: parseDouble(json['total_cost']) ?? 0,
    );
  }

  final String category;
  final int count;
  final double totalCost;

  MaintenanceByCategory toEntity() => MaintenanceByCategory(
        category: category,
        count: count,
        totalCost: totalCost,
      );
}

final class MaintenanceReportItemDto {
  const MaintenanceReportItemDto({
    required this.id,
    required this.title,
    required this.propertyId,
    required this.propertyTitle,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.cost,
    this.daysToComplete,
  });

  factory MaintenanceReportItemDto.fromJson(Map<String, dynamic> json) {
    return MaintenanceReportItemDto(
      id: parseInt(json['id']) ?? 0,
      title: parseString(json['title']) ?? '',
      propertyId: parseInt(json['property_id']) ?? 0,
      propertyTitle: parseString(json['property_title']) ?? '',
      priority: parseString(json['priority']) ?? '',
      status: parseString(json['status']) ?? '',
      createdAt: parseDateTime(json['created_at']),
      completedAt: parseDateTime(json['completed_at']),
      cost: parseDouble(json['cost']),
      daysToComplete: parseInt(json['days_to_complete']),
    );
  }

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

  MaintenanceReportItem toEntity() => MaintenanceReportItem(
        id: id,
        title: title,
        propertyId: propertyId,
        propertyTitle: propertyTitle,
        priority: priority,
        status: status,
        createdAt: createdAt,
        completedAt: completedAt,
        cost: cost,
        daysToComplete: daysToComplete,
      );
}

final class MaintenanceReportDto {
  const MaintenanceReportDto({
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

  factory MaintenanceReportDto.fromJson(Map<String, dynamic> json) {
    return MaintenanceReportDto(
      generatedAt: parseDateTime(json['generated_at']),
      totalRequests: parseInt(json['total_requests']) ?? 0,
      openRequests: parseInt(json['open_requests']) ?? 0,
      completedRequests: parseInt(json['completed_requests']) ?? 0,
      totalCost: parseDouble(json['total_cost']) ?? 0,
      averageCompletionDays: parseDouble(json['average_completion_days']) ?? 0,
      byPriority: parseList(json['by_priority'])
          .whereType<Map<String, dynamic>>()
          .map(MaintenanceByPriorityDto.fromJson)
          .toList(),
      byCategory: parseList(json['by_category'])
          .whereType<Map<String, dynamic>>()
          .map(MaintenanceByCategoryDto.fromJson)
          .toList(),
      items: parseList(json['items'])
          .whereType<Map<String, dynamic>>()
          .map(MaintenanceReportItemDto.fromJson)
          .toList(),
    );
  }

  final DateTime? generatedAt;
  final int totalRequests;
  final int openRequests;
  final int completedRequests;
  final double totalCost;
  final double averageCompletionDays;
  final List<MaintenanceByPriorityDto> byPriority;
  final List<MaintenanceByCategoryDto> byCategory;
  final List<MaintenanceReportItemDto> items;

  MaintenanceReport toEntity() => MaintenanceReport(
        generatedAt: generatedAt,
        totalRequests: totalRequests,
        openRequests: openRequests,
        completedRequests: completedRequests,
        totalCost: totalCost,
        averageCompletionDays: averageCompletionDays,
        byPriority: byPriority.map((e) => e.toEntity()).toList(),
        byCategory: byCategory.map((e) => e.toEntity()).toList(),
        items: items.map((e) => e.toEntity()).toList(),
      );
}
