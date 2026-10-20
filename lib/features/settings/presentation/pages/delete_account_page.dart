import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Returns true when a delete-account API failure should offer the mailto
/// fallback. A genuinely offline failure ([NetworkFailure] with `isOffline`)
/// stays on the page with a snackbar; anything else (online timeout,
/// 401/404/server/unknown) offers the email path.
bool shouldFallbackToEmailOnDelete(Object error) {
  if (error is NetworkFailure) return !error.isOffline;
  return true;
}

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

  bool get _isConfirmed => _confirmController.text.trim() == _expectedWord;

  String _buildEmailBody() {
    final registeredEmail = ref
        .read(authControllerProvider)
        .user
        ?.email
        ?.trim();
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
      await apiClient.delete<void>(ApiPaths.userMe);
    } on NetworkFailure catch (e) {
      if (!mounted) return;
      if (e.isOffline) {
        context.showSnack(context.l10n.errorOfflineHint);
        setState(() => _isSubmitting = false);
        return;
      }
      // Online request that still failed (timeout/server): the user cannot
      // retry their way out, so offer the email path.
      await _fallbackEmailDeletion();
      return;
    } catch (e) {
      if (!mounted) return;
      await _fallbackEmailDeletion();
      return;
    }

    if (!mounted) return;
    context.showSnack(context.l10n.deleteAccountSuccess);
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
      context.showSnack(context.l10n.deleteAccountEmailSent);
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/more/profile/settings');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.deleteAccountManualFallback),
          duration: const Duration(seconds: 8),
        ),
      );
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsDeleteAccount)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ExcludeSemantics(
              child: Icon(
                Icons.warning_amber_rounded,
                size: 40,
                color: colors.error,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Semantics(
            header: true,
            child: Text(l10n.deleteTitle, style: context.text.headlineMedium),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.deleteAccountWarning,
            style: context.text.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppSectionCard(
            children: [
              TextField(
                controller: _confirmController,
                focusNode: _confirmFocus,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _confirmDelete(),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_expectedWord.length + 8),
                ],
                decoration: InputDecoration(
                  labelText: l10n.deleteAccountConfirmLabel(_expectedWord),
                  hintText: _expectedWord,
                  suffixIcon: _isConfirmed
                      ? Icon(Icons.check_rounded, color: colors.error)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _isConfirmed && !_isSubmitting ? _confirmDelete : null,
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            ),
            child: _isSubmitting
                ? SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onError,
                    ),
                  )
                : Text(l10n.deleteSubmit),
          ),
        ],
      ),
    );
  }
}
