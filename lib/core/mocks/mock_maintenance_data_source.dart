/// Mock implementation of MaintenanceRemoteDataSource for development/demo mode.
library;

import 'package:estate_app/core/mocks/mock_data_factory.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/data/models/maintenance_request_dto.dart';

final class MockMaintenanceRemoteDataSource implements MaintenanceRemoteDataSource {
  MockMaintenanceRemoteDataSource();

  // Local mutable copy for CRUD operations
  final List<Map<String, dynamic>> _requests = 
      List<Map<String, dynamic>>.from(MockDataFactory.maintenanceRequests);

  int _nextId = 100;

  @override
  Future<Page<MaintenanceRequestDto>> getRequests({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
    String? priority,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = _requests.toList();

    // Apply filters
    if (propertyId != null) {
      filtered = filtered.where((r) => r['property_id'] == propertyId).toList();
    }
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((r) => r['request_status'] == status).toList();
    }
    if (priority != null && priority.isNotEmpty) {
      filtered = filtered.where((r) => r['priority'] == priority).toList();
    }
    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((r) => r['category'] == category).toList();
    }

    // Sort by created_at descending
    filtered.sort((a, b) {
      final aDate = DateTime.parse(a['created_at'] as String);
      final bDate = DateTime.parse(b['created_at'] as String);
      return bDate.compareTo(aDate);
    });

    // Paginate
    final offset = (page - 1) * limit;
    final paged = filtered.skip(offset).take(limit).toList();
    final hasMore = offset + paged.length < filtered.length;

    final items = paged.map((r) => MaintenanceRequestDto.fromJson(r)).toList();

    return Page<MaintenanceRequestDto>(
      items: items,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  @override
  Future<MaintenanceRequestDto> getRequestById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final request = _requests.firstWhere(
      (r) => r['id'] == id,
      orElse: () => throw Exception('Maintenance request not found: $id'),
    );

    return MaintenanceRequestDto.fromJson(request);
  }

  @override
  Future<MaintenanceRequestDto> createRequest(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now().toIso8601String();
    final propertyId = data['property_id'] as int;

    // Find property details
    final property = MockDataFactory.findPropertyById(propertyId);
    final propertyTitle = property?['title'] as String? ?? 'Unknown Property';

    // Get tenant info if lease exists
    int? leaseId;
    String? tenantName;
    final activeLease = property?['active_lease'];
    if (activeLease != null && activeLease is Map<String, dynamic>) {
      leaseId = activeLease['id'] as int?;
      tenantName = activeLease['tenant_name'] as String?;
    }

    final newRequest = {
      'id': _nextId++,
      'property_id': propertyId,
      'property_title': propertyTitle,
      'lease_id': data['lease_id'] ?? leaseId,
      'tenant_name': data['tenant_name'] ?? tenantName,
      'category': data['category'] ?? 'other',
      'priority': data['priority'] ?? 'medium',
      'request_status': 'open',
      'title': data['title'] ?? '',
      'description': data['description'] ?? '',
      'assigned_to': null,
      'estimated_cost': data['estimated_cost'],
      'actual_cost': null,
      'scheduled_date': data['scheduled_date'],
      'completed_date': null,
      'notes': data['notes'],
      'image_urls': data['image_urls'],
      'created_at': now,
      'updated_at': now,
    };

    _requests.insert(0, newRequest);
    return MaintenanceRequestDto.fromJson(newRequest);
  }

  @override
  Future<MaintenanceRequestDto> updateRequest(
    int id,
    Map<String, dynamic> updates,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _requests.indexWhere((r) => r['id'] == id);
    if (index == -1) {
      throw Exception('Maintenance request not found: $id');
    }

    final updated = Map<String, dynamic>.from(_requests[index]);
    updates.forEach((key, value) {
      // Handle special key mappings
      final snakeKey = switch (key) {
        'requestStatus' => 'request_status',
        _ => key.replaceAllMapped(
            RegExp(r'[A-Z]'),
            (m) => '_${m.group(0)!.toLowerCase()}',
          ),
      };
      updated[snakeKey] = value;
    });
    updated['updated_at'] = DateTime.now().toIso8601String();

    // Auto-set completed_date when status changes to completed
    if (updates['request_status'] == 'completed' && updated['completed_date'] == null) {
      updated['completed_date'] = DateTime.now().toIso8601String().split('T')[0];
    }

    _requests[index] = updated;
    return MaintenanceRequestDto.fromJson(updated);
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    await updateRequest(id, {'request_status': status});
  }
}
