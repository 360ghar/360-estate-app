import 'dart:math' as math;

import 'package:maplibre_gl/maplibre_gl.dart';

const String kLibertyStyle =
    'https://tiles.openfreemap.org/styles/liberty';

const double kDefaultInitialZoom = 12.0;
const double kDefaultMinZoom = 3.0;
const double kDefaultMaxZoom = 18.0;

class EstateMapController {
  MapLibreMapController? _controller;

  MapLibreMapController? get controller => _controller;

  bool get isAttached => _controller != null;

  LatLng? get center => _controller?.cameraPosition?.target;

  double get zoom =>
      _controller?.cameraPosition?.zoom ?? kDefaultInitialZoom;

  void attach(MapLibreMapController controller) {
    _controller = controller;
  }

  Future<void> move(LatLng center, double zoom) async {
    final controller = _controller;
    if (controller == null) return;
    await controller.moveCamera(
      CameraUpdate.newLatLngZoom(center, zoom),
    );
  }

  Future<void> animateTo(
    LatLng center, {
    double? zoom,
    Duration duration = const Duration(milliseconds: 400),
  }) async {
    final controller = _controller;
    if (controller == null) return;
    final targetZoom = zoom ?? this.zoom;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(center, targetZoom),
      duration: duration,
    );
  }

  Future<void> zoomIn() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> zoomOut() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.zoomOut());
  }

  Future<math.Point<num>?> toScreenLocation(LatLng latLng) async {
    final controller = _controller;
    if (controller == null) return null;
    return controller.toScreenLocation(latLng);
  }

  void dispose() {
    _controller = null;
  }
}