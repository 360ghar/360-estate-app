import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/feedback/data/feedback_repository.dart';
import 'package:estate_app/features/feedback/feedback_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contact support page with form for submitting support requests
class ContactSupportPage extends ConsumerStatefulWidget {
  const ContactSupportPage({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  ConsumerState<ContactSupportPage> createState() =>
      _ContactSupportPageState();
}

class _ContactSupportPageState extends ConsumerState<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'general';
  bool _isSubmitting = false;

  static const List<_SupportCategory> _categories = [
    _SupportCategory(
      value: 'general',
      icon: Icons.help_outline,
      label: 'General',
      color: Color(0xFF3B82F6),
    ),
    _SupportCategory(
      value: 'technical',
      icon: Icons.bug_report_outlined,
      label: 'Technical',
      color: Color(0xFFEF4444),
    ),
    _SupportCategory(
      value: 'billing',
      icon: Icons.payment_outlined,
      label: 'Billing',
      color: Color(0xFF10B981),
    ),
    _SupportCategory(
      value: 'feature',
      icon: Icons.lightbulb_outline,
      label: 'Feature Request',
      color: Color(0xFFF59E0B),
    ),
    _SupportCategory(
      value: 'report',
      icon: Icons.report_problem_outlined,
      label: 'Report Problem',
      color: Color(0xFF8B5CF6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    const validCategories = {
      'general',
      'technical',
      'billing',
      'feature',
      'report',
    };
    final initial = widget.initialCategory;
    if (initial != null && validCategories.contains(initial)) {
      _selectedCategory = initial;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Maps the selected support category to the backend `bug_type` value.
  String _bugTypeForCategory(String category) {
    switch (category) {
      case 'feature':
        return 'feature_request';
      case 'technical':
      case 'report':
        return 'functionality_bug';
      case 'general':
      case 'billing':
      default:
        return 'other';
    }
  }

  Future<void> _submitSupport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    // The backend identifies the user via the Supabase JWT, so fold the
    // submitted name/email into the description for context.
    final description = StringBuffer()
      ..writeln(message)
      ..writeln()
      ..write('From: $name <$email>');

    final payload = BugReportPayload(
      bugType: _bugTypeForCategory(_selectedCategory),
      title: subject,
      description: description.toString(),
      tags: const ['estate'],
    );

    try {
      await ref.read(feedbackRepositoryProvider).submitBugReport(payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n?.supportRequestSent ??
                'Support request sent successfully',
          ),
        ),
      );
      Navigator.pop(context);
    } on Failure catch (failure) {
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n != null ? failure.localizedMessage(l10n) : failure.message,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.contactUs ?? 'Contact Us'),
      ),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkAccentSoft : AppColors.accentSoft,
                borderRadius: AppRadii.lg,
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                  width: 0.5,
                ),
                boxShadow: AppShadows.cardResting,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n?.howCanWeHelp ?? 'How can we help?',
                          style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          context.l10n?.supportResponseTime ??
                              'We typically respond within 24 hours',
                          style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Category selection header
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.category_outlined, size: 16, color: Color(0xFF3B82F6)),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  context.l10n?.category ?? 'Category',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Category chips as ChoiceChips
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category.value;
                return ChoiceChip(
                  label: Text(category.label),
                  avatar: Icon(
                    category.icon,
                    size: 16,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : category.color,
                  ),
                  selected: isSelected,
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceSecondary
                      : AppColors.surfaceSecondary,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : isDark
                            ? AppColors.darkCardBorder
                            : AppColors.cardBorder,
                    width: 0.5,
                  ),
                  showCheckmark: false,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category.value;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Form fields in section card - Contact Info
            AppSectionCard(
              title: 'Contact Information',
              icon: Icons.person_outline,
              iconColor: const Color(0xFF3B82F6),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Enter your full name',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n?.validationNameRequired ?? 'Name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'you@example.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n?.validationEmailRequired ?? 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return context.l10n?.validationEmailInvalid ?? 'Invalid email';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Message section
            AppSectionCard(
              title: 'Your Message',
              icon: Icons.message_outlined,
              iconColor: const Color(0xFF8B5CF6),
              children: [
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    prefixIcon: Icon(Icons.short_text_rounded),
                    hintText: 'Brief summary of your request',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n?.validationSubjectRequired ?? 'Subject is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Description multiline text area
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: context.l10n?.message ?? 'Description',
                    alignLabelWithHint: true,
                    hintText: 'Describe your issue or request in detail...',
                    border: OutlineInputBorder(
                      borderRadius: AppRadii.md,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadii.md,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadii.md,
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: AppRadii.md,
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: AppRadii.md,
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(AppSpacing.lg),
                  ),
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n?.validationMessageRequired ?? 'Message is required';
                    }
                    if (value.trim().length < 10) {
                      return context.l10n?.validationMessageTooShort ??
                              'Please provide more details (at least 10 characters)';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Submit button - prominent primary filled with send icon
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submitSupport,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 20),
                label: Text(
                  _isSubmitting
                      ? 'Sending...'
                      : (context.l10n?.sendRequest ?? 'Send Request'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Alternative contact info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceSecondary
                    : AppColors.surfaceSecondary,
                borderRadius: AppRadii.lg,
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alternate_email_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    context.l10n?.orEmailUs ?? 'Or email us directly at support@360estate.app',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _SupportCategory {
  const _SupportCategory({
    required this.value,
    required this.icon,
    required this.label,
    required this.color,
  });

  final String value;
  final IconData icon;
  final String label;
  final Color color;
}
