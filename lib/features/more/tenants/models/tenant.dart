import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

/// Canonical Tenant model (UI-backed).
///
/// This freezed model under `more/tenants` is the owner used by the tenants
/// pages and record-payment flow. The parallel `tenants/domain/entities`
/// Tenant + `tenants/data/models` TenantDto are legacy clean-arch and are
/// deprecated pending the risky model merge — do NOT add new fields here
/// without checking the legacy pair.
@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    @JsonKey(fromJson: parseInt) int? id,
    String? name,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    String? email,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'room_number') String? roomNumber,
    String? status,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) =>
      _$TenantFromJson(json);
}

extension TenantX on Tenant {
  String get displayName => name ?? fullName ?? 'Tenant';

  /// Empty-safe initials derived from [name]/[fullName] (`''` when blank).
  ///
  /// Ported from the legacy `tenants/domain/entities` Tenant so the tenant
  /// list/detail/record-payment flows share one helper. Uses the raw
  /// name fields (not the `'Tenant'` [displayName] fallback) so a nameless
  /// record yields `''` instead of `'TE'`.
  String get initials {
    final source = (name ?? fullName ?? '').trim();
    if (source.isEmpty) return '';
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    final first = parts[0];
    return first.substring(0, first.length >= 2 ? 2 : 1).toUpperCase();
  }

  /// Preferred contact value (phone first, then email), if any.
  ///
  /// Ported from the legacy Tenant entity.
  String? get contactInfo => phone ?? email;
}
