import 'dart:io' show Platform;

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/notifications/data/notifications_repository.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';
import 'package:estate_app/features/notifications/notifications_providers.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
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
  bool _showManualEntry = false;

  @override
  void initState() {
    super.initState();
    _platformController.text = _platform;
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _platformController.dispose();
    super.dispose();
  }

  String get _platform {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    if (Platform.isWindows) return 'windows';
    return 'unknown';
  }

  Future<void> _registerDeviceAuto() async {
    setState(() => _isRegistering = true);
    try {
      // FCM/push integration is not yet configured. Once firebase_messaging
      // is added, the token will be obtained automatically here. For now we
      // inform the user that push is pending setup.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Push notifications will be available once FCM is configured. '
              'Use manual entry in debug mode to register a device token.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  Future<void> _registerDeviceManual() async {
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
              platform: _platformController.text.trim().isEmpty
                  ? _platform
                  : _platformController.text.trim(),
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
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final userId = authState.user?.id?.toString();

    if (userId == null) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const AppEmptyView(
          title: 'No profile found',
          message: 'Sign in to view notifications.',
          icon: Icons.notifications_off_outlined,
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
          // Device registration section
          AppSectionCard(
            title: 'Push Notifications',
            icon: Icons.notifications_active_outlined,
            iconColor: AppColors.info,
            children: [
              Text(
                'Register your device to receive push notifications for important updates.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _isRegistering ? null : _registerDeviceAuto,
                  icon: _isRegistering
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.notifications_active, size: 20),
                  label: Text('Setup Push Notifications ($_platform)'),
                ),
              ),
              // Developer-facing manual token entry (debug mode only)
              if (kDebugMode) ...[
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _showManualEntry = !_showManualEntry);
                  },
                  icon: Icon(
                    _showManualEntry
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                  label: Text(
                    _showManualEntry
                        ? 'Hide manual entry'
                        : 'Manual token entry (debug)',
                  ),
                ),
                if (_showManualEntry) ...[
                  TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Device token',
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _platformController,
                    decoration: const InputDecoration(
                      labelText: 'Platform',
                      hintText: 'ios or android',
                      prefixIcon: Icon(Icons.phone_android_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed:
                          _isRegistering ? null : _registerDeviceManual,
                      icon: const Icon(Icons.app_registration, size: 20),
                      label: const Text('Register (Manual)'),
                    ),
                  ),
                ],
              ],
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Recent notifications header
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 16,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Recent Notifications',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          notificationsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return _buildEmptyState(theme);
              }
              return Column(
                children: items
                    .map((item) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _NotificationTile(item: item),
                        ))
                    .toList(),
              );
            },
            loading: () => const AppLoadingShimmer(itemCount: 2),
            error: (error, _) => AppErrorView(
              title: 'Unable to load notifications',
              message: error.toString(),
              onRetry: () =>
                  ref.invalidate(notificationsListProvider(userId)),
              retryLabel: 'Try again',
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 28,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No notifications yet',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Activity updates, payment reminders, and maintenance\nalerts will appear here as they happen.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
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
    return DateFormat('d MMM yyyy, h:mm a').format(date);
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'payment':
        return Icons.payments_outlined;
      case 'maintenance':
        return Icons.build_outlined;
      case 'lease':
        return Icons.assignment_outlined;
      case 'inspection':
        return Icons.fact_check_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String? type) {
    switch (type) {
      case 'payment':
        return AppColors.success;
      case 'maintenance':
        return AppColors.warning;
      case 'lease':
        return AppColors.info;
      case 'inspection':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUnread = item.readAt == null;
    final date = _formatDate(item.createdAt);
    final iconColor = _colorForType(item.type);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUnread
            ? (isDark ? AppColors.darkAccentSoft : AppColors.accentSoft)
            : theme.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForType(item.type),
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title ?? 'Notification',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isUnread ? FontWeight.w600 : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin:
                            const EdgeInsets.only(left: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                if (item.body != null && item.body!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.body!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (date.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    date,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
