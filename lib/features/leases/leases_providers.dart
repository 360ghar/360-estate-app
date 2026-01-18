import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/leases/data/leases_repository.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaseListFilter {
  const LeaseListFilter({this.propertyId, this.tenantId, this.status});

  final String? propertyId;
  final String? tenantId;
  final String? status;

  @override
  bool operator ==(Object other) {
    return other is LeaseListFilter &&
        other.propertyId == propertyId &&
        other.tenantId == tenantId &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(propertyId, tenantId, status);
}

final leasesRepositoryProvider = Provider<LeasesRepository>((ref) {
  return LeasesRepositoryImpl(ref.read(apiClientProvider));
});

final leasesListProvider =
    FutureProvider.family<List<Lease>, LeaseListFilter>(
  (ref, filter) => ref.read(leasesRepositoryProvider).list(
        propertyId: filter.propertyId,
        tenantId: filter.tenantId,
        status: filter.status,
      ),
);

final leaseDetailProvider = FutureProvider.family<Lease, String>(
  (ref, id) => ref.read(leasesRepositoryProvider).fetch(id),
);
