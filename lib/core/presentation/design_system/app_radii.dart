import 'package:flutter/material.dart';

/// B2B-appropriate border radius scale.
/// More subtle values for professional enterprise look.
abstract final class AppRadii {
  static const double xsValue = 4.0;
  static const double smValue = 6.0;
  static const double mdValue = 8.0;
  static const double lgValue = 12.0;
  static const double xlValue = 16.0;
  static const double pillValue = 999.0;

  static const BorderRadius xs = BorderRadius.all(Radius.circular(xsValue));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(pillValue));

  // Individual Radius for direct use
  static const Radius radiusXs = Radius.circular(xsValue);
  static const Radius radiusSm = Radius.circular(smValue);
  static const Radius radiusMd = Radius.circular(mdValue);
  static const Radius radiusLg = Radius.circular(lgValue);
  static const Radius radiusXl = Radius.circular(xlValue);
}

abstract final class AppRadius {
  static const BorderRadius xs = AppRadii.xs;
  static const BorderRadius sm = AppRadii.sm;
  static const BorderRadius md = AppRadii.md;
  static const BorderRadius lg = AppRadii.lg;
  static const BorderRadius xl = AppRadii.xl;
  static const BorderRadius pill = AppRadii.pill;
}
