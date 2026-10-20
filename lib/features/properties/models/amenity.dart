import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'amenity.freezed.dart';
part 'amenity.g.dart';

/// An entry of the amenity catalogue (`Amenity`). `id` is the value that goes
/// in `amenity_ids` on a property body.
@freezed
class Amenity with _$Amenity {
  const factory Amenity({
    @JsonKey(fromJson: parseInt) int? id,
    String? title,
    String? icon,
    String? category,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _Amenity;

  factory Amenity.fromJson(Map<String, dynamic> json) =>
      _$AmenityFromJson(json);
}
