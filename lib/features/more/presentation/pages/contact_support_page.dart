import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Contact support page with form for submitting support requests
class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
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
      label: 'General Inquiry',
    ),
    _SupportCategory(
      value: 'technical',
      icon: Icons.bug_report,
      label: 'Technical Issue',
    ),
    _SupportCategory(
      value: 'billing',
      icon: Icons.payment,
      label: 'Billing',
    ),
    _SupportCategory(
      value: 'feature',
      icon: Icons.lightbulb,
      label: 'Feature Request',
    ),
    _SupportCategory(
      value: 'report',
      icon: Icons.report_problem,
      label: 'Report a Problem',
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitSupport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    final category = _categories
        .firstWhere(
          (item) => item.value == _selectedCategory,
          orElse: () => const _SupportCategory(
            value: 'general',
            icon: Icons.help_outline,
            label: 'General Inquiry',
          ),
        )
        .label;

    final body = StringBuffer()
      ..writeln('Name: $name')
      ..writeln('Email: $email')
      ..writeln('Category: $category')
      ..writeln()
      ..writeln(message);

    final uri = Uri(
      scheme: 'mailto',
      path: 'support@360estate.app',
      queryParameters: {
        'subject': subject.isEmpty ? 'Support Request - $category' : subject,
        'body': body.toString(),
      },
    );

    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open your email app.'),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email draft opened in your mail app.'),
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open your email app.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 32,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n?.howCanWeHelp ?? 'How can we help?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          context.l10n?.supportResponseTime ??
                              'We typically respond within 24 hours',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.l10n?.yourName ?? 'Your Name',
                prefixIcon: const Icon(Icons.person_outline),
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

            // Email field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: context.l10n?.emailLabel ?? 'Email Address',
                prefixIcon: const Icon(Icons.email_outlined),
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

            const SizedBox(height: AppSpacing.md),

            // Category selection
            Text(
              context.l10n?.category ?? 'Category',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category.value;
                return FilterChip(
                  label: Text(category.label),
                  avatar: Icon(category.icon, size: 18),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category.value;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.md),

            // Subject field
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: context.l10n?.subject ?? 'Subject',
                prefixIcon: const Icon(Icons.subject),
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

            // Message field
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: context.l10n?.message ?? 'Message',
                alignLabelWithHint: true,
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

            const SizedBox(height: AppSpacing.xl),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submitSupport,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n?.sendRequest ?? 'Send Request'),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Alternative contact
            Center(
              child: Text(
                context.l10n?.orEmailUs ?? 'Or email us directly at support@360estate.app',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
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
  });

  final String value;
  final IconData icon;
  final String label;
}
