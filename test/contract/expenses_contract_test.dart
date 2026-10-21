import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/more/expenses/data/expenses_repository.dart';
import 'package:estate_app/features/more/expenses/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contract_helpers.dart';

void main() {
  group('Expense (GET /pm/expenses)', () {
    final page = unwrapPage(loadPage('expenses', 'list_page'));
    final expenses = page.items
        .cast<Map<String, dynamic>>()
        .map(Expense.fromJson)
        .toList();

    test('reads title, property_name, category and expense_date', () {
      final first = expenses.first;
      expect(first.id, 81);
      expect(first.title, 'Q2 property tax');
      expect(first.propertyName, '2 BHK Sector 51');
      expect(first.category, ExpenseCategory.propertyTax);
      expect(first.category!.label, 'Property tax');
      expect(first.amount, 14250.75);
      expect(first.date, DateTime.utc(2026, 9, 30));
    });

    test('a null title stays null', () {
      expect(expenses[1].title, isNull);
      expect(expenses[1].category, ExpenseCategory.repairs);
    });

    test('the page follows next_cursor', () {
      expect(page.nextCursor, isNotNull);
      expect(page.hasMore, isTrue);
    });
  });

  group('expense request bodies', () {
    final payload = ExpensePayload(
      propertyId: 4,
      category: ExpenseCategory.propertyTax,
      amount: 1200.5,
      date: DateTime(2026, 10),
      title: ' Tax ',
      notes: '',
    );

    test('create sends property_id, enum category and title', () {
      final body = payload.toCreateJson();
      expectValidBody('ExpenseCreate', body);
      expect(body['property_id'], 4);
      expect(body['category'], 'property_tax');
      expect(body['title'], 'Tax');
      expect(body['expense_date'], '2026-10-01');
      expect(body.containsKey('notes'), isFalse);
    });

    test('update clears a blank note with an explicit null', () {
      final body = payload.toUpdateJson();
      expectValidBody('ExpenseUpdate', body);
      expect(body['notes'], isNull);
      expect(body.containsKey('notes'), isTrue);
    });
  });
}
