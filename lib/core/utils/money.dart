import 'package:intl/intl.dart';

/// Rupees in Indian grouping: 284500 -> ₹2,84,500. Paise show only when
/// there are some (19999.5 -> ₹19,999.50), so a ledger never rounds money.
String rupees(num value) => (value * 100).round() % 100 == 0
    ? _whole.format(value)
    : _paise.format(value);

final _whole = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

final _paise = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
