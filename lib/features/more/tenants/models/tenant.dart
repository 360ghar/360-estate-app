import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

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
}
