import 'dart:async';

import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/core/storage/app_preferences.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/inspections/data/inspections_repository.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
import 'package:estate_app/features/inspections/models/inspection_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InspectionListFilter {
  const InspectionListFilter({this.propertyId, this.leaseId});

  final int? propertyId;
  final int? leaseId;

  @override
  bool operator ==(Object other) =>
      other is InspectionListFilter &&
      other.propertyId == propertyId &&
      other.leaseId == leaseId;

  @override
  int get hashCode => Object.hash(propertyId, leaseId);
}

final inspectionsRepositoryProvider = Provider<InspectionsRepository>((ref) {
  ref.watch(accountScopeProvider);
  return InspectionsRepository(ref.read(apiClientProvider));
});

/// Every inspection that matches the filter (all pages).
final inspectionsListProvider =
    FutureProvider.family<List<Inspection>, InspectionListFilter>(
      (ref, filter) => ref
          .watch(inspectionsRepositoryProvider)
          .listAll(propertyId: filter.propertyId, leaseId: filter.leaseId),
    );

final inspectionDetailProvider = FutureProvider.family<Inspection, int>(
  (ref, id) => ref.watch(inspectionsRepositoryProvider).fetch(id),
);

// --- Inspection Checklist Templates ---

/// Pref key of the templates of one account. The templates live on the
/// device, so each account has its own list and one account never reads
/// another account's templates.
String inspectionTemplatesKey(int userId) => 'inspection_templates_$userId';

/// The key of the single global list that older builds wrote.
const _legacyTemplatesKey = 'inspection_templates';

/// Provider for the list of locally-stored inspection checklist templates of
/// the signed-in account. It is empty when nobody is signed in, and it is
/// rebuilt when the account changes.
final inspectionTemplatesProvider =
    StateNotifierProvider<
      InspectionTemplatesNotifier,
      List<InspectionTemplate>
    >((ref) {
      final userId = ref.watch(
        authControllerProvider.select((state) => state.user?.id),
      );
      return InspectionTemplatesNotifier(
        ref.read(appPreferencesProvider),
        userId,
      );
    });

class InspectionTemplatesNotifier
    extends StateNotifier<List<InspectionTemplate>> {
  InspectionTemplatesNotifier(this._prefs, int? userId)
    : _key = userId == null ? null : inspectionTemplatesKey(userId),
      super(const []) {
    _load();
  }

  final AppPreferences _prefs;

  /// Null when nobody is signed in: nothing is read or written.
  final String? _key;
  Future<void> _writeQueue = Future.value();

  void _load() {
    final key = _key;
    if (key == null) return;
    final own = _prefs.getString(key);
    if (own != null) {
      state = InspectionTemplate.decodeList(own);
      return;
    }
    // One-time move of the old global list to the first account that opens
    // it, then the global key is removed.
    final legacy = _prefs.getString(_legacyTemplatesKey);
    if (legacy == null) return;
    state = InspectionTemplate.decodeList(legacy);
    // The old copy goes only after the new one is written.
    unawaited(
      _persist().then((saved) async {
        if (saved) await _prefs.remove(_legacyTemplatesKey);
      }),
    );
  }

  Future<bool> _persist() async {
    final key = _key;
    if (key == null) return false;
    return _prefs.setString(key, InspectionTemplate.encodeList(state));
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
    _writeQueue = _writeQueue
        .then((_) async {
          mutate();
          await _persist();
        })
        .catchError((Object error, StackTrace stackTrace) {
          // Recover from prior queue errors so subsequent mutations are not
          // permanently blocked by a single persist failure.
          AppLogger.w(
            'InspectionTemplatesNotifier: persist failed',
            error: error,
            stackTrace: stackTrace,
          );
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
