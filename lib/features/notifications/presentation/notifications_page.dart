import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/notifications/data/notifications_repository.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';
import 'package:estate_app/features/notifications/notifications_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final _tokenController = TextEditingController();
  final _platformController = TextEditingController();
  bool _isRegistering = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _platformController.dispose();
    super.dispose();
  }

  Future<void> _registerDevice() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a device token.')),
      );
      return;
    }

    setState(() => _isRegistering = true);
    try {
      await ref.read(notificationsRepositoryProvider).registerDevice(
            DeviceRegistrationRequest(
              token: token,
              platform: _platformController.text.trim(),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device registered.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final userId = authState.user?.id?.toString();

    if (userId == null) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const AppEmptyView(
          title: 'No profile found',
          message: 'Sign in to view notifications.',
        ),
      );
    }

    final notificationsAsync = ref.watch(notificationsListProvider(userId));

    return AppScaffold(
      appBar: AppBar(title: const Text('Notifications')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Register device for alerts'),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _tokenController,
            decoration: const InputDecoration(labelText: 'Device token'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _platformController,
            decoration: const InputDecoration(
              labelText: 'Platform (optional)',
              hintText: 'ios or android',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isRegistering ? null : _registerDevice,
              child: _isRegistering
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Register device'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Recent notifications'),
          const SizedBox(height: AppSpacing.sm),
          notificationsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const AppEmptyView(
                  title: 'No notifications yet',
                  message: 'Activity updates will appear here.',
                );
              }
              return Column(
                children: items
                    .map((item) => _NotificationTile(item: item))
                    .toList(),
              );
            },
            loading: () => const AppLoadingShimmer(itemCount: 2),
            error: (error, _) => AppErrorView(
              title: 'Unable to load notifications',
              message: error.toString(),
              onRetry: () => ref.invalidate(notificationsListProvider(userId)),
              retryLabel: 'Try again',
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(item.createdAt);
    return Card(
      child: ListTile(
        title: Text(item.title ?? 'Notification'),
        subtitle: Text(item.body ?? date),
        trailing: date.isEmpty ? null : Text(date),
      ),
    );
  }
}
