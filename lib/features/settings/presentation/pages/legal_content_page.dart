import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A legal text (privacy policy, terms). The text lives on the website, so
/// the page opens it in the in-app browser on arrival and keeps a button to
/// read it again.
class LegalContentPage extends StatefulWidget {
  const LegalContentPage({required this.title, required this.url, super.key});

  final String title;
  final String url;

  @override
  State<LegalContentPage> createState() => _LegalContentPageState();
}

class _LegalContentPageState extends State<LegalContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(widget.url),
        mode: LaunchMode.inAppBrowserView,
      );
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) context.showSnack(context.l10n.legalOpenFailed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.legalIntro,
            style: context.text.bodyLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SelectableText(
            Uri.parse(widget.url).host + Uri.parse(widget.url).path,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _open,
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(l10n.legalOpen),
          ),
        ],
      ),
    );
  }
}
