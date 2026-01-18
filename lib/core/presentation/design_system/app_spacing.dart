import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
}

abstract final class AppInsets {
  static const EdgeInsets screen = EdgeInsets.all(AppSpacing.lg);
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.lg);
}
