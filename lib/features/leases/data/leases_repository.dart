import 'package:cross_file/cross_file.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/models/lease.dart';

class LeasesRepositoryImpl implements LeasesRepository {
  LeasesRepositoryImpl(this._client, this._uploads);

  final ApiClient _client;
  final FileUploadService _uploads;

  @override
  Future<Page<Lease>> listPage({
    required String? cursor,
    required int limit,
    int? propertyId,
    int? tenantUserId,
    LeaseStatus? status,
  }) async {
    final response = await _client.get<dynamic>(
      ApiPaths.leases,
      ownerScoped: true,
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'limit': limit,
        if (propertyId != null) 'property_id': propertyId,
        if (tenantUserId != null) 'tenant_user_id': tenantUserId,
        if (status != null) 'status': status.wire,
      },
    );
    final raw = unwrapPage(response.data);
    return Page<Lease>(
      items: raw.items
          .whereType<Map<String, dynamic>>()
          .map(Lease.fromJson)
          .toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
  }

  @override
  Future<List<Lease>> listAll({
    int? propertyId,
    int? tenantUserId,
    LeaseStatus? status,
  }) {
    return fetchAllPages<Lease>(
      ({required cursor, required limit}) => listPage(
        cursor: cursor,
        limit: limit,
        propertyId: propertyId,
        tenantUserId: tenantUserId,
        status: status,
      ),
    );
  }

  @override
  Future<Lease> fetch(String leaseId) async {
    final response = await _client.get<dynamic>('${ApiPaths.leases}/$leaseId');
    return Lease.fromJson(unwrapMap(response.data));
  }

  @override
  Future<Lease> create(LeaseCreateRequest request) async {
    final response = await _client.post<dynamic>(
      ApiPaths.leases,
      data: request.toJson(),
      ownerScoped: true,
    );
    return Lease.fromJson(unwrapMap(response.data));
  }

  @override
  Future<Lease> uploadSigned(
    String leaseId,
    XFile file, {
    bool signedByTenant = false,
  }) async {
    final id = int.parse(leaseId);
    // 1. The file is a document of the lease.
    final document = await _uploads.uploadDocument(
      file: file,
      documentType: DocumentType.leaseAgreement,
      title: 'Signed lease',
      leaseId: id,
      sharedWithTenant: signedByTenant,
    );
    final documentId = parseInt(document['id']);
    if (documentId == null) {
      throw const UnknownFailure('The document upload returned no id.');
    }
    // 2. The lease points at that document.
    final response = await _client.post<dynamic>(
      ApiPaths.leaseUploadSigned(id),
      data: {
        'lease_document_id': documentId,
        'signed_by_owner': true,
        'signed_by_tenant': signedByTenant,
      },
    );
    return Lease.fromJson(unwrapMap(response.data));
  }

  @override
  Future<Lease> renew(String leaseId, LeaseRenewRequest request) async {
    final response = await _client.post<dynamic>(
      ApiPaths.leaseRenew(int.parse(leaseId)),
      data: request.toJson(),
    );
    return Lease.fromJson(unwrapMap(response.data));
  }

  @override
  Future<Lease> terminate(String leaseId, LeaseTerminateRequest request) async {
    final response = await _client.post<dynamic>(
      ApiPaths.leaseTerminate(int.parse(leaseId)),
      data: request.toJson(),
    );
    return Lease.fromJson(unwrapMap(response.data));
  }
}
