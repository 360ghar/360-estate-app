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
        page: 1,
        limit: 100,
      );
  return result.items;
});

final maintenancePagedProvider = StateNotifierProvider<
    PagedListController<MaintenanceRequest>,
    PagedListState<MaintenanceRequest>>(
  (ref) {
    ref.watch(authControllerProvider.select((state) => state.user?.id));
    final repository = ref.watch(maintenanceRepositoryProvider);
    return PagedListController<MaintenanceRequest>(
      fetchPage: ({required page, required limit}) {
        return repository.getRequests(
          page: page,
          limit: limit,
        );
      },
    );
  },
);
