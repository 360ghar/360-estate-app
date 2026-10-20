import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection.freezed.dart';
part 'inspection.g.dart';

/// One checklist line. The app keeps the lines in `rooms_data.items`, a free
/// JSON object on the backend.
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

/// An inspection checklist (`InspectionChecklist`). The backend has no title
/// and no status. The state comes from the two signature times.
@freezed
class Inspection with _$Inspection {
  const factory Inspection({
    @JsonKey(fromJson: parseInt) int? id,
    @JsonKey(name: 'property_id', fromJson: parseInt) int? propertyId,
    @JsonKey(name: 'lease_id', fromJson: parseInt) int? leaseId,
    @JsonKey(name: 'owner_id', fromJson: parseInt) int? ownerId,
    @JsonKey(
      name: 'inspection_type',
      fromJson: InspectionType.fromJson,
      toJson: InspectionType.toJsonValue,
    )
    InspectionType? inspectionType,
    @JsonKey(name: 'conducted_at', fromJson: parseDateTime)
    DateTime? conductedAt,
    @JsonKey(name: 'rooms_data') Map<String, dynamic>? roomsData,
    @JsonKey(name: 'overall_notes') String? overallNotes,
    @JsonKey(name: 'signed_by_tenant_at', fromJson: parseDateTime)
    DateTime? signedByTenantAt,
    @JsonKey(name: 'signed_by_owner_at', fromJson: parseDateTime)
    DateTime? signedByOwnerAt,
    @JsonKey(name: 'created_at', fromJson: parseDateTime) DateTime? createdAt,
  }) = _Inspection;

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}

enum InspectionSignState { open, signedByOwner, signedByTenant, signed }

extension InspectionX on Inspection {
  String get typeLabel => inspectionType?.label ?? 'Inspection';

  /// Derived from the two signature times.
  InspectionSignState get signState {
    final owner = signedByOwnerAt != null;
    final tenant = signedByTenantAt != null;
    if (owner && tenant) return InspectionSignState.signed;
    if (owner) return InspectionSignState.signedByOwner;
    if (tenant) return InspectionSignState.signedByTenant;
    return InspectionSignState.open;
  }

  /// The checklist lines stored in `rooms_data.items`.
  List<InspectionItem> get items {
    final raw = roomsData?['items'];
    if (raw is! List) return const [];
    return [
      for (final entry in raw)
        if (entry is Map<String, dynamic>) InspectionItem.fromJson(entry),
    ];
  }
}

extension InspectionTypeLabel on InspectionType {
  String get label => switch (this) {
    InspectionType.moveIn => 'Move-in',
    InspectionType.moveOut => 'Move-out',
    InspectionType.routine => 'Routine',
  };
}

extension InspectionSignStateLabel on InspectionSignState {
  String get label => switch (this) {
    InspectionSignState.open => 'Open',
    InspectionSignState.signedByOwner => 'Signed by owner',
    InspectionSignState.signedByTenant => 'Signed by tenant',
    InspectionSignState.signed => 'Signed',
  };
}
