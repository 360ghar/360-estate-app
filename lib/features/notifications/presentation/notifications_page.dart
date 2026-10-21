import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/notifications/data/notifications_repository.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';
import 'package:estate_app/features/notifications/notifications_providers.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final _tokenController = TextEditingController();
  bool _isRegistering = false;
  DevicePlatform? _manualPlatform;

  @override
  void initState() {
    super.initState();
    _manualPlatform = _platform;
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  /// The push platform of this device: `web`, `ios` or `android`. Other
  /// desktop platforms have no push, so the value is null.
  DevicePlatform? get _platform {
    if (kIsWeb) return DevicePlatform.web;
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => DevicePlatform.ios,
      TargetPlatform.android => DevicePlatform.android,
      _ => null,
    };
  }

  Future<void> _registerDeviceManual() async {
    final l10n = context.l10n;
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      context.showSnack(l10n.notifDebugTokenMissing);
      return;
    }
    final platform = _manualPlatform;
    if (platform == null) {
      context.showSnack(l10n.notifDebugPlatformMissing);
      return;
    }

    setState(() => _isRegistering = true);
    try {
      await ref
          .read(notificationsRepositoryProvider)
          .registerDevice(
            DeviceRegistrationRequest(token: token, platform: platform),
          );
      if (mounted) context.showSnack(l10n.notifDebugRegistered);
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  Future<void> _markOpened(NotificationItem item) async {
    final id = item.id;
    if (id == null || item.readAt != null) return;
    try {
      await ref.read(notificationsRepositoryProvider).markOpened(id);
      await ref.read(notificationsPagedProvider.notifier).refresh();
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (ref.watch(authControllerProvider).user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.notifications)),
        body: AppEmptyView(
          title: l10n.notifSignedOutTitle,
          message: l10n.notifSignedOutBody,
          icon: Icons.notifications_off_outlined,
        ),
      );
    }

    final inbox = ref.watch(notificationsPagedProvider);
    final controller = ref.read(notificationsPagedProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: PagedListView<NotificationItem>(
        state: inbox,
        onLoadMore: controller.loadMore,
        onRefresh: controller.refresh,
        onRetry: controller.loadInitial,
        onLoadMoreRetry: controller.retryLoadMore,
        emptyTitle: l10n.notifEmptyTitle,
        emptyMessage: l10n.notifEmptyBody,
        emptyIcon: Icons.notifications_none_rounded,
        separatorSpacing: AppSpacing.sm,
        header: _PushNote(debugEntry: kDebugMode ? _debugEntry() : null),
        itemBuilder: (context, item) =>
            _NotificationRow(item: item, onOpen: () => _markOpened(item)),
      ),
    );
  }

  /// Developer-only: register a push token by hand (no token source yet).
  Widget _debugEntry() {
    final l10n = context.l10n;
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: EdgeInsets.zero,
      title: Text(l10n.notifDebugTitle, style: context.text.labelLarge),
      children: [
        TextField(
          controller: _tokenController,
          decoration: InputDecoration(labelText: l10n.notifDebugToken),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<DevicePlatform>(
          initialValue: _manualPlatform,
          decoration: InputDecoration(labelText: l10n.notifDebugPlatform),
          items: [
            for (final platform in DevicePlatform.values)
              DropdownMenuItem(value: platform, child: Text(platform.wire)),
          ],
          onChanged: (value) => setState(() => _manualPlatform = value),
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: _isRegistering ? null : _registerDeviceManual,
            child: Text(l10n.notifDebugRegister),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

/// Says plainly that push is not on yet, so the inbox is the place to look.
class _PushNote extends StatelessWidget {
  const _PushNote({this.debugEntry});

  final Widget? debugEntry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.notifPushNote,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        ?debugEntry,
      ],
    ),
  );
}

/// One alert. An unread one says "New" and opens (marks read) on tap.
class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item, required this.onOpen});

  final NotificationItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final unread = item.readAt == null;
    final (icon, color) = switch (item.type) {
      'payment' => (Icons.payments_outlined, context.palette.success),
      'maintenance' => (Icons.handyman_outlined, context.palette.warning),
      'lease' => (Icons.description_outlined, colors.secondary),
      'inspection' => (Icons.fact_check_outlined, colors.secondary),
      _ => (Icons.notifications_none_rounded, colors.onSurfaceVariant),
    };
    final at = item.createdAt;
    return AppListCard(
      leading: ExcludeSemantics(child: Icon(icon, color: color)),
      title: item.title?.trim().isNotEmpty ?? false
          ? item.title!.trim()
          : context.l10n.notifications,
      subtitle: item.body,
      facts: [if (at != null) dateTime(context, at)],
      status: unread
          ? AppStatusBadge(
              label: context.l10n.notifUnread,
              type: AppStatusType.info,
            )
          : null,
      onTap: unread ? onOpen : null,
    );
  }
}
