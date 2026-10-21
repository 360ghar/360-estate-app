import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _Topic { all, properties, rent, leases, maintenance, account }

/// Answers to the common questions, searchable, with a way to ask us.
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _search = TextEditingController();
  _Topic _topic = _Topic.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  static List<(_Topic, String, String)> _faq(AppLocalizations l10n) => [
    (_Topic.properties, l10n.helpQ1, l10n.helpA1),
    (_Topic.rent, l10n.helpQ2, l10n.helpA2),
    (_Topic.leases, l10n.helpQ3, l10n.helpA3),
    (_Topic.properties, l10n.helpQ4, l10n.helpA4),
    (_Topic.maintenance, l10n.helpQ5, l10n.helpA5),
    (_Topic.account, l10n.helpQ6, l10n.helpA6),
  ];

  static String _topicLabel(AppLocalizations l10n, _Topic topic) =>
      switch (topic) {
        _Topic.all => l10n.helpCatAll,
        _Topic.properties => l10n.helpCatProperties,
        _Topic.rent => l10n.helpCatRent,
        _Topic.leases => l10n.helpCatLeases,
        _Topic.maintenance => l10n.helpCatMaintenance,
        _Topic.account => l10n.helpCatAccount,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = _search.text.trim().toLowerCase();
    final items = _faq(l10n)
        .where(
          (f) =>
              (_topic == _Topic.all || f.$1 == _topic) &&
              (query.isEmpty ||
                  f.$2.toLowerCase().contains(query) ||
                  f.$3.toLowerCase().contains(query)),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreHelp)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.helpSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.commonClearSearch,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => setState(_search.clear),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final topic in _Topic.values)
                ChoiceChip(
                  label: Text(_topicLabel(l10n, topic)),
                  selected: _topic == topic,
                  onSelected: (_) => setState(() => _topic = topic),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (items.isEmpty)
            AppEmptyView(
              title: l10n.helpNoResultsTitle,
              message: l10n.helpNoResultsBody,
              icon: Icons.search_off_rounded,
            )
          else
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        indent: AppSpacing.lg,
                        endIndent: AppSpacing.lg,
                      ),
                    ExpansionTile(
                      shape: const Border(),
                      collapsedShape: const Border(),
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      expandedAlignment: Alignment.centerLeft,
                      title: Text(
                        items[i].$2,
                        style: context.text.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        Text(
                          items[i].$3,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.helpStillStuckTitle, style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.helpStillStuckBody,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => context.push('/more/profile/contact'),
                  icon: const Icon(Icons.mail_outline_rounded, size: 18),
                  label: Text(l10n.moreContact),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
