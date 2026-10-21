/// Log hook for `lib/core/api/wire_enums.dart`.
///
/// Pure Dart on purpose. The model files that `build_runner` reads import the
/// wire enums, so this file must not import Flutter (the code generator cannot
/// resolve the Flutter libraries of the current SDK). `bootstrap.dart` sets
/// [wireLogSink] to the app logger.
void Function(String message) wireLogSink = _ignore;

void _ignore(String message) {}

/// Reports a wire value that no enum member matches. The value reads as null.
void logUnknownWireValue(String enumName, Object? value) {
  wireLogSink('Unknown $enumName wire value: $value');
}
