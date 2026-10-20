import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Any button (filled, tonal, text, icon-and-label) that shows [label]. Tests
/// find actions by what they say, not by how they are styled.
Finder findButton(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
);
