import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_form.freezed.dart';
part 'application_form.g.dart';

@freezed
class ApplicationFormField with _$ApplicationFormField {
  const factory ApplicationFormField({
    @JsonKey(fromJson: parseInt) int? id,
    String? label,
    @JsonKey(name: 'field_type') String? fieldType,
    @JsonKey(name: 'is_required') bool? isRequired,
    List<String>? options,
  }) = _ApplicationFormField;

  factory ApplicationFormField.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormFieldFromJson(json);
}

@freezed
class ApplicationForm with _$ApplicationForm {
  const factory ApplicationForm({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'property_address') String? propertyAddress,
    String? title,
    String? description,
    String? slug,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'custom_fields', fromJson: _fieldsFromJson)
    List<ApplicationFormField>? fields,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'expires_at', fromJson: parseDateTime) DateTime? expiresAt,
  }) = _ApplicationForm;

  factory ApplicationForm.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormFromJson(json);
}

List<ApplicationFormField> _fieldsFromJson(Object? value) {
  if (value is List) {
    return value
        .whereType<Map<String, dynamic>>()
        .map(ApplicationFormField.fromJson)
        .toList();
  }
  return const <ApplicationFormField>[];
}
