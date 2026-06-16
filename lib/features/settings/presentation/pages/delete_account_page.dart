import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_gradients.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  static const String _expectedWord = 'DELETE';
  static const String _supportEmail = 'info@360ghar.com';
  static const String _emailSubject = 'Account Deletion Request';

  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _confirmFocus = FocusNode();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _confirmController
      ..removeListener(_onTextChanged)
      ..dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _isConfirmed =>
      _confirmController.text.trim() == _expectedWord;

  String _buildEmailBody() {
    final registeredEmail =
        ref.read(authControllerProvider).user?.email?.trim();
    final emailLine = (registeredEmail != null && registeredEmail.isNotEmpty)
        ? registeredEmail
        : 'Not available';
    return 'Hello 360 Ghar Support,\n\n'
        'I would like to request the deletion of my account.\n\n'
        'Registered email: $emailLine\n\n'
        'Thank you.';
  }

  Uri _buildMailtoUri() {
    return Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: <String, String>{
        'subject': _emailSubject,
        'body': _buildEmailBody(),
      },
    );
  }

  Future<void> _confirmDelete() async {
    if (!_isConfirmed || _isSubmitting) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    // Only the account-deletion API call should fall back to the email flow.
    // A failure in the post-deletion logout/navigation must NOT re-trigger the
    // email fallback, since the account has already been deleted server-side.
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.delete<void>('/users/me');
    } catch (e) {
      if (!mounted) return;
      await _fallbackEmailDeletion();
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n?.deleteAccountSuccess ??
              'Your account has been deleted successfully.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await ref.read(authControllerProvider.notifier).logout();
    if (!mounted) return;
    context.go('/enter-phone');
  }

  Future<void> _fallbackEmailDeletion() async {
    final uri = _buildMailtoUri();
    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }

    if (!mounted) return;

    if (launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n?.deleteAccountEmailSent ??
                'Email app opened. Please send the message to complete your request.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/more/profile/settings');
      }
    } else {
      final fallbackMessage = context.l10n?.deleteAccountManualFallback ??
          'Could not delete account or open your email app. Please email $_supportEmail with subject "$_emailSubject".';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(fallbackMessage),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
        ),
      );
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.deleteAccount ?? 'Delete Account'),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WarningCard(isDark: isDark),
          const SizedBox(height: AppSpacing.lg),
          AppSectionCard(
            title: context.l10n?.deleteAccount ?? 'Delete Account',
            icon: Icons.delete_outline,
            iconColor: AppColors.danger,
            children: [
              Text(
                context.l10n?.deleteAccountConfirmLabel(_expectedWord) ??
                    'Type $_expectedWord to confirm',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _confirmController,
                focusNode: _confirmFocus,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                enableSuggestions: false,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_expectedWord.length + 8),
                ],
                decoration: InputDecoration(
                  hintText:
                      context.l10n?.deleteAccountConfirmHint ?? _expectedWord,
                  prefixIcon: Icon(
                    Icons.edit_outlined,
                    color: _isConfirmed
                        ? AppColors.danger
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _isConfirmed
                      ? const Icon(Icons.check_circle, color: AppColors.danger)
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.md,
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : AppColors.cardBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.md,
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkCardBorder
                          : AppColors.cardBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.md,
                    borderSide: const BorderSide(
                      color: AppColors.danger,
                      width: 1.5,
                    ),
                  ),
                ),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppDurations.defaultCurve,
              decoration: BoxDecoration(
                borderRadius: AppRadii.md,
                boxShadow: _isConfirmed
                    ? [
                        BoxShadow(
                          color: AppColors.danger.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: FilledButton(
                onPressed: (_isConfirmed && !_isSubmitting)
                    ? _confirmDelete
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppColors.danger.withValues(alpha: 0.35),
                  disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.md,
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        context.l10n?.deleteAccount ?? 'Delete Account',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppGradients.dangerSubtle,
        color: isDark
            ? AppColors.danger.withValues(alpha: 0.08)
            : AppColors.danger.withValues(alpha: 0.04),
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: AppColors.danger.withValues(alpha: isDark ? 0.2 : 0.15),
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.danger,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n?.deleteAccount ?? 'Delete Account',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n?.deleteAccountWarning ??
                      'This action cannot be undone. All your data will be permanently deleted.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}