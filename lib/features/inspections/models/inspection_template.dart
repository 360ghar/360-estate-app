import 'dart:convert';

/// A reusable inspection checklist template (e.g. "Move-in checklist",
/// "Annual inspection"). Templates are stored locally and used to
/// pre-populate inspection items when creating a new inspection.
class InspectionTemplate {
  InspectionTemplate({
    required this.id,
    required this.name,
    required this.items,
    this.description,
  });

  static int _counter = 0;

  /// Creates a new template with a unique ID.
  factory InspectionTemplate.create({
    required String name,
    required List<String> items,
    String? description,
  }) {
    _counter++;
    return InspectionTemplate(
      id: '${DateTime.now().millisecondsSinceEpoch}_$_counter',
      name: name,
      items: items,
      description: description,
    );
  }

  final String id;
  final String name;
  final List<String> items;
  final String? description;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items,
        if (description != null) 'description': description,
      };

  factory InspectionTemplate.fromJson(Map<String, dynamic> json) {
    return InspectionTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List).cast<String>(),
      description: json['description'] as String?,
    );
  }

  String encode() => jsonEncode(toJson());

  static List<InspectionTemplate> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      final result = <InspectionTemplate>[];
      for (final entry in list) {
        if (entry is! Map<String, dynamic>) continue;
        try {
          result.add(InspectionTemplate.fromJson(entry));
        } catch (_) {
          // Skip invalid entries instead of losing the entire list.
        }
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  static String encodeList(List<InspectionTemplate> templates) {
    return jsonEncode(templates.map((t) => t.toJson()).toList());
  }
}
