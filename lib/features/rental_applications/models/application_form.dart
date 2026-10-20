import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_form.freezed.dart';
part 'application_form.g.dart';

/// One question of an application form (`CustomField`). `id` is a string key:
/// the answers are keyed by it.
@freezed
class ApplicationFormField with _$ApplicationFormField {
  const factory ApplicationFormField({
    String? id,
    String? label,
    @JsonKey(
      name: 'field_type',
      fromJson: ApplicationFieldType.fromJson,
      toJson: ApplicationFieldType.toJsonValue,
    )
    ApplicationFieldType? fieldType,
    @JsonKey(name: 'is_required') bool? isRequired,
    List<String>? options,
  }) = _ApplicationFormField;

  factory ApplicationFormField.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormFieldFromJson(json);
}

/// An application form. The owner routes send `RentalApplicationForm`. The
/// public route sends `PublicRentalApplicationForm`: it has the `slug`, the
/// title, the property labels and the questions, but no `id` and no
/// `is_active`.
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
    @JsonKey(name: 'application_fee_amount', fromJson: parseDouble)
    double? applicationFeeAmount,
    @JsonKey(name: 'custom_fields') List<ApplicationFormField>? fields,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
    @JsonKey(name: 'expires_at', fromJson: parseDateTime) DateTime? expiresAt,
  }) = _ApplicationForm;

  factory ApplicationForm.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormFromJson(json);
}

extension ApplicationFormFieldX on ApplicationFormField {
  /// The key the answer is stored under. The backend always sends an id; the
  /// label is a last resort for a malformed form.
  String get key => (id != null && id!.isNotEmpty) ? id! : (label ?? '');
}
