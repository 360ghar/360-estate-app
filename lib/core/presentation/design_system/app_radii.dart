import 'package:flutter/material.dart';

/// Corner radii. Buttons and inputs: md. Cards: lg. Sheet tops: xl.
abstract final class AppRadii {
  static const double xsValue = 4;
  static const double smValue = 8;
  static const double mdValue = 10;
  static const double lgValue = 14;
  static const double xlValue = 20;

  static const BorderRadius xs = BorderRadius.all(Radius.circular(xsValue));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));
}
