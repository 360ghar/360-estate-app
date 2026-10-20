import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Type and occupancy, for the facts line.
List<String> _facts(BuildContext context, Property property) => [
  if (property.propertyType != null) property.propertyType!.text(context.l10n),
  property.isOccupied ? context.l10n.homeOccupied : context.l10n.homeVacant,
];

Widget? _status(BuildContext context, Property property) {
  final status = property.managementStatus;
  if (status == null) return null;
  return AppStatusBadge(
    label: status.text(context.l10n),
    type: status.statusType,
  );
}

/// One property in the list: photo or type glyph, name, address, facts,
/// rent and status.
class PropertyListCard extends StatelessWidget {
  const PropertyListCard({super.key, required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final rent = property.monthlyRent;
    return AppListCard(
      onTap: () => context.go('/properties/${property.id}'),
      leading: _Thumb(property: property),
      title: propertyName(property, context.l10n),
      subtitle: propertyPlace(property),
      facts: _facts(context, property),
      trailing: rent == null ? null : _Rent(amount: rent),
      status: _status(context, property),
    );
  }
}

class _Rent extends StatelessWidget {
  const _Rent({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        rupees(amount),
        style: AppTextStyles.currencyXSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: context.colors.onSurface,
        ),
      ),
      Text(
        context.l10n.propertiesPerMonth,
        style: context.text.labelSmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    ],
  );
}

/// The cover photo, or the bare glyph of the property type in the same
/// 48 dp slot so the names line up.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final glyph = SizedBox.square(
      dimension: 48,
      child: Align(
        alignment: Alignment.topCenter,
        child: Icon(
          property.propertyType?.icon ?? Icons.apartment_outlined,
          size: 26,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
    final url = property.coverImageUrl;
    return ExcludeSemantics(
      child: url == null
          ? glyph
          : ClipRRect(
              borderRadius: AppRadii.sm,
              child: Image.network(
                url,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => glyph,
              ),
            ),
    );
  }
}

/// One property in the grid: the photo, or the property type set large on a
/// quiet panel (never a fake picture), then name, place, rent and status.
class PropertyGridCard extends StatelessWidget {
  const PropertyGridCard({super.key, required this.property});

  /// The height of the photo panel against the card width.
  static const double panelRatio = 0.62;

  /// The height of the text under the panel, before text scaling, plus its
  /// fixed padding: name, place and the rent and status line.
  static double textHeight(TextScaler scaler) =>
      scaler.scale(22) + scaler.scale(20) + scaler.scale(22) + 36;

  final Property property;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final url = property.coverImageUrl;
    final rent = property.monthlyRent;
    final place = propertyPlace(property);

    final panel = ColoredBox(
      color: colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Align(
          alignment: Alignment.bottomLeft,
          // One word, scaled down to fit rather than broken across lines.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomLeft,
            child: Text(
              property.propertyType?.text(l10n) ?? '',
              maxLines: 1,
              style: context.text.headlineSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.go('/properties/${property.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ExcludeSemantics(
              child: url == null
                  ? panel
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => panel,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyName(property, l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                Text(
                  place ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    if (rent != null)
                      Expanded(
                        child: Text(
                          rupees(rent),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.currencyXSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    ?_status(context, property),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
