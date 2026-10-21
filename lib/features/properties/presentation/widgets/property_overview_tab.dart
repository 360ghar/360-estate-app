import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_detail_header.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_text.dart';
import 'package:flutter/material.dart';

/// The header, then photos, rent terms, specifications, amenities, floor
/// plans and the description.
class PropertyOverviewTab extends StatelessWidget {
  const PropertyOverviewTab({
    super.key,
    required this.detail,
    required this.onRefresh,
  });

  final PropertyDetail detail;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = detail.property;
    final photos = p.imageUrls;
    final plans = p.floorPlanUrls;
    final amenities = p.amenityTitles;
    final description = p.description?.trim() ?? '';
    final terms = [
      if (p.monthlyRent != null)
        FactRow(l10n.propertyMonthlyRent, rupees(p.monthlyRent!)),
      if (p.securityDeposit != null)
        FactRow(l10n.propertySecurityDeposit, rupees(p.securityDeposit!)),
      if (p.paymentDueDay != null)
        FactRow(
          l10n.propertyDueDayNewLeases,
          l10n.propertyDueDayValue(p.paymentDueDay!),
        ),
      if (p.gracePeriodDays != null)
        FactRow(
          l10n.propertyGraceNewLeases,
          l10n.propertyDays(p.gracePeriodDays!),
        ),
    ];
    final specs = [
      if (p.propertyType != null)
        FactRow(l10n.propertyTypeField, p.propertyType!.text(l10n)),
      if (p.areaSqft != null)
        FactRow(
          l10n.propertyFloorArea,
          l10n.propertyAreaValue(p.areaSqft!.toStringAsFixed(0)),
        ),
      if (p.bedrooms != null) FactRow(l10n.propertyBedrooms, '${p.bedrooms}'),
      if (p.bathrooms != null)
        FactRow(l10n.propertyBathrooms, '${p.bathrooms}'),
      if (p.balconies != null)
        FactRow(l10n.propertyBalconies, '${p.balconies}'),
      if (p.ageOfProperty != null)
        FactRow(l10n.propertyAge, l10n.propertyYears(p.ageOfProperty!)),
    ];

    final sections = <Widget>[
      PropertyDetailHeader(
        property: p,
        isOccupied: detail.activeLease != null || p.isOccupied,
      ),
      if (photos.length > 1)
        AppSectionCard(
          title: l10n.propertyPhotos,
          child: _PhotoStrip(urls: photos),
        ),
      if (terms.isNotEmpty)
        AppSectionCard(title: l10n.propertyRentTerms, children: terms),
      if (specs.isNotEmpty)
        AppSectionCard(title: l10n.propertySpecs, children: specs),
      if (amenities.isNotEmpty)
        AppSectionCard(
          title: l10n.propertyAmenities,
          child: _Amenities(names: amenities),
        ),
      if (plans.isNotEmpty)
        AppSectionCard(
          title: l10n.propertyFloorPlans,
          child: _PhotoStrip(urls: plans),
        ),
      if (description.isNotEmpty)
        AppSectionCard(
          title: l10n.propertyDescription,
          child: Text(description, style: context.text.bodyMedium),
        ),
    ];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) => sections[i],
      ),
    );
  }
}

/// A label and its value on one line; the value wraps under the label when
/// the line is too short.
class FactRow extends StatelessWidget {
  const FactRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: AppSpacing.md,
      children: [
        Text(
          label,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: urls.length,
      separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, i) => ClipRRect(
        borderRadius: AppRadii.md,
        child: Image.network(
          urls[i],
          width: 240,
          height: 160,
          fit: BoxFit.cover,
          semanticLabel: context.l10n.propertyPhotoLabel(i + 1, urls.length),
          errorBuilder: (context, _, _) => Container(
            width: 240,
            color: context.colors.surfaceContainerLow,
            alignment: Alignment.center,
            child: Icon(
              Icons.hide_image_outlined,
              size: 32,
              color: context.colors.outline,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Amenity names in two loose columns, each with a bare tick.
class _Amenities extends StatelessWidget {
  const _Amenities({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Wrap(
      runSpacing: AppSpacing.sm,
      children: [
        for (final name in names)
          SizedBox(
            width: constraints.maxWidth / 2,
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: context.palette.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(name, style: context.text.bodyMedium)),
              ],
            ),
          ),
      ],
    ),
  );
}
