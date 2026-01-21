DateTime? parseDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: false);
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) return parsed;
    final numeric = int.tryParse(trimmed);
    if (numeric != null) {
      final isMillis = trimmed.length > 10;
      return DateTime.fromMillisecondsSinceEpoch(
        isMillis ? numeric : numeric * 1000,
        isUtc: false,
      );
    }
  }
  return null;
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
