import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/notifications/data/notifications_repository.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.read(apiClientProvider)),
);

final notificationsListProvider =
    FutureProvider.family<List<NotificationItem>, String>(
  (ref, userId) => ref.read(notificationsRepositoryProvider).listForUser(userId),
);
