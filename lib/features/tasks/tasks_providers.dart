import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/data/repositories/maintenance_repository_impl.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the maintenance remote data source
final maintenanceRemoteDataSourceProvider =
    Provider<ApiMaintenanceRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ApiMaintenanceRemoteDataSource(apiClient);
});

/// Provider for the maintenance repository implementation
final maintenanceRepositoryProvider = Provider<MaintenanceRepositoryImpl>((ref) {
  final remoteDataSource = ref.read(maintenanceRemoteDataSourceProvider);
  return MaintenanceRepositoryImpl(remoteDataSource);
});

final maintenanceListProvider = FutureProvider<List<MaintenanceRequest>>((ref) async {
  ref.watch(authControllerProvider.select((state) => state.user?.id));
  final result = await ref.watch(maintenanceRepositoryProvider).getRequests(
        cursor: null,
        limit: 100,
      );
  return result.items;
});

/// Provider for maintenance requests scoped to a specific property.
/// Used by the property detail page's Maintenance tab.
final maintenanceListForPropertyProvider =
    FutureProvider.family<List<MaintenanceRequest>, int>(
  (ref, propertyId) async {
    ref.watch(authControllerProvider.select((state) => state.user?.id));
    final result = await ref.watch(maintenanceRepositoryProvider).getRequests(
          cursor: null,
          limit: 100,
          propertyId: propertyId,
        );
    return result.items;
  },
);

final maintenancePagedProvider = StateNotifierProvider<
    PagedListController<MaintenanceRequest>,
    PagedListState<MaintenanceRequest>>(
  (ref) {
    ref.watch(authControllerProvider.select((state) => state.user?.id));
    final repository = ref.watch(maintenanceRepositoryProvider);
    return PagedListController<MaintenanceRequest>(
      fetchPage: ({required cursor, required limit}) {
        return repository.getRequests(
          cursor: cursor,
          limit: limit,
        );
      },
    );
  },
);

/// Paged provider for maintenance requests filtered by status. When a status
/// filter is active, the backend is queried with that status so the filter
/// applies across ALL pages, not just the currently loaded items.
final maintenancePagedByStatusProvider = StateNotifierProvider.family<
    PagedListController<MaintenanceRequest>,
    PagedListState<MaintenanceRequest>,
    String?>(
  (ref, status) {
    ref.watch(authControllerProvider.select((state) => state.user?.id));
    final repository = ref.watch(maintenanceRepositoryProvider);
    return PagedListController<MaintenanceRequest>(
      fetchPage: ({required cursor, required limit}) {
        return repository.getRequests(
          cursor: cursor,
          limit: limit,
          status: status,
        );
      },
    );
  },
);
