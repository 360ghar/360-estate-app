import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The top of the overview: cover photo, the full name in the display face,
/// address, status and occupancy, the rent, and the one action that fits the
/// state. (The app bar repeats the name, shortened, for the other tabs.)
class PropertyDetailHeader extends StatelessWidget {
  const PropertyDetailHeader({
    super.key,
    required this.property,
    required this.isOccupied,
  });

  final Property property;

  /// An occupying lease (active or expiring soon) is on the property.
  final bool isOccupied;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cover = property.coverImageUrl;
    final place = propertyPlace(property);
    final status = property.managementStatus;
    final rent = property.monthlyRent;
    final deposit = property.securityDeposit;
    final muted = context.text.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (cover != null) ...[
            ClipRRect(
              borderRadius: AppRadii.lg,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  cover,
                  fit: BoxFit.cover,
                  semanticLabel: l10n.propertyPhotoLabel(1, 1),
                  // A photo that fails to load says so, instead of an
                  // empty block.
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: colors.surfaceContainerLow,
                    child: Center(
                      child: Icon(
                        Icons.hide_image_outlined,
                        size: 40,
                        color: colors.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Semantics(
            header: true,
            child: Text(
              propertyName(property, l10n),
              style: context.text.headlineMedium,
            ),
          ),
          if (place != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(place, style: muted),
          ],
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: [
              if (status != null)
                AppStatusBadge(
                  label: status.text(l10n),
                  type: status.statusType,
                ),
              AppStatusBadge(
                label: isOccupied ? l10n.homeOccupied : l10n.homeVacant,
                type: isOccupied ? AppStatusType.success : AppStatusType.info,
              ),
              if (property.propertyType != null)
                Padding(
                  // The same vertical rhythm as the status badges beside it.
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    property.propertyType!.text(l10n),
                    style: AppTextStyles.statusLabel.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          if (rent != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: rupees(rent),
                    style: AppTextStyles.currencyMedium.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  TextSpan(text: '  ${l10n.propertiesPerMonth}', style: muted),
                ],
              ),
            ),
            if (deposit != null)
              Text(l10n.propertyDepositValue(rupees(deposit)), style: muted),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: isOccupied
                ? FilledButton.icon(
                    onPressed: () => context.go('/collections/payments/new'),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.homeRecordPayment),
                  )
                : FilledButton.icon(
                    onPressed: () => context.go('/more/leases/new'),
                    icon: const Icon(Icons.description_outlined),
                    label: Text(l10n.propertyCreateLease),
                  ),
          ),
        ],
      ),
    );
  }
}
