import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/leases/data/leases_repository.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaseListFilter {
  const LeaseListFilter({this.propertyId, this.tenantUserId, this.status});

  final int? propertyId;
  final int? tenantUserId;
  final LeaseStatus? status;

  @override
  bool operator ==(Object other) {
    return other is LeaseListFilter &&
        other.propertyId == propertyId &&
        other.tenantUserId == tenantUserId &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(propertyId, tenantUserId, status);
}

final leasesRepositoryProvider = Provider<LeasesRepository>((ref) {
  ref.watch(accountScopeProvider);
  return LeasesRepositoryImpl(
    ref.read(apiClientProvider),
    ref.read(fileUploadServiceProvider),
  );
});

/// Every lease that matches the filter (all pages).
final leasesListProvider = FutureProvider.family<List<Lease>, LeaseListFilter>(
  (ref, filter) => ref
      .watch(leasesRepositoryProvider)
      .listAll(
        propertyId: filter.propertyId,
        tenantUserId: filter.tenantUserId,
        status: filter.status,
      ),
);

final leaseDetailProvider = FutureProvider.family<Lease, String>(
  (ref, id) => ref.watch(leasesRepositoryProvider).fetch(id),
);

/// Tenant name by lease id, for screens that list rent charges: a charge
/// carries a lease id and no tenant name.
final leaseTenantNamesProvider = FutureProvider<Map<int, String>>((ref) async {
  final leases = await ref.watch(
    leasesListProvider(const LeaseListFilter()).future,
  );
  return {
    for (final lease in leases)
      if (lease.id != null && (lease.tenantName?.trim().isNotEmpty ?? false))
        lease.id!: lease.tenantName!.trim(),
  };
});
