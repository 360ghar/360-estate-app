import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalContentPage extends StatefulWidget {
  const LegalContentPage({
    required this.title,
    required this.url,
    super.key,
  });

  final String title;
  final String url;

  @override
  State<LegalContentPage> createState() => _LegalContentPageState();
}

class _LegalContentPageState extends State<LegalContentPage> {
  bool _launched = false;

  @override
  void initState() {
    super.initState();
    _openUrl();
  }

  Future<void> _openUrl() async {
    final uri = Uri.parse(widget.url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    _launched = launched;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(widget.title)),
      scrollable: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
            child: Text(
              _launched
                  ? 'Opening...'
                  : 'Could not open this link. Please try again.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}