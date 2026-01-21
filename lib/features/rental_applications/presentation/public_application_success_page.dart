import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PublicApplicationSuccessPage extends StatelessWidget {
  const PublicApplicationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Application submitted')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 64),
          const SizedBox(height: 16),
          Text(
            'Thanks for applying.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'We have received your application and will follow up soon.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/enter-phone'),
            child: const Text('Go to sign in'),
          ),
        ],
      ),
    );
  }
}
