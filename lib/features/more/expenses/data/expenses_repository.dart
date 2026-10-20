import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';

/// Body of `POST /pm/expenses` (`ExpenseCreate`) and `PATCH /pm/expenses/{id}`
/// (`ExpenseUpdate`). `property_id` and `category` are required on create.
/// `category` is one of the `ExpenseCategory` wire values.
class ExpensePayload {
  const ExpensePayload({
    required this.propertyId,
    required this.category,
    required this.amount,
    required this.date,
    this.title,
    this.notes,
  });

  final int propertyId;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
  final String? title;
  final String? notes;

  static String? _text(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'property_id': propertyId,
      'category': category.wire,
      'amount': amount,
      'expense_date': toApiDateOnly(date),
      if (_text(title) != null) 'title': _text(title),
      if (_text(notes) != null) 'notes': _text(notes),
    };
  }

  /// A cleared title or note is sent as an explicit null, which clears it.
  Map<String, dynamic> toUpdateJson() {
    return {
      'property_id': propertyId,
      'category': category.wire,
      'amount': amount,
      'expense_date': toApiDateOnly(date),
      'title': _text(title),
      'notes': _text(notes),
    };
  }
}

class ExpensesRepository {
  ExpensesRepository(this._client);

  final ApiClient _client;

  Future<Page<Expense>> listPage({
    required String? cursor,
    required int limit,
    int? propertyId,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.expenses,
      ownerScoped: true,
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        if (propertyId != null) 'property_id': propertyId,
      },
    );
    final raw = unwrapPage(response.data);
    return Page<Expense>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(Expense.fromJson)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
  }

  /// Every expense that matches (follows `next_cursor`).
  Future<List<Expense>> listAll({int? propertyId}) {
    return fetchAllPages<Expense>(
      ({required cursor, required limit}) =>
          listPage(cursor: cursor, limit: limit, propertyId: propertyId),
    );
  }

  Future<Expense> create(ExpensePayload payload) async {
    final response = await _client.post<dynamic>(
      ApiPaths.expenses,
      data: payload.toCreateJson(),
      ownerScoped: true,
    );
    return Expense.fromJson(unwrapMap(response.data));
  }

  Future<Expense> update(int id, ExpensePayload payload) async {
    final response = await _client.patch<dynamic>(
      ApiPaths.expense(id),
      data: payload.toUpdateJson(),
    );
    return Expense.fromJson(unwrapMap(response.data));
  }
}
