import 'package:estate_app/features/leases/domain/entities/lease.dart';

enum TenantStatus {
  active,
  inactive,
  ;

  static TenantStatus fromString(String value) {
    return TenantStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => TenantStatus.inactive,
    );
  }
}

final class Tenant {
  const Tenant({
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
  final TenantStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Lease? currentLease;
  final List<Lease> leaseHistory;

  String get displayName => fullName;

  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 2).toUpperCase();
  }

  bool get hasActiveLease => currentLease != null;

  String? get contactInfo => phone ?? email;
}
