import 'package:estate_app/core/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rupees groups the Indian way and keeps paise only when present', () {
    expect(rupees(284500), '₹2,84,500');
    expect(rupees(32000.0), '₹32,000');
    expect(rupees(19999.5), '₹19,999.50');
    expect(rupees(-1200), '-₹1,200');
  });
}
