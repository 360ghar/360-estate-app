class LocationResult {
  final double lat;
  final double lng;
  final String name;

  const LocationResult({
    required this.lat,
    required this.lng,
    required this.name,
  });

  @override
  String toString() => 'LocationResult(lat: $lat, lng: $lng, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationResult &&
          other.lat == lat &&
          other.lng == lng &&
          other.name == name;

  @override
  int get hashCode => Object.hash(lat, lng, name);
}