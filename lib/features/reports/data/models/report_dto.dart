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
      propertyId: json['property_id'] as int,
      propertyTitle: json['property_title'] as String,
      propertyAddress: json['property_address'] as String?,
      tenantName: json['tenant_name'] as String?,
      leaseId: json['lease_id'] as int?,
      monthlyRent: (json['monthly_rent'] as num).toDouble(),
      amountPaid: (json['amount_paid'] as num).toDouble(),
      amountDue: (json['amount_due'] as num).toDouble(),
      status: json['status'] as String,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
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
      generatedAt: DateTime.parse(json['generated_at'] as String),
      totalProperties: json['total_properties'] as int,
      totalMonthlyRent: (json['total_monthly_rent'] as num).toDouble(),
      totalCollected: (json['total_collected'] as num).toDouble(),
      totalOutstanding: (json['total_outstanding'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => RentRollItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final DateTime generatedAt;
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

  /// Returns an empty report for fallback when PM endpoints are unavailable
  factory RentRollReportDto.empty() => RentRollReportDto(
        generatedAt: DateTime.now(),
        totalProperties: 0,
        totalMonthlyRent: 0,
        totalCollected: 0,
        totalOutstanding: 0,
        items: [],
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
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
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
      month: DateTime.parse(json['month'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  final DateTime month;
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
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      propertyId: json['property_id'] as int?,
      propertyTitle: json['property_title'] as String?,
    );
  }

  final int id;
  final DateTime date;
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
      generatedAt: DateTime.parse(json['generated_at'] as String),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalIncome: (json['total_income'] as num).toDouble(),
      byCategory: (json['by_category'] as List<dynamic>)
          .map(
            (e) =>
                IncomeCategoryBreakdownDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      byMonth: (json['by_month'] as List<dynamic>)
          .map(
            (e) =>
                IncomeMonthlyBreakdownDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map((e) => IncomeItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final DateTime generatedAt;
  final DateTime startDate;
  final DateTime endDate;
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

  /// Returns an empty report for fallback when PM endpoints are unavailable
  factory IncomeReportDto.empty() => IncomeReportDto(
        generatedAt: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        totalIncome: 0,
        byCategory: [],
        byMonth: [],
        items: [],
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
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
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
      month: DateTime.parse(json['month'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  final DateTime month;
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
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      vendor: json['vendor'] as String?,
      propertyId: json['property_id'] as int?,
      propertyTitle: json['property_title'] as String?,
    );
  }

  final int id;
  final DateTime date;
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
      generatedAt: DateTime.parse(json['generated_at'] as String),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalExpenses: (json['total_expenses'] as num).toDouble(),
      byCategory: (json['by_category'] as List<dynamic>)
          .map(
            (e) =>
                ExpenseCategoryBreakdownDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      byMonth: (json['by_month'] as List<dynamic>)
          .map(
            (e) =>
                ExpenseMonthlyBreakdownDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ExpenseItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final DateTime generatedAt;
  final DateTime startDate;
  final DateTime endDate;
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

  /// Returns an empty report for fallback when PM endpoints are unavailable
  factory ExpensesReportDto.empty() => ExpensesReportDto(
        generatedAt: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        totalExpenses: 0,
        byCategory: [],
        byMonth: [],
        items: [],
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
      month: DateTime.parse(json['month'] as String),
      income: (json['income'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      netIncome: (json['net_income'] as num).toDouble(),
    );
  }

  final DateTime month;
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
      generatedAt: DateTime.parse(json['generated_at'] as String),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalIncome: (json['total_income'] as num).toDouble(),
      totalExpenses: (json['total_expenses'] as num).toDouble(),
      netIncome: (json['net_income'] as num).toDouble(),
      profitMargin: (json['profit_margin'] as num).toDouble(),
      incomeBreakdown: (json['income_breakdown'] as List<dynamic>)
          .map(
            (e) =>
                IncomeCategoryBreakdownDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      expenseBreakdown: (json['expense_breakdown'] as List<dynamic>)
          .map(
            (e) =>
                ExpenseCategoryBreakdownDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      byMonth: (json['by_month'] as List<dynamic>)
          .map(
              (e) => PnLMonthlyBreakdownDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final DateTime generatedAt;
  final DateTime startDate;
  final DateTime endDate;
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

  /// Returns an empty report for fallback when PM endpoints are unavailable
  factory ProfitAndLossReportDto.empty() => ProfitAndLossReportDto(
        generatedAt: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        totalIncome: 0,
        totalExpenses: 0,
        netIncome: 0,
        profitMargin: 0,
        incomeBreakdown: [],
        expenseBreakdown: [],
        byMonth: [],
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
      propertyType: json['property_type'] as String,
      total: json['total'] as int,
      occupied: json['occupied'] as int,
      vacant: json['vacant'] as int,
      occupancyRate: (json['occupancy_rate'] as num).toDouble(),
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
      propertyId: json['property_id'] as int,
      propertyTitle: json['property_title'] as String,
      propertyType: json['property_type'] as String,
      isOccupied: json['is_occupied'] as bool,
      tenantName: json['tenant_name'] as String?,
      leaseEndDate: json['lease_end_date'] != null
          ? DateTime.parse(json['lease_end_date'] as String)
          : null,
      vacantSince: json['vacant_since'] != null
          ? DateTime.parse(json['vacant_since'] as String)
          : null,
      daysVacant: json['days_vacant'] as int?,
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
      generatedAt: DateTime.parse(json['generated_at'] as String),
      totalProperties: json['total_properties'] as int,
      occupiedProperties: json['occupied_properties'] as int,
      vacantProperties: json['vacant_properties'] as int,
      occupancyRate: (json['occupancy_rate'] as num).toDouble(),
      averageVacancyDays: json['average_vacancy_days'] as int,
      byPropertyType: (json['by_property_type'] as List<dynamic>)
          .map((e) => OccupancyByTypeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map((e) => OccupancyItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final DateTime generatedAt;
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

  /// Returns an empty report for fallback when PM endpoints are unavailable
  factory OccupancyReportDto.empty() => OccupancyReportDto(
        generatedAt: DateTime.now(),
        totalProperties: 0,
        occupiedProperties: 0,
        vacantProperties: 0,
        occupancyRate: 0,
        averageVacancyDays: 0,
        byPropertyType: [],
        items: [],
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
      priority: json['priority'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
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
      category: json['category'] as String,
      count: json['count'] as int,
      totalCost: (json['total_cost'] as num).toDouble(),
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
      id: json['id'] as int,
      title: json['title'] as String,
      propertyId: json['property_id'] as int,
      propertyTitle: json['property_title'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : null,
      daysToComplete: json['days_to_complete'] as int?,
    );
  }

  final int id;
  final String title;
  final int propertyId;
  final String propertyTitle;
  final String priority;
  final String status;
  final DateTime createdAt;
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
      generatedAt: DateTime.parse(json['generated_at'] as String),
      totalRequests: json['total_requests'] as int,
      openRequests: json['open_requests'] as int,
      completedRequests: json['completed_requests'] as int,
      totalCost: (json['total_cost'] as num).toDouble(),
      averageCompletionDays:
          (json['average_completion_days'] as num).toDouble(),
      byPriority: (json['by_priority'] as List<dynamic>)
          .map(
            (e) => MaintenanceByPriorityDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      byCategory: (json['by_category'] as List<dynamic>)
          .map(
            (e) => MaintenanceByCategoryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => MaintenanceReportItemDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final DateTime generatedAt;
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

  /// Returns an empty report for fallback when PM endpoints are unavailable
  factory MaintenanceReportDto.empty() => MaintenanceReportDto(
        generatedAt: DateTime.now(),
        totalRequests: 0,
        openRequests: 0,
        completedRequests: 0,
        totalCost: 0,
        averageCompletionDays: 0,
        byPriority: [],
        byCategory: [],
        items: [],
      );
}
