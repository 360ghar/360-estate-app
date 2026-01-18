import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/inspections/data/inspections_repository.dart';
import 'package:estate_app/features/inspections/models/inspection.dart';
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
