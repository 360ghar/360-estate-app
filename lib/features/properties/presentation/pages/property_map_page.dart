import 'dart:math' as math;

import 'package:estate_app/core/map/map_controller.dart';
import 'package:estate_app/core/map/safe_map.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Properties as pins on the map. One pin centres the map on it; several
/// fit the view around them.
class PropertyMapPage extends StatefulWidget {
  const PropertyMapPage({
    super.key,
    required this.markers,
    this.initialLatitude = 20.5937,
    this.initialLongitude = 78.9629,
    this.initialZoom = 5,
  });

  final List<PropertyMarker> markers;
  final double initialLatitude;
  final double initialLongitude;
  final double initialZoom;

  @override
  State<PropertyMapPage> createState() => _PropertyMapPageState();
}

/// `#RRGGBB` for the map style, which takes colours as strings.
String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

class _PropertyMapPageState extends State<PropertyMapPage> {
  final EstateMapController _mapController = EstateMapController();
  bool _mapReady = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    _mapController.attach(controller);
    setState(() => _mapReady = true);
    await _addMarkers();
  }

  Future<void> _addMarkers() async {
    final controller = _mapController.controller;
    if (controller == null || !mounted) return;
    final colors = context.colors;
    final pin = _hex(colors.primary);
    final ring = _hex(context.palette.card);
    final ink = _hex(colors.onSurface);

    for (final marker in widget.markers) {
      final point = LatLng(marker.latitude, marker.longitude);
      await controller.addCircle(
        CircleOptions(
          geometry: point,
          circleRadius: 8,
          circleColor: pin,
          circleStrokeWidth: 2,
          circleStrokeColor: ring,
        ),
      );
      await controller.addSymbol(
        SymbolOptions(
          geometry: point,
          textField: marker.label,
          textSize: 12,
          textOffset: const Offset(0, 1.5),
          textAnchor: 'top',
          textColor: ink,
          textHaloColor: ring,
          textHaloWidth: 1,
        ),
      );
    }

    if (widget.markers.length >= 2) {
      final lats = widget.markers.map((m) => m.latitude);
      final lngs = widget.markers.map((m) => m.longitude);
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(lats.reduce(math.min), lngs.reduce(math.min)),
            northeast: LatLng(lats.reduce(math.max), lngs.reduce(math.max)),
          ),
          top: 80,
          left: 40,
          bottom: 40,
          right: 40,
        ),
      );
    } else if (widget.markers.length == 1) {
      // One pin cannot fit bounds: centre on it instead of the country view.
      final marker = widget.markers.first;
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(marker.latitude, marker.longitude),
          15,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.markers.length == 1
              ? widget.markers.first.label
              : l10n.propertiesCount(widget.markers.length),
        ),
      ),
      body: SafeMap(
        latitude: widget.initialLatitude,
        longitude: widget.initialLongitude,
        zoom: widget.initialZoom,
        mapBuilder: (context) => Stack(
          children: [
            MapLibreMap(
              styleString: kLibertyStyle,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.initialLatitude, widget.initialLongitude),
                zoom: widget.initialZoom,
              ),
              minMaxZoomPreference: MinMaxZoomPreference(
                kDefaultMinZoom,
                kDefaultMaxZoom,
              ),
              onMapCreated: _onMapCreated,
              attributionButtonMargins: const math.Point(8, 8),
            ),
            if (_mapReady)
              Positioned(
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      tooltip: l10n.mapZoomIn,
                      onPressed: _mapController.zoomIn,
                      icon: const Icon(Icons.add_rounded),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    IconButton.filledTonal(
                      tooltip: l10n.mapZoomOut,
                      onPressed: _mapController.zoomOut,
                      icon: const Icon(Icons.remove_rounded),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PropertyMarker {
  const PropertyMarker({
    required this.id,
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String label;
  final double latitude;
  final double longitude;
}
