import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rentRepositoryProvider = Provider<RentRepository>((ref) {
  ref.watch(accountScopeProvider);
  return RentRepository(
    ref.read(apiClientProvider),
    ref.read(cacheStoreProvider),
  );
});

/// Every charge of the account (all pages), for totals and the charge picker.
final allRentChargesProvider = FutureProvider<List<RentChargeWithTotals>>(
  (ref) => ref.watch(rentRepositoryProvider).listAllCharges(),
);

/// The charges that still owe money: due, partly paid or overdue. The record
/// payment screen picks one of them.
final unpaidRentChargesProvider = FutureProvider<List<RentChargeWithTotals>>((
  ref,
) async {
  final all = await ref.watch(allRentChargesProvider.future);
  return [
    for (final row in all)
      if ((row.status == RentChargeStatus.pending ||
              row.status == RentChargeStatus.partial ||
              row.status == RentChargeStatus.overdue) &&
          row.balance > 0)
        row,
  ];
});

/// A list that scrolls, one status per tab.
final rentChargesPagedProvider =
    StateNotifierProvider.family<
      PagedListController<RentChargeWithTotals>,
      PagedListState<RentChargeWithTotals>,
      RentChargeStatus
    >((ref, status) {
      final repository = ref.watch(rentRepositoryProvider);
      return PagedListController<RentChargeWithTotals>(
        fetchPage: ({required cursor, required limit}) {
          return repository.listChargesPage(
            cursor: cursor,
            limit: limit,
            status: status,
          );
        },
      );
    });

/// Property-scoped variant. Used by the property-detail Rent tab: the backend
/// does the filtering, and every page is read.
final rentChargesForPropertyProvider =
    FutureProvider.family<List<RentChargeWithTotals>, int>((ref, propertyId) {
      return ref
          .watch(rentRepositoryProvider)
          .listAllCharges(propertyId: propertyId);
    });
