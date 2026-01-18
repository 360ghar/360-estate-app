import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_item.freezed.dart';
part 'document_item.g.dart';

@freezed
class DocumentItem with _$DocumentItem {
  const factory DocumentItem({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? type,
    @JsonKey(name: 'file_name') String? fileName,
    @JsonKey(name: 'uploaded_at', fromJson: parseDateTime) DateTime? uploadedAt,
    String? url,
  }) = _DocumentItem;

  factory DocumentItem.fromJson(Map<String, dynamic> json) =>
      _$DocumentItemFromJson(json);
}
