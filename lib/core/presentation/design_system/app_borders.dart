import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:flutter/material.dart';

abstract final class AppBorders {
  static BorderSide outline(Color color, {double width = 1}) =>
      BorderSide(color: color, width: width);

  static OutlineInputBorder input(Color color, {Color? fillColor}) =>
      OutlineInputBorder(borderRadius: AppRadii.lg, borderSide: outline(color));
}
