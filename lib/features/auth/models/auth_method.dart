/// The canonical auth methods, mirroring the backend
/// `POST /api/v1/auth/last-method` contract.
enum AuthMethod {
  google('google'),
  apple('apple'),
  emailPassword('email_password'),
  phonePassword('phone_password'),
  phoneOtp('phone_otp'),
  emailOtp('email_otp');

  const AuthMethod(this.wireName);

  /// The value sent to / stored for the backend.
  final String wireName;

  /// Passwordless social methods that should never be forced through the
  /// mandatory set-password step.
  bool get isPasswordless =>
      this == AuthMethod.google || this == AuthMethod.apple;

  static AuthMethod? fromWireName(String? value) {
    if (value == null) return null;
    for (final method in AuthMethod.values) {
      if (method.wireName == value) return method;
    }
    return null;
  }
}

/// The channel an identifier resolves to.
enum IdentifierChannel { phone, email }

/// What the unified login flow should do next for a given identifier, based on
/// the backend `POST /api/v1/auth/identifier-status` response.
enum IdentifierNextStep {
  /// Existing, verified account that has a password set -> ask for password.
  password,

  /// Unknown / unverified / passwordless account -> send an OTP first.
  otp,
}

/// Result of resolving an identifier against the backend state machine.
class IdentifierStatus {
  const IdentifierStatus({
    required this.exists,
    required this.verified,
    required this.hasPassword,
    required this.channel,
    required this.nextStep,
  });

  final bool exists;
  final bool verified;
  final bool hasPassword;
  final IdentifierChannel channel;
  final IdentifierNextStep nextStep;

  /// Whether this identifier is a brand-new (unknown) account, which means the
  /// unified flow should treat the OTP verification as a sign-up.
  bool get isSignup => !exists;
}
