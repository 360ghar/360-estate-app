import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/notifications/data/notifications_repository.dart';
import 'package:estate_app/features/notifications/models/notification_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  ref.watch(accountScopeProvider);
  return NotificationsRepository(ref.read(apiClientProvider));
});

/// The signed-in user's inbox, one page at a time (follow `next_cursor` with
/// `loadMore`).
final notificationsPagedProvider =
    StateNotifierProvider<
      PagedListController<NotificationItem>,
      PagedListState<NotificationItem>
    >((ref) {
      final repository = ref.watch(notificationsRepositoryProvider);
      return PagedListController<NotificationItem>(
        pageSize: 50,
        fetchPage: ({required cursor, required limit}) {
          return repository.listPage(cursor: cursor, limit: limit);
        },
      );
    });
