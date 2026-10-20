import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

/// A tenant of the owner's properties (`TenantSummary` in the list,
/// `TenantDetail` on the detail route). The key is `user_id`: the id of the
/// tenant's user account. Contact fields are what the owner typed on the lease
/// and are null when the owner typed none.
@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    @JsonKey(name: 'user_id', fromJson: parseInt) int? userId,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    String? email,
    @JsonKey(fromJson: TenantStatus.fromJson, toJson: TenantStatus.toJsonValue)
    TenantStatus? status,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'active_leases_count', fromJson: parseInt)
    int? activeLeasesCount,
    // Only the detail route sends the leases.
    List<Lease>? leases,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}

extension TenantX on Tenant {
  String get displayName {
    final name = fullName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Tenant';
  }

  /// Empty-safe initials derived from [fullName] (`''` when blank).
  String get initials {
    final source = (fullName ?? '').trim();
    if (source.isEmpty) return '';
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    final first = parts[0];
    return first.substring(0, first.length >= 2 ? 2 : 1).toUpperCase();
  }

  /// `TenantSummary` (the list) carries the status. `TenantDetail` does not,
  /// so the detail derives it the way the backend does: active while one of
  /// the tenant's leases occupies the property (active or expiring soon).
  TenantStatus? get effectiveStatus {
    final known = status;
    if (known != null) return known;
    final all = leases;
    if (all == null) return null;
    return all.any((lease) => lease.isOccupying)
        ? TenantStatus.active
        : TenantStatus.vacated;
  }

  String get statusLabel => switch (effectiveStatus) {
    TenantStatus.active => 'Active',
    TenantStatus.vacated => 'Vacated',
    null => 'Unknown',
  };
}
