import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/data/repositories/maintenance_repository_impl.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the maintenance remote data source
final maintenanceRemoteDataSourceProvider =
    Provider<MaintenanceRemoteDataSource>((ref) {
      ref.watch(accountScopeProvider);
      return ApiMaintenanceRemoteDataSource(ref.read(apiClientProvider));
    });

/// Provider for the maintenance repository implementation
final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  return MaintenanceRepositoryImpl(
    ref.watch(maintenanceRemoteDataSourceProvider),
  );
});

/// Every maintenance request of the account (all pages).
final maintenanceListProvider = FutureProvider<List<MaintenanceRequest>>((ref) {
  return ref.watch(maintenanceRepositoryProvider).getAllRequests();
});

/// Provider for maintenance requests scoped to a specific property (all
/// pages). Used by the property detail page's Maintenance tab.
final maintenanceListForPropertyProvider =
    FutureProvider.family<List<MaintenanceRequest>, int>((ref, propertyId) {
      return ref
          .watch(maintenanceRepositoryProvider)
          .getAllRequests(propertyId: propertyId);
    });

/// One request by id. The backend has no by-id route, so it is found in the
/// full list.
final maintenanceRequestProvider =
    FutureProvider.family<MaintenanceRequest?, int>((ref, id) async {
      final all = await ref.watch(maintenanceListProvider.future);
      for (final request in all) {
        if (request.id == id) return request;
      }
      return null;
    });

/// Paged provider for maintenance requests filtered by status. The backend is
/// queried with `request_status`, so the filter applies across ALL pages, not
/// just the loaded items.
final maintenancePagedByStatusProvider =
    StateNotifierProvider.family<
      PagedListController<MaintenanceRequest>,
      PagedListState<MaintenanceRequest>,
      MaintenanceRequestStatus?
    >((ref, status) {
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
    });

/// Reads the `Agent` body of `GET /agents/assigned`: the id and the name.
({int id, String name})? assignedAgentFromJson(Map<String, dynamic> json) {
  final id = parseInt(json['id']);
  if (id == null) return null;
  return (id: id, name: parseString(json['name']) ?? 'Your agent');
}

/// The agent assigned to the signed-in user (`GET /agents/assigned`), or null
/// when none is assigned. A maintenance request can be given to that agent
/// (`assigned_agent_id`): the backend accepts only the owner's agent.
final assignedAgentProvider = FutureProvider<({int id, String name})?>((
  ref,
) async {
  ref.watch(accountScopeProvider);
  try {
    final response = await ref
        .read(apiClientProvider)
        .get<dynamic>(ApiPaths.assignedAgent);
    return assignedAgentFromJson(unwrapMap(response.data));
  } on NotFoundFailure {
    return null;
  }
});
