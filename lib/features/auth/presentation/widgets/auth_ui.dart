import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Navy/Indigo theme colors matching the app design
const Color authAccent = Color(0xFF3B82F6); // Blue accent
const Color authPrimary = Color(0xFF1E3A5F); // Navy primary
const Color authInk = Color(0xFF111827); // Dark text
const Color authMuted = Color(0xFF6B7280); // Secondary text
const Color authFieldBorder = Color(0xFFE5E7EB); // Light border
const Color authFieldFill = Color(0xFFF9FAFB); // Light fill
const Color authInactive = Color(0xFFD1D5DB); // Inactive

TextStyle? authTitleStyle(BuildContext context) {
  return Theme.of(context).textTheme.headlineLarge?.copyWith(
    color: authInk,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.2,
  );
}

TextStyle? authSubtitleStyle(BuildContext context) {
  return Theme.of(
    context,
  ).textTheme.bodyLarge?.copyWith(color: authMuted, fontSize: 15, height: 1.5);
}

TextStyle? authLabelStyle(BuildContext context) {
  return Theme.of(context).textTheme.labelSmall?.copyWith(
    color: authMuted,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );
}

TextStyle? authHintStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: authMuted.withValues(alpha: 0.6),
    fontSize: 16,
  );
}

TextStyle? authInputTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: authInk,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

TextStyle? authFootnoteStyle(BuildContext context) {
  return Theme.of(
    context,
  ).textTheme.bodySmall?.copyWith(color: authMuted, fontSize: 13);
}

TextStyle? authLinkStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodySmall?.copyWith(
    color: authAccent,
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );
}

ButtonStyle authPrimaryButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(vertical: 16),
  );
}

InputDecoration authInputDecoration(
  BuildContext context, {
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  EdgeInsetsGeometry? contentPadding,
}) {
  final errorColor = Theme.of(context).colorScheme.error;
  return InputDecoration(
    hintText: hintText,
    hintStyle: authHintStyle(context),
    filled: true,
    fillColor: authFieldFill,
    prefixIcon: prefixIcon,
    prefixIconConstraints: const BoxConstraints(),
    suffixIcon: suffixIcon,
    contentPadding:
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: authFieldBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: authFieldBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: authAccent, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: errorColor, width: 1.5),
    ),
  );
}

/// Responsive auth page layout - handles keyboard appearance gracefully
/// Content is always scrollable to prevent overflow when keyboard appears
class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: keyboardHeight > 0 ? keyboardHeight + 24 : 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom -
              48,
        ),
        child: child,
      ),
    );
  }
}

class AuthTopBar extends StatelessWidget {
  const AuthTopBar({
    super.key,
    this.onBack,
    this.stepIndex,
    this.totalSteps = 3,
  });

  final VoidCallback? onBack;
  final int? stepIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onBack != null)
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: authInk,
            splashRadius: 20,
          )
        else
          const SizedBox(width: 48),
        if (stepIndex != null)
          AuthStepIndicator(currentStep: stepIndex!, totalSteps: totalSteps)
        else
          const SizedBox(width: 48),
      ],
    );
  }
}

class AuthStepIndicator extends StatelessWidget {
  const AuthStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;
        final width = isCurrent ? 28.0 : 18.0;
        return Padding(
          padding: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
          child: Container(
            width: width,
            height: 5,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : authInactive,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

class AuthSectionLabel extends StatelessWidget {
  const AuthSectionLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: authLabelStyle(context));
  }
}

class AuthPillContainer extends StatelessWidget {
  const AuthPillContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: authFieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: authFieldBorder),
      ),
      child: child,
    );
  }
}

class AuthCountryPrefix extends StatelessWidget {
  const AuthCountryPrefix({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '+91',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: authInk,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 8),
        Container(width: 1, height: 18, color: authFieldBorder),
      ],
    );
  }
}

class AuthPhoneNumberFormatter extends TextInputFormatter {
  const AuthPhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
