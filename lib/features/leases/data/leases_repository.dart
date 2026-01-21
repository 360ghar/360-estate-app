import 'dart:io';

import 'package:dio/dio.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/models/lease.dart';

class LeasesRepositoryImpl implements LeasesRepository {
  LeasesRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<Lease>> list({
    String? propertyId,
    String? tenantId,
    String? status,
  }) async {
    final response = await _client.get(
      '/pm/leases/',
      queryParameters: {
        if (propertyId != null) 'property_id': propertyId,
        if (tenantId != null) 'tenant_id': tenantId,
        if (status != null) 'status': status,
      },
    );
    final data = unwrapList(response.data);
    return data
        .whereType<Map<String, dynamic>>()
        .map(Lease.fromJson)
        .toList();
  }

  @override
  Future<Lease> fetch(String leaseId) async {
    final response = await _client.get('/pm/leases/$leaseId');
    final data = unwrapMap(response.data);
    return Lease.fromJson(data);
  }

  @override
  Future<Lease> create(LeaseCreateRequest request) async {
    final response = await _client.post(
      '/pm/leases/',
      data: request.toJson(),
    );
    final data = unwrapMap(response.data);
    return Lease.fromJson(data);
  }

  @override
  Future<Lease> uploadSigned(String leaseId, File file) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await _client.upload(
      '/pm/leases/$leaseId/upload-signed',
      data: formData,
    );
    final data = unwrapMap(response.data);
    if (data.isNotEmpty) return Lease.fromJson(data);
    return fetch(leaseId);
  }

  @override
  Future<Lease> renew(String leaseId, LeaseRenewRequest request) async {
    final response = await _client.post(
      '/pm/leases/$leaseId/renew',
      data: request.toJson(),
    );
    final data = unwrapMap(response.data);
    if (data.isNotEmpty) return Lease.fromJson(data);
    return fetch(leaseId);
  }

  @override
  Future<Lease> terminate(String leaseId, LeaseTerminateRequest request) async {
    final response = await _client.post(
      '/pm/leases/$leaseId/terminate',
      data: request.toJson(),
    );
    final data = unwrapMap(response.data);
    if (data.isNotEmpty) return Lease.fromJson(data);
    return fetch(leaseId);
  }
}
