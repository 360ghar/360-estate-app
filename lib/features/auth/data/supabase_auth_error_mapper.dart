import 'package:estate_app/core/errors/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Product-facing copy for Supabase [AuthException]s.
///
/// Mirrors the web mapper (`mapSupabaseAuthError`) so estate, web, and viewer
/// show the same messages for invalid credentials, unverified accounts, rate
/// limits, OTP failures, and network errors.
enum AuthErrorContext {
  login,
  otp,
  forgotPassword,
}

const String kAuthErrorFallback = 'Something went wrong. Please try again.';

bool _isUnverifiedMessage(String message) {
  return message.contains('email not confirmed') ||
      message.contains('phone not confirmed') ||
      message.contains('user not confirmed') ||
      message.contains('email address not confirmed');
}

/// Maps a Supabase [AuthException] (or any object with a similar shape) to a
/// user-safe message. Prefer [failureFromAuthException] when throwing into the
/// app's [Failure] hierarchy.
String mapSupabaseAuthError(
  Object? error, {
  AuthErrorContext context = AuthErrorContext.login,
}) {
  if (error == null) return kAuthErrorFallback;

  String code = '';
  String message = '';
  int? status;

  if (error is AuthException) {
    code = (error.code ?? '').toLowerCase();
    message = error.message.toLowerCase();
    status = int.tryParse(error.statusCode ?? '');
  } else {
    // Best-effort for wrapped / dynamic errors.
    try {
      final dynamic e = error;
      code = ((e.code as String?) ?? '').toLowerCase();
      message = ((e.message as String?) ?? error.toString()).toLowerCase();
      final rawStatus = e.statusCode ?? e.status;
      if (rawStatus is int) {
        status = rawStatus;
      } else if (rawStatus is String) {
        status = int.tryParse(rawStatus);
      }
    } catch (_) {
      message = error.toString().toLowerCase();
    }
  }

  switch (code) {
    case 'invalid_credentials':
    case 'invalid_grant':
      return context == AuthErrorContext.otp
          ? 'Invalid code. Check and try again.'
          : 'Invalid email/phone or password.';
    case 'user_not_found':
      return 'No account found for this email/phone.';
    case 'email_exists':
    case 'user_already_exists':
      return 'An account with this email already exists.';
    case 'phone_exists':
      return 'An account with this phone number already exists.';
    case 'email_not_confirmed':
      return 'Please verify your email before signing in. We can send you a new code.';
    case 'phone_not_confirmed':
      return 'Please verify your phone number before signing in. We can send you a new code.';
    case 'over_email_send_rate_limit':
    case 'over_request_rate_limit':
    case 'over_sms_send_rate_limit':
    case 'too_many_requests':
      return 'Too many requests. Please wait a few minutes and try again.';
    case 'sms_send_failed':
      return "We couldn't send an SMS. Please try again or use email.";
    case 'otp_expired':
      return 'The verification code has expired. Request a new one.';
    case 'otp_disabled':
      return 'The verification code is invalid. Check and try again.';
    case 'weak_password':
      return 'Password is too weak. Try a longer password.';
    case 'validation_failed':
      return 'Validation failed. Please check your input.';
    case 'bad_jwt':
    case 'invalid_jwt':
      return 'Your session has expired. Please sign in again.';
    case 'email_address_not_authorized':
      return 'This email is not authorized. Please contact support.';
  }

  // Message heuristics BEFORE bare status codes. GoTrue often returns
  // status 400 + "Invalid login credentials" with no error `code`; checking
  // status first would map that to the useless "Invalid request…" string.
  if (_isUnverifiedMessage(message)) {
    return 'Please verify your account before signing in. We can send you a new code.';
  }
  if (message.contains('invalid login') ||
      message.contains('invalid credentials')) {
    return context == AuthErrorContext.otp
        ? 'Invalid code. Check and try again.'
        : 'Invalid email/phone or password.';
  }
  if (message.contains('expired') &&
      (message.contains('otp') || message.contains('token'))) {
    return 'The verification code has expired. Request a new one.';
  }
  if (message.contains('rate limit') || message.contains('too many')) {
    return 'Too many requests. Please wait a few minutes and try again.';
  }
  if (message.contains('password is incorrect') ||
      message.contains('wrong password')) {
    return 'Incorrect password. Please try again.';
  }

  if (status == 400) return 'Invalid request. Please check your input.';
  if (status == 401) {
    return context == AuthErrorContext.otp
        ? 'Invalid code. Check and try again.'
        : 'Invalid email/phone or password.';
  }
  if (status == 403) return 'Action not allowed.';
  if (status == 404) return 'Requested resource was not found.';
  if (status == 429) {
    return 'Too many requests. Please wait a few minutes and try again.';
  }
  if (status != null && status >= 500) {
    return 'Server error. Please try again later.';
  }
  if (message.contains('network') ||
      message.contains('socket') ||
      message.contains('failed host lookup') ||
      message.contains('connection')) {
    return 'Network error. Check your connection and try again.';
  }

  if (error is AuthException) {
    final trimmed = error.message.trim();
    if (trimmed.isNotEmpty) return trimmed;
  }

  return kAuthErrorFallback;
}

/// Converts a Supabase [AuthException] into a [ValidationFailure] with mapped
/// product copy. Prefer this over throwing the raw exception message.
ValidationFailure failureFromAuthException(
  AuthException e, {
  AuthErrorContext context = AuthErrorContext.login,
}) {
  return ValidationFailure(
    mapSupabaseAuthError(e, context: context),
    cause: e,
  );
}
