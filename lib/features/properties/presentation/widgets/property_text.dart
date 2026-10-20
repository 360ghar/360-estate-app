import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

/// Property words in the app language. The model keeps English labels for
/// the backend contract; screens read these.
extension PropertyTypeText on PropertyType {
  String text(AppLocalizations l10n) => switch (this) {
    PropertyType.house => l10n.propertyTypeHouse,
    PropertyType.apartment => l10n.propertyTypeApartment,
    PropertyType.builderFloor => l10n.propertyTypeBuilderFloor,
    PropertyType.room => l10n.propertyTypeRoom,
    PropertyType.villa => l10n.propertyTypeVilla,
    PropertyType.plot => l10n.propertyTypePlot,
    PropertyType.condo => l10n.propertyTypeCondo,
    PropertyType.penthouse => l10n.propertyTypePenthouse,
    PropertyType.studio => l10n.propertyTypeStudio,
    PropertyType.loft => l10n.propertyTypeLoft,
    PropertyType.pg => l10n.propertyTypePg,
    PropertyType.flatmate => l10n.propertyTypeFlatmate,
    PropertyType.office => l10n.propertyTypeOffice,
    PropertyType.shop => l10n.propertyTypeShop,
    PropertyType.warehouse => l10n.propertyTypeWarehouse,
  };

  IconData get icon => switch (this) {
    PropertyType.pg ||
    PropertyType.room ||
    PropertyType.flatmate => Icons.bed_outlined,
    PropertyType.office ||
    PropertyType.shop ||
    PropertyType.warehouse => Icons.storefront_outlined,
    PropertyType.plot => Icons.landscape_outlined,
    PropertyType.house || PropertyType.villa => Icons.house_outlined,
    _ => Icons.apartment_outlined,
  };
}

extension ManagedPropertyStatusText on ManagedPropertyStatus {
  String text(AppLocalizations l10n) => switch (this) {
    ManagedPropertyStatus.draft => l10n.propertyStatusDraft,
    ManagedPropertyStatus.active => l10n.propertyStatusActive,
    ManagedPropertyStatus.archived => l10n.propertyStatusArchived,
  };

  AppStatusType get statusType => switch (this) {
    ManagedPropertyStatus.active => AppStatusType.success,
    ManagedPropertyStatus.draft ||
    ManagedPropertyStatus.archived => AppStatusType.neutral,
  };
}

/// The name a person gave the property, or else its address or city. A
/// title that is only a number or "PROP-12" is not a name.
String propertyName(Property property, AppLocalizations l10n) {
  final title = _clean(property.title);
  if (title != null && !_looksLikeId(title, property)) return title;
  return _clean(property.fullAddress) ??
      _clean(property.city) ??
      l10n.propertyFallbackName;
}

/// The line under the name: the address without repeats, or the city line
/// when the address already serves as the name.
String? propertyPlace(Property property) {
  final title = _clean(property.title);
  if (title != null && !_looksLikeId(title, property)) {
    final line = property.addressLine;
    return line == 'Address not set' ? null : line;
  }
  if (_clean(property.fullAddress) != null) return property.cityLine;
  if (_clean(property.city) != null) {
    final rest = [
      property.state,
      property.pincode,
    ].map(_clean).whereType<String>().toList();
    return rest.isEmpty ? null : rest.join(', ');
  }
  return null;
}

bool _looksLikeId(String value, Property property) =>
    value == property.id?.toString() ||
    RegExp(r'^[0-9]+$').hasMatch(value) ||
    RegExp(r'^(prop|property)[-_ ]?\d+$', caseSensitive: false).hasMatch(value);

String? _clean(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
