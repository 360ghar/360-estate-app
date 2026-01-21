import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection.freezed.dart';
part 'inspection.g.dart';

@freezed
class InspectionItem with _$InspectionItem {
  const factory InspectionItem({
    String? title,
    String? status,
    String? notes,
    @JsonKey(name: 'is_required') bool? isRequired,
  }) = _InspectionItem;

  factory InspectionItem.fromJson(Map<String, dynamic> json) =>
      _$InspectionItemFromJson(json);
}

@freezed
class Inspection with _$Inspection {
  const factory Inspection({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'tenant_id', fromJson: parseInt) int? tenantId,
    @JsonKey(name: 'tenant_name') String? tenantName,
    String? title,
    String? status,
    @JsonKey(name: 'scheduled_at', fromJson: parseDateTime)
    DateTime? scheduledAt,
    @JsonKey(name: 'signed_at', fromJson: parseDateTime) DateTime? signedAt,
    List<InspectionItem>? items,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: parseDateTime) DateTime? updatedAt,
  }) = _Inspection;

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}

extension InspectionX on Inspection {
  String get displayName {
    final property = propertyName?.trim();
    if (property != null && property.isNotEmpty) return property;
    return title?.trim().isNotEmpty == true ? title!.trim() : 'Inspection';
  }
}
