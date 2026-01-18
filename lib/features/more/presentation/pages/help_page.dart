import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

/// Help center page with FAQ and support resources
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const List<HelpItem> _faqItems = [
    HelpItem(
      question: 'How do I add a new property?',
      answer: 'Go to the Properties tab and tap the "+" button. Fill in the required details and save.',
    ),
    HelpItem(
      question: 'How do I collect rent?',
      answer: 'Navigate to the Collections section to view pending payments. You can record payments and send reminders to tenants.',
    ),
    HelpItem(
      question: 'How do I create a lease agreement?',
      answer: 'Go to More > Leases and tap "New Lease". Select the property and tenant, then fill in the lease terms.',
    ),
    HelpItem(
      question: 'How do I schedule an inspection?',
      answer: 'Go to More > Inspections and tap "New Inspection". Select the property, choose the date, and add any notes.',
    ),
    HelpItem(
      question: 'How do I report a maintenance issue?',
      answer: 'Navigate to the Tasks section and tap "New Request". Describe the issue and select the relevant property.',
    ),
    HelpItem(
      question: 'How do I edit my profile?',
      answer: 'Go to More > Profile & Settings and tap "Edit Profile" to update your information and photo.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.helpCenter ?? 'Help Center'),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SearchBar(
              hintText: context.l10n?.searchHelp ?? 'Search for help...',
              leading: const Icon(Icons.search),
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Quick Links
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              context.l10n?.quickLinks ?? 'Quick Links',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _QuickLinkCard(
                  icon: Icons.school,
                  label: context.l10n?.gettingStarted ?? 'Getting Started',
                  onTap: () => _showArticle(context, 'getting-started'),
                ),
                _QuickLinkCard(
                  icon: Icons.home,
                  label: context.l10n?.propertyManagement ?? 'Properties',
                  onTap: () => _showArticle(context, 'properties'),
                ),
                _QuickLinkCard(
                  icon: Icons.payments,
                  label: context.l10n?.paymentsCollections ?? 'Payments',
                  onTap: () => _showArticle(context, 'payments'),
                ),
                _QuickLinkCard(
                  icon: Icons.assignment,
                  label: context.l10n?.leases ?? 'Leases',
                  onTap: () => _showArticle(context, 'leases'),
                ),
                _QuickLinkCard(
                  icon: Icons.build,
                  label: context.l10n?.maintenance ?? 'Maintenance',
                  onTap: () => _showArticle(context, 'maintenance'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // FAQ Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  context.l10n?.faq ?? 'Frequently Asked Questions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.help_outline, size: 20),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          ...List.generate(_faqItems.length, (index) {
            return _FAQItem(item: _faqItems[index]);
          }),

          const SizedBox(height: AppSpacing.lg),

          // Contact Support
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Icon(
                      Icons.contact_support,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n?.stillNeedHelp ?? 'Still need help?',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n?.contactSupportDesc ?? 'Our support team is here to assist you',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/more/profile/contact');
                      },
                      child: Text(context.l10n?.contactUs ?? 'Contact Us'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showArticle(BuildContext context, String articleId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening article: $articleId'),
      ),
    );
  }
}

class HelpItem {
  const HelpItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

class _FAQItem extends StatefulWidget {
  const _FAQItem({
    required this.item,
  });

  final HelpItem item;

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: ExpansionTile(
        title: Text(widget.item.question),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              widget.item.answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 90,
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
