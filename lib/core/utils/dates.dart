import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String _locale(BuildContext context) =>
    Localizations.localeOf(context).toString();

/// 1 Oct 2026, in the app language. The spaces do not break, so a date
/// never wraps across two lines.
String shortDate(BuildContext context, DateTime date) =>
    DateFormat('d\u00A0MMM\u00A0y', _locale(context)).format(date.toLocal());

/// 1 Oct 2026 for a date-only value (`YYYY-MM-DD`, read as midnight UTC).
/// It is not converted to local time: west of UTC that would show the day
/// before.
String dateOnly(BuildContext context, DateTime date) =>
    DateFormat('d\u00A0MMM\u00A0y', _locale(context)).format(date);

/// 1 Oct 2026, 3:45 PM, in the app language.
String dateTime(BuildContext context, DateTime date) => DateFormat(
  'd\u00A0MMM\u00A0y, h:mm\u00A0a',
  _locale(context),
).format(date.toLocal());
