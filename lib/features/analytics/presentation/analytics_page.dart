import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

/// Analytics page - Coming Soon
///
/// This page is under development. Analytics data will be fetched from the API
/// when the backend analytics endpoints are available.
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: const AppEmptyView(
        title: 'Analytics Coming Soon',
        message: 'Detailed analytics and reports will be available here once the API endpoints are implemented.',
        icon: Icons.analytics_outlined,
      ),
    );
  }
}
