String normalizePhone(String raw, {String defaultCountryCode = '+91'}) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';

  final hasPlus = trimmed.startsWith('+');
  final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return '';

  if (hasPlus) {
    return '+$digits';
  }

  if (digits.length == 10) {
    return '$defaultCountryCode$digits';
  }

  if (digits.length == 11 && digits.startsWith('0')) {
    return '$defaultCountryCode${digits.substring(1)}';
  }

  if (digits.length == 12 && digits.startsWith('91')) {
    return '+$digits';
  }

  return '+$digits';
}

bool isValidPhone(String raw) {
  final normalized = normalizePhone(raw);
  if (normalized.isEmpty) return false;
  final digits = normalized.replaceAll(RegExp(r'[^0-9]'), '');
  return digits.length >= 10;
}
