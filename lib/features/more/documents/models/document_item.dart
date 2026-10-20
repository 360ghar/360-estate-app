import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_item.freezed.dart';
part 'document_item.g.dart';

/// A PM document (`Document`). `file_url` is per viewer: it is null when the
/// caller may not open the file. Documents are private, so open one through
/// the signed download route (`GET /pm/documents/{id}/download`).
@freezed
class DocumentItem with _$DocumentItem {
  const factory DocumentItem({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(
      name: 'document_type',
      fromJson: DocumentType.fromJson,
      toJson: DocumentType.toJsonValue,
    )
    DocumentType? documentType,
    String? title,
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'file_size', fromJson: parseInt) int? fileSize,
    @JsonKey(name: 'shared_with_tenant') bool? sharedWithTenant,
    @JsonKey(name: 'shared_with_agent') bool? sharedWithAgent,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  }) = _DocumentItem;

  factory DocumentItem.fromJson(Map<String, dynamic> json) =>
      _$DocumentItemFromJson(json);
}
