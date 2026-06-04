final RegExp _offsetOrZuluSuffix = RegExp(r'([zZ]|[+-]\d{2}:\d{2})$');
final RegExp _dateOnlyPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

DateTime? parseDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (_dateOnlyPattern.hasMatch(trimmed)) {
      final parts = trimmed.split('-');
      return DateTime.utc(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }
    final normalized =
        trimmed.contains('T') && !_offsetOrZuluSuffix.hasMatch(trimmed)
        ? '${trimmed}Z'
        : trimmed;
    final parsed = DateTime.tryParse(normalized);
    if (parsed != null) return parsed;
    final numeric = int.tryParse(trimmed);
    if (numeric != null) {
      final isMillis = trimmed.length > 10;
      return DateTime.fromMillisecondsSinceEpoch(
        isMillis ? numeric : numeric * 1000,
        isUtc: true,
      );
    }
  }
  return null;
}

String? toApiUtcInstant(DateTime? value) {
  if (value == null) return null;
  return value.toUtc().toIso8601String();
}

String? toApiDateOnly(DateTime? value) {
  if (value == null) return null;
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

double? parseDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final sanitized = trimmed.replaceAll(RegExp(r'[^0-9.\-]'), '');
    if (sanitized.isEmpty || sanitized == '-' || sanitized == '.') {
      return null;
    }
    return double.tryParse(sanitized);
  }
  return null;
}

int? parseInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String? parseString(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

/// Returns [value] as a list when it is one, otherwise an empty list.
/// Use for JSON array fields that the backend may omit or send as null/scalar.
List<dynamic> parseList(Object? value) {
  if (value is List) return value;
  return const [];
}

List<String>? parseStringList(Object? value) {
  if (value == null) return null;
  if (value is List) {
    return value
        .map((item) => item?.toString())
        .where((item) => item != null && item.trim().isNotEmpty)
        .cast<String>()
        .toList();
  }
  if (value is String) return [value];
  return null;
}
