import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/inspections/data/inspections_repository.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:estate_app/features/inspections/models/inspection_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InspectionListFilter {
  const InspectionListFilter({this.propertyId, this.tenantId, this.status});

  final String? propertyId;
  final String? tenantId;
  final String? status;
}

final inspectionsRepositoryProvider = Provider<InspectionsRepository>((ref) {
  return InspectionsRepository(ref.read(apiClientProvider));
});

final inspectionsListProvider =
    FutureProvider.family<List<Inspection>, InspectionListFilter>(
  (ref, filter) => ref.read(inspectionsRepositoryProvider).list(
        propertyId: filter.propertyId,
        tenantId: filter.tenantId,
        status: filter.status,
      ),
);

final inspectionDetailProvider = FutureProvider.family<Inspection, String>(
  (ref, id) => ref.read(inspectionsRepositoryProvider).fetch(id),
);

// --- Inspection Checklist Templates ---

const _templatesPrefKey = 'inspection_templates';

/// Provider for the list of locally-stored inspection checklist templates.
final inspectionTemplatesProvider =
    StateNotifierProvider<InspectionTemplatesNotifier, List<InspectionTemplate>>(
  (ref) => InspectionTemplatesNotifier(ref.read(appPreferencesProvider)),
);

class InspectionTemplatesNotifier
    extends StateNotifier<List<InspectionTemplate>> {
  InspectionTemplatesNotifier(this._prefs)
      : super(const []) {
    _load();
  }

  final AppPreferences _prefs;
  Future<void> _writeQueue = Future.value();

  void _load() {
    final raw = _prefs.getString(_templatesPrefKey);
    state = InspectionTemplate.decodeList(raw);
  }

  Future<void> _persist() async {
    await _prefs.setString(
      _templatesPrefKey,
      InspectionTemplate.encodeList(state),
    );
  }

  Future<void> addTemplate(InspectionTemplate template) {
    return _enqueueMutation(() {
      state = [...state, template];
    });
  }

  Future<void> updateTemplate(InspectionTemplate template) {
    return _enqueueMutation(() {
      state = [
        for (final t in state)
          if (t.id == template.id) template else t,
      ];
    });
  }

  Future<void> deleteTemplate(String id) {
    return _enqueueMutation(() {
      state = state.where((t) => t.id != id).toList();
    });
  }

  Future<void> _enqueueMutation(void Function() mutate) {
    _writeQueue = _writeQueue.then((_) async {
      mutate();
      await _persist();
    });
    return _writeQueue;
  }
}

/// Default templates pre-seeded on first use.
final defaultInspectionTemplates = <InspectionTemplate>[
  InspectionTemplate.create(
    name: 'Move-in Checklist',
    description: 'Standard checklist for new tenant move-in inspection.',
    items: [
      'Front door lock and keys',
      'Living room walls and paint',
      'Kitchen appliances working',
      'Bathroom plumbing and fixtures',
      'Bedroom windows and locks',
      'Electrical outlets and switches',
      'Smoke detectors functional',
      'Flooring condition',
    ],
  ),
  InspectionTemplate.create(
    name: 'Annual Inspection',
    description: 'Yearly property condition assessment.',
    items: [
      'Roof and gutters',
      'Exterior paint and siding',
      'HVAC system serviced',
      'Water heater condition',
      'Plumbing leaks check',
      'Electrical panel inspection',
      'Pest control status',
      'Safety equipment check',
    ],
  ),
  InspectionTemplate.create(
    name: 'Move-out Checklist',
    description: 'Checklist for tenant move-out inspection.',
    items: [
      'All keys returned',
      'Walls and paint damage',
      'Appliances clean and working',
      'Carpets cleaned',
      'Bathroom condition',
      'Kitchen condition',
      'Repairs needed',
      'Deposit deduction items',
    ],
  ),
];
