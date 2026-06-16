import 'dart:math' as math;

import 'package:estate_app/core/map/map_controller.dart';
import 'package:estate_app/core/map/safe_map.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

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
    if (controller == null) return;

    for (final marker in widget.markers) {
      await controller.addCircle(
        CircleOptions(
          geometry: LatLng(marker.latitude, marker.longitude),
          circleRadius: 8,
          circleColor: '#1E3A5F',
          circleStrokeWidth: 2,
          circleStrokeColor: '#FFFFFF',
        ),
      );
      await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(marker.latitude, marker.longitude),
          textField: marker.label,
          textSize: 12,
          textOffset: const Offset(0, 1.5),
          textAnchor: 'top',
          textColor: '#111827',
          textHaloColor: '#FFFFFF',
          textHaloWidth: 1,
        ),
      );
    }

    if (widget.markers.length >= 2) {
      final lats = widget.markers.map((m) => m.latitude).toList();
      final lngs = widget.markers.map((m) => m.longitude).toList();
      final minLat = lats.reduce((a, b) => a < b ? a : b);
      final maxLat = lats.reduce((a, b) => a > b ? a : b);
      final minLng = lngs.reduce((a, b) => a < b ? a : b);
      final maxLng = lngs.reduce((a, b) => a > b ? a : b);

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          top: 80,
          left: 40,
          bottom: 40,
          right: 40,
        ),
      );
    } else if (widget.markers.length == 1) {
      // A single marker won't fit-to-bounds, so center the camera on it
      // explicitly; otherwise it stays at the far-away initial view.
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
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          widget.markers.length == 1
              ? widget.markers.first.label
              : '${widget.markers.length} Properties',
        ),
      ),
      body: SafeMap(
        latitude: widget.initialLatitude,
        longitude: widget.initialLongitude,
        zoom: widget.initialZoom,
        mapBuilder: (context) {
          return Stack(
            children: [
              MapLibreMap(
                styleString: kLibertyStyle,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.initialLatitude,
                    widget.initialLongitude,
                  ),
                  zoom: widget.initialZoom,
                ),
                minMaxZoomPreference: MinMaxZoomPreference(
                  kDefaultMinZoom,
                  kDefaultMaxZoom,
                ),
                onMapCreated: _onMapCreated,
                attributionButtonMargins: const math.Point(8, 8),
              ),
              if (_mapReady) ...[
                Positioned(
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ZoomButton(
                        icon: Icons.add,
                        onPressed: () => _mapController.zoomIn(),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _ZoomButton(
                        icon: Icons.remove,
                        onPressed: () => _mapController.zoomOut(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 40,
      height: 40,
      child: FloatingActionButton.small(
        heroTag: null,
        onPressed: onPressed,
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        foregroundColor:
            isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 2,
        child: Icon(icon, size: 20),
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