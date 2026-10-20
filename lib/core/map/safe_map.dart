import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

bool get mapLibreSupported {
  if (kIsWeb) return true;
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return true;
    default:
      return false;
  }
}

class SafeMap extends StatelessWidget {
  const SafeMap({
    required this.mapBuilder,
    required this.latitude,
    required this.longitude,
    super.key,
    this.zoom = 15,
  });

  final WidgetBuilder mapBuilder;
  final double latitude;
  final double longitude;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    if (mapLibreSupported) {
      return mapBuilder(context);
    }
    return _UnsupportedMapPlaceholder(
      latitude: latitude,
      longitude: longitude,
      zoom: zoom,
    );
  }
}

class _UnsupportedMapPlaceholder extends StatelessWidget {
  const _UnsupportedMapPlaceholder({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });

  final double latitude;
  final double longitude;
  final double zoom;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHigh,
      borderRadius: AppRadii.lg,
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.map_outlined,
                size: 40,
                color: context.colors.outline,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.mapUnsupported,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: _openInBrowser,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(context.l10n.mapOpenInBrowser),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _openInBrowser() async {
    final z = zoom.round();
    final uri = Uri.parse(
      'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude'
      '#map=$z/$latitude/$longitude',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
