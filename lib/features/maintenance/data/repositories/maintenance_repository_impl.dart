import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/maintenance/domain/repositories/maintenance_repository.dart';

final class MaintenanceRepositoryImpl implements MaintenanceRepository {
  MaintenanceRepositoryImpl(this._remoteDataSource);

  final MaintenanceRemoteDataSource _remoteDataSource;

  @override
  Future<Page<MaintenanceRequest>> getRequests({
    required int page,
    required int limit,
    int? propertyId,
    String? status,
    String? priority,
    String? category,
  }) async {
    final apiStatus = status == null ? null : _mapStatus(status);
    final apiPriority = priority == null ? null : _mapUrgency(priority);
    final apiCategory = category == null ? null : _mapCategory(category);
    final dtoPage = await _remoteDataSource.getRequests(
      page: page,
      limit: limit,
      propertyId: propertyId,
      status: apiStatus,
      priority: apiPriority,
      category: apiCategory,
    );

    return Page<MaintenanceRequest>(
      items: dtoPage.items.map((dto) => dto.toEntity()).toList(),
      page: dtoPage.page,
      limit: dtoPage.limit,
      hasMore: dtoPage.hasMore,
    );
  }

  @override
  Future<MaintenanceRequest> getRequestById(int id) async {
    final dto = await _remoteDataSource.getRequestById(id);
    return dto.toEntity();
  }

  @override
  Future<MaintenanceRequest> createRequest({
    required int propertyId,
    int? leaseId,
    required String category,
    required String priority,
    required String title,
    required String description,
    String? assignedTo,
    double? estimatedCost,
    DateTime? scheduledDate,
    String? notes,
  }) async {
    final data = <String, dynamic>{
      'property_id': propertyId,
      if (leaseId != null) 'lease_id': leaseId,
      'category': _mapCategory(category),
      'urgency': _mapUrgency(priority),
      'title': title,
      if (description.trim().isNotEmpty) 'description': description,
      if (notes != null && notes.trim().isNotEmpty)
        'availability_notes': notes.trim(),
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (scheduledDate != null)
        'scheduled_for': toApiUtcInstant(scheduledDate),
    };
    final trimmedAssignee = assignedTo?.trim();
    if (trimmedAssignee != null && trimmedAssignee.isNotEmpty) {
      final assignedId = int.tryParse(trimmedAssignee);
      if (assignedId != null) {
        data['assigned_agent_id'] = assignedId;
      } else {
        data['assigned_to'] = trimmedAssignee;
      }
    }

    final dto = await _remoteDataSource.createRequest(data);
    return dto.toEntity();
  }

  @override
  Future<MaintenanceRequest> updateRequest(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final payload = _normalizeUpdate(updates);
    final dto = await _remoteDataSource.updateRequest(id, payload);
    return dto.toEntity();
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    await _remoteDataSource.updateStatus(id, _mapStatus(status));
  }
}

String _mapUrgency(String raw) {
  final normalized = raw.trim().toLowerCase();
  if (normalized == 'urgent') return 'emergency';
  if (normalized == 'emergency') return 'emergency';
  if (normalized == 'high') return 'high';
  if (normalized == 'low') return 'low';
  return 'medium';
}

String _mapCategory(String raw) {
  final normalized = raw.trim().toLowerCase();
  switch (normalized) {
    case 'plumbing':
    case 'electrical':
    case 'hvac':
    case 'appliance':
    case 'structural':
    case 'cleaning':
    case 'other':
      return normalized;
    case 'pest':
    case 'pest_control':
    case 'pestcontrol':
      return 'pest_control';
    default:
      return 'other';
  }
}

String _mapStatus(String raw) {
  final normalized = raw.trim().toLowerCase();
  switch (normalized) {
    case 'open':
      return 'open';
    case 'in_review':
    case 'on_hold':
    case 'onhold':
      return 'in_review';
    case 'work_order_created':
    case 'in_progress':
    case 'inprogress':
      return 'work_order_created';
    case 'resolved':
    case 'completed':
      return 'resolved';
    case 'closed':
    case 'cancelled':
    case 'canceled':
      return 'closed';
    default:
      return normalized;
  }
}

Map<String, dynamic> _normalizeUpdate(Map<String, dynamic> updates) {
  final payload = <String, dynamic>{};

  for (final entry in updates.entries) {
    final key = entry.key;
    final value = entry.value;
    if (value == null) continue;

    switch (key) {
      case 'status':
      case 'request_status':
        payload['request_status'] = _mapStatus(value.toString());
        break;
      case 'priority':
      case 'urgency':
        payload['urgency'] = _mapUrgency(value.toString());
        break;
      case 'notes':
      case 'completion_notes':
      case 'availability_notes':
        final note = value.toString().trim();
        if (note.isNotEmpty) {
          payload['completion_notes'] = note;
        }
        break;
      case 'scheduled_date':
      case 'scheduled_for':
        final scheduled = _normalizeDate(value);
        if (scheduled != null) {
          payload['scheduled_for'] = scheduled;
        }
        break;
      case 'completed_date':
      case 'completed_at':
        final completed = _normalizeDate(value);
        if (completed != null) {
          payload['completed_at'] = completed;
        }
        break;
      case 'assigned_to':
      case 'assigned_agent_id':
        final parsed = int.tryParse(value.toString());
        if (parsed != null) {
          payload['assigned_agent_id'] = parsed;
        }
        break;
      case 'estimated_cost':
        final parsed = double.tryParse(value.toString());
        if (parsed != null) {
          payload['estimated_cost'] = parsed;
        }
        break;
      case 'actual_cost':
        final parsed = double.tryParse(value.toString());
        if (parsed != null) {
          payload['actual_cost'] = parsed;
        }
        break;
    }
  }

  return payload;
}

String? _normalizeDate(dynamic value) {
  if (value is DateTime) {
    return toApiUtcInstant(value);
  }
  final parsed = parseDateTime(value);
  return toApiUtcInstant(parsed);
}
