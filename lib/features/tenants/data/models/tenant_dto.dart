import 'package:estate_app/features/leases/data/models/lease_dto.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';

final class TenantDto {
  const TenantDto({
    required this.id,
    required this.userId,
    required this.fullName,
    this.email,
    this.phone,
    this.emergencyContact,
    this.emergencyPhone,
    this.governmentIdType,
    this.governmentIdNumber,
    this.notes,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.currentLease,
    this.leaseHistory = const [],
  });

  factory TenantDto.fromJson(Map<String, dynamic> json) {
    final currentLeaseJson = json['current_lease'] ?? json['currentLease'];
    final leaseHistoryJson = json['lease_history'] ?? json['leaseHistory'];

    return TenantDto(
      id: json['id'] as int,
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      fullName: json['full_name'] as String? ??
          json['fullName'] as String? ??
          json['name'] as String? ??
          '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      emergencyContact: json['emergency_contact'] as String? ??
          json['emergencyContact'] as String?,
      emergencyPhone: json['emergency_phone'] as String? ??
          json['emergencyPhone'] as String?,
      governmentIdType: json['government_id_type'] as String? ??
          json['governmentIdType'] as String?,
      governmentIdNumber: json['government_id_number'] as String? ??
          json['governmentIdNumber'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
      currentLease: currentLeaseJson != null
          ? LeaseDto.fromJson(currentLeaseJson as Map<String, dynamic>)
          : null,
      leaseHistory: leaseHistoryJson != null
          ? (leaseHistoryJson as List<dynamic>)
              .map((e) => LeaseDto.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  final int id;
  final String userId;
  final String fullName;
  final String? email;
  final String? phone;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? governmentIdType;
  final String? governmentIdNumber;
  final String? notes;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final LeaseDto? currentLease;
  final List<LeaseDto> leaseHistory;

  Tenant toEntity() {
    return Tenant(
      id: id,
      userId: userId,
      fullName: fullName,
      email: email,
      phone: phone,
      emergencyContact: emergencyContact,
      emergencyPhone: emergencyPhone,
      governmentIdType: governmentIdType,
      governmentIdNumber: governmentIdNumber,
      notes: notes,
      status: TenantStatus.fromString(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
      currentLease: currentLease?.toEntity(),
      leaseHistory: leaseHistory.map((e) => e.toEntity()).toList(),
    );
  }
}
