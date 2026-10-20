import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_data.dart';
import 'package:flutter/material.dart';

/// Step 5: photos and floor plans. They upload when the property is saved.
class WizardMediaStep extends StatelessWidget {
  const WizardMediaStep({
    super.key,
    required this.data,
    required this.onAddImages,
    required this.onAddFloorPlans,
    required this.onRemoveImage,
    required this.onRemoveFloorPlan,
    this.isUploading = false,
  });

  static const int maxImages = 20;
  static const int maxFloorPlans = 10;

  final PropertyWizardData data;
  final VoidCallback onAddImages;
  final VoidCallback onAddFloorPlans;
  final ValueChanged<int> onRemoveImage;
  final ValueChanged<int> onRemoveFloorPlan;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MediaGroup(
          title: l10n.propertyPhotos,
          addLabel: l10n.propertyAddPhotos,
          items: data.images,
          max: maxImages,
          onAdd: isUploading ? null : onAddImages,
          onRemove: isUploading ? null : onRemoveImage,
        ),
        const SizedBox(height: AppSpacing.xl),
        _MediaGroup(
          title: l10n.propertyFloorPlans,
          addLabel: l10n.propertyAddFloorPlans,
          items: data.floorPlans,
          max: maxFloorPlans,
          onAdd: isUploading ? null : onAddFloorPlans,
          onRemove: isUploading ? null : onRemoveFloorPlan,
        ),
      ],
    );
  }
}

class _MediaGroup extends StatelessWidget {
  const _MediaGroup({
    required this.title,
    required this.addLabel,
    required this.items,
    required this.max,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final String addLabel;
  final List<String> items;
  final int max;
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final full = items.length >= max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: Text(title, style: context.text.titleMedium)),
            Text(
              l10n.propertyMediaCount(items.length, max),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (items.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => RiseIn(
              key: ValueKey(items[i]),
              child: _Thumb(
                url: items[i],
                label: l10n.propertyPhotoLabel(i + 1, items.length),
                onRemove: onRemove == null ? null : () => onRemove!(i),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        OutlinedButton.icon(
          onPressed: full ? null : onAdd,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: Text(addLabel),
        ),
        if (full)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l10n.propertyMediaLimit(max),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url, required this.label, this.onRemove});

  final String url;
  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(url);
    final fallback = ColoredBox(color: context.colors.surfaceContainerHigh);
    final image = uri != null && uri.scheme == 'file'
        ? Image.file(
            File.fromUri(uri),
            fit: BoxFit.cover,
            semanticLabel: label,
            errorBuilder: (_, _, _) => fallback,
          )
        : Image.network(
            url,
            fit: BoxFit.cover,
            semanticLabel: label,
            errorBuilder: (_, _, _) => fallback,
          );
    return Stack(
      fit: StackFit.expand,
      children: [
        // The tone under the photo shows until it decodes.
        ClipRRect(
          borderRadius: AppRadii.sm,
          child: ColoredBox(
            color: context.colors.surfaceContainerHigh,
            child: image,
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton.filled(
              tooltip: context.l10n.propertyRemoveMedia,
              onPressed: onRemove,
              iconSize: 18,
              style: IconButton.styleFrom(
                backgroundColor: context.colors.inverseSurface,
                foregroundColor: context.colors.onInverseSurface,
                minimumSize: const Size(32, 32),
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
      ],
    );
  }
}
