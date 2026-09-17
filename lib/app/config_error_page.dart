import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:flutter/material.dart';

/// Shown when `.env` is missing Supabase config.
/// Replaces the old `throw StateError` that crashed fresh checkouts.
class ConfigErrorPage extends StatelessWidget {
  const ConfigErrorPage({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AppErrorView(
          title: 'Missing configuration',
          message:
              message ??
              'SUPABASE_URL or SUPABASE_PUBLISHABLE_KEY is empty.\n'
                  'Copy .env.example to .env and fill the values,\n'
                  'then restart the app.',
        ),
      ),
    );
  }
}
