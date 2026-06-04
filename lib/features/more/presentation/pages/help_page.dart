import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

/// Help center page with FAQ and support resources
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  static const List<HelpItem> _faqItems = [
    HelpItem(
      question: 'How do I add a new property?',
      answer: 'Go to the Properties tab and tap the "+" button. Fill in the required details and save.',
      category: 'properties',
    ),
    HelpItem(
      question: 'How do I collect rent?',
      answer: 'Navigate to the Collections section to view pending payments. You can record payments and send reminders to tenants.',
      category: 'payments',
    ),
    HelpItem(
      question: 'How do I create a lease agreement?',
      answer: 'Go to More > Leases and tap "New Lease". Select the property and tenant, then fill in the lease terms.',
      category: 'leases',
    ),
    HelpItem(
      question: 'How do I schedule an inspection?',
      answer: 'Go to More > Inspections and tap "New Inspection". Select the property, choose the date, and add any notes.',
      category: 'properties',
    ),
    HelpItem(
      question: 'How do I report a maintenance issue?',
      answer: 'Navigate to the Tasks section and tap "New Request". Describe the issue and select the relevant property.',
      category: 'maintenance',
    ),
    HelpItem(
      question: 'How do I edit my profile?',
      answer: 'Go to More > Profile & Settings and tap "Edit Profile" to update your information and photo.',
    ),
  ];

  static const List<_Category> _categories = [
    _Category(label: 'All', value: 'all', icon: Icons.apps),
    _Category(label: 'Properties', value: 'properties', icon: Icons.home),
    _Category(label: 'Payments', value: 'payments', icon: Icons.payments),
    _Category(label: 'Leases', value: 'leases', icon: Icons.assignment),
    _Category(label: 'Maintenance', value: 'maintenance', icon: Icons.build),
    _Category(label: 'General', value: 'general', icon: Icons.help_outline),
  ];

  List<HelpItem> get _filteredItems {
    return _faqItems.where((item) {
      final matchesCategory = _selectedCategory == 'all' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.helpCenter ?? 'Help Center'),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSecondary : AppColors.surfaceSecondary,
              borderRadius: AppRadii.lg,
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
                width: 0.5,
              ),
              boxShadow: AppShadows.cardResting,
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: context.l10n?.searchHelp ?? 'Search for help...',
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Category chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category.value;

                return FilterChip(
                  label: Text(
                    category.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  avatar: Icon(
                    category.icon,
                    size: 16,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = category.value),
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceSecondary
                      : AppColors.surfaceSecondary,
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : isDark
                            ? AppColors.darkCardBorder
                            : AppColors.cardBorder,
                    width: 0.5,
                  ),
                  showCheckmark: false,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Quick Links
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.link_rounded, size: 16, color: Color(0xFF10B981)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                context.l10n?.quickLinks ?? 'Quick Links',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _QuickLinkCard(
                  icon: Icons.school,
                  iconColor: const Color(0xFF3B82F6),
                  label: context.l10n?.gettingStarted ?? 'Getting Started',
                  onTap: () => _showArticle(context, 'getting-started'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickLinkCard(
                  icon: Icons.home,
                  iconColor: const Color(0xFF10B981),
                  label: context.l10n?.propertyManagement ?? 'Properties',
                  onTap: () => _showArticle(context, 'properties'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickLinkCard(
                  icon: Icons.payments,
                  iconColor: const Color(0xFFF59E0B),
                  label: context.l10n?.paymentsCollections ?? 'Payments',
                  onTap: () => _showArticle(context, 'payments'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickLinkCard(
                  icon: Icons.assignment,
                  iconColor: const Color(0xFF8B5CF6),
                  label: context.l10n?.leases ?? 'Leases',
                  onTap: () => _showArticle(context, 'leases'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickLinkCard(
                  icon: Icons.build,
                  iconColor: const Color(0xFFEF4444),
                  label: context.l10n?.maintenance ?? 'Maintenance',
                  onTap: () => _showArticle(context, 'maintenance'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // FAQ Section
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.help_outline, size: 16, color: Color(0xFF3B82F6)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                context.l10n?.faq ?? 'Frequently Asked Questions',
                style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          ..._filteredItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _FAQCard(item: item),
              )),

          if (_filteredItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xxl,
                horizontal: AppSpacing.lg,
              ),
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
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_off_rounded,
                      size: 24,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No results found',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Try a different search term or category',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: AppSpacing.xl),

          // Still need help? CTA
          AppCard(
            variant: AppCardVariant.tinted,
            tintColor: theme.colorScheme.primary,
            onTap: () {
              Navigator.of(context).pushNamed('/more/profile/contact');
            },
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.contact_support_rounded,
                    size: 26,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  context.l10n?.stillNeedHelp ?? 'Still need help?',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n?.contactSupportDesc ?? 'Our support team is here to assist you',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/more/profile/contact');
                  },
                  icon: const Icon(Icons.mail_outline, size: 18),
                  label: Text(context.l10n?.contactUs ?? 'Contact Us'),
                ),
              ],
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
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _Category {
  const _Category({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;
}

class HelpItem {
  const HelpItem({
    required this.question,
    required this.answer,
    this.category = 'general',
  });

  final String question;
  final String answer;
  final String category;
}

// Animated FAQ card with smooth expand/collapse
class _FAQCard extends StatefulWidget {
  const _FAQCard({required this.item});

  final HelpItem item;

  @override
  State<_FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<_FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppDurations.defaultCurve,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: _isExpanded
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : isDark
                  ? AppColors.darkCardBorder
                  : AppColors.cardBorder,
          width: _isExpanded ? 1.0 : 0.5,
        ),
        boxShadow: _isExpanded ? AppShadows.cardHovered : AppShadows.cardResting,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: AppRadii.lg,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _isExpanded
                          ? theme.colorScheme.primary.withValues(alpha: 0.10)
                          : (isDark
                              ? AppColors.darkSurfaceSecondary
                              : AppColors.surfaceSecondary),
                      borderRadius: AppRadii.sm,
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 18,
                      color: _isExpanded
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      widget.item.question,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: _isExpanded ? FontWeight.w600 : FontWeight.w500,
                        color: _isExpanded
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: AppDurations.fast,
                    curve: AppDurations.defaultCurve,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _isExpanded
                            ? theme.colorScheme.primary.withValues(alpha: 0.10)
                            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.expand_more,
                        size: 18,
                        color: _isExpanded
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSecondary
                      : AppColors.surfaceSecondary,
                  borderRadius: AppRadii.md,
                ),
                child: Text(
                  widget.item.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                ),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppDurations.medium,
            sizeCurve: AppDurations.defaultCurve,
          ),
        ],
      ),
    );
  }
}

// Quick link card with colored icon
class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.lg,
      child: Container(
        width: 92,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 0.5,
          ),
          boxShadow: AppShadows.cardResting,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
