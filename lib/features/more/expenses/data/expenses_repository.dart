import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';

class ExpensePayload {
  const ExpensePayload({
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    this.notes,
    this.propertyId,
  });

  final String title;
  final double amount;
  final DateTime date;
  final String? category;
  final String? notes;
  final String? propertyId;

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'title': title,
      'amount': amount,
      'expense_date': date.toIso8601String(),
    };
    if (category != null && category!.trim().isNotEmpty) {
      payload['category'] = category!.trim();
    }
    if (notes != null && notes!.trim().isNotEmpty) {
      payload['notes'] = notes!.trim();
    }
    if (propertyId != null && propertyId!.trim().isNotEmpty) {
      payload['property_id'] = propertyId!.trim();
    }
    return payload;
  }
}

class ExpensesRepository {
  ExpensesRepository(this._client);

  final ApiClient _client;

  Future<List<Expense>> list() async {
    final response = await _client.get('/pm/expenses/');
    final data = unwrapList(response.data);
    return data.whereType<Map<String, dynamic>>().map(Expense.fromJson).toList();
  }

  Future<Expense> create(ExpensePayload payload) async {
    final response = await _client.post(
      '/pm/expenses/',
      data: payload.toJson(),
    );
    final data = unwrapMap(response.data);
    return Expense.fromJson(data);
  }

  Future<Expense> update(String id, ExpensePayload payload) async {
    final response = await _client.patch(
      '/pm/expenses/$id',
      data: payload.toJson(),
    );
    final data = unwrapMap(response.data);
    return Expense.fromJson(data);
  }
}
