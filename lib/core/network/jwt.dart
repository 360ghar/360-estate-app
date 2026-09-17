import 'dart:convert';

/// Shared JWT helpers.
///
/// Single source of truth for decoding and inspecting Supabase JWTs so the
/// token provider and the auth interceptor cannot drift apart (they previously
/// carried two independent copies of `_decodeJwtPayload`).
abstract final class Jwt {
  /// Decodes the payload segment of a JWT without verifying the signature.
  ///
  /// Returns `null` when the token is malformed or the payload is not a JSON
  /// object. The signature is intentionally NOT verified here: callers only
  /// use the claims for expiry/issuer introspection; Supabase owns validation.
  static Map<String, dynamic>? decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length < 2) return null;
    try {
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final data = jsonDecode(decoded);
      if (data is Map<String, dynamic>) return data;
      if (data is Map) {
        return data.map((key, value) => MapEntry(key.toString(), value));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// The `exp` claim as an epoch-seconds value, or `null` when absent or
  /// malformed (both numeric and string encodings are tolerated).
  static int? expSeconds(String token) {
    final payload = decodePayload(token);
    if (payload == null) return null;
    final exp = payload['exp'];
    if (exp is num) return exp.toInt();
    if (exp is String) return int.tryParse(exp);
    return null;
  }

  /// True when the token's `exp` claim is within [skew] of now (or already
  /// past). A token without a readable `exp` is treated as not expired so an
  /// opaque-but-valid token never forces a premature refresh.
  static bool isExpired(
    String token, {
    Duration skew = const Duration(seconds: 10),
  }) {
    final expValue = expSeconds(token);
    if (expValue == null) return false;
    final expiry = DateTime.fromMillisecondsSinceEpoch(expValue * 1000);
    return DateTime.now().add(skew).isAfter(expiry);
  }

  /// Formats the `exp` claim as a UTC ISO-8601 string, or `null`.
  ///
  /// Takes an already-decoded payload so per-request callers (e.g. the auth
  /// interceptor) decode the JWT once instead of twice.
  static String? formatExpFromPayload(Map<String, dynamic> payload) {
    final exp = payload['exp'];
    final expValue = exp is num
        ? exp.toInt()
        : exp is String
        ? int.tryParse(exp)
        : null;
    if (expValue == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(
      expValue * 1000,
    ).toUtc().toIso8601String();
  }

  /// Formats the `exp` claim as a UTC ISO-8601 string, or `null`.
  static String? formatExp(String token) {
    final expValue = expSeconds(token);
    if (expValue == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(
      expValue * 1000,
    ).toUtc().toIso8601String();
  }
}
