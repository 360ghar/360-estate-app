import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/leases/data/models/lease_dto.dart';

/// Remote data source for lease management.
/// NOTE: The PM leases endpoints (/pm/leases/*) do not yet exist in the backend.
abstract interface class LeasesRemoteDataSource {
  Future<Page<LeaseDto>> getLeases({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
  });

  Future<LeaseDto> getLeaseById(int id);

  Future<LeaseDto> createLease(Map<String, dynamic> data);

  Future<LeaseDto> uploadSignedLease(int leaseId, String filePath);

  Future<LeaseDto> renewLease(int leaseId, Map<String, dynamic> renewalData);

  Future<void> terminateLease(int leaseId, {String? reason});
}

/// Stub implementation that returns empty data since PM leases endpoints
/// are not available in the current backend.
final class ApiLeasesRemoteDataSource implements LeasesRemoteDataSource {
  ApiLeasesRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Page<LeaseDto>> getLeases({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
  }) async {
    print('[LEASES] WARNING: PM leases endpoint not available');
    return Page<LeaseDto>(
      items: [],
      page: page,
      limit: limit,
      hasMore: false,
    );
  }

  @override
  Future<LeaseDto> getLeaseById(int id) async {
    print('[LEASES] WARNING: PM leases endpoint not available');
    throw UnsupportedError(
      'Lease management is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<LeaseDto> createLease(Map<String, dynamic> data) async {
    print('[LEASES] WARNING: PM leases endpoint not available');
    throw UnsupportedError(
      'Lease creation is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<LeaseDto> uploadSignedLease(int leaseId, String filePath) async {
    print('[LEASES] WARNING: PM leases endpoint not available');
    throw UnsupportedError(
      'Signed lease upload is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<LeaseDto> renewLease(int leaseId, Map<String, dynamic> renewalData) async {
    print('[LEASES] WARNING: PM leases endpoint not available');
    throw UnsupportedError(
      'Lease renewal is not yet available. PM module pending backend implementation.',
    );
  }

  @override
  Future<void> terminateLease(int leaseId, {String? reason}) async {
    print('[LEASES] WARNING: PM leases endpoint not available');
    throw UnsupportedError(
      'Lease termination is not yet available. PM module pending backend implementation.',
    );
  }
}

