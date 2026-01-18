import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_request.freezed.dart';
part 'maintenance_request.g.dart';

@freezed
class MaintenanceRequest with _$MaintenanceRequest {
  const factory MaintenanceRequest({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_name') String? tenantName,
    @JsonKey(fromJson: parseStringList) List<String>? attachments,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  }) = _MaintenanceRequest;

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceRequestFromJson(json);
}
