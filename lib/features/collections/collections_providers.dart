import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/models/rent_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rentRepositoryProvider = Provider<RentRepository>((ref) {
  return RentRepository(
    ref.read(apiClientProvider),
    ref.read(cacheStoreProvider),
  );
});

final rentChargesProvider = FutureProvider.family<List<RentCharge>, String?>(
  (ref, status) => ref.read(rentRepositoryProvider).listCharges(status: status),
);

final rentChargesPagedProvider = StateNotifierProvider.family<
    PagedListController<RentCharge>,
    PagedListState<RentCharge>,
    String?>(
  (ref, status) => PagedListController<RentCharge>(
    fetchPage: ({required page, required limit}) {
      return ref.read(rentRepositoryProvider).listChargesPage(
            page: page,
            limit: limit,
            status: status,
          );
    },
  ),
);

final rentPaymentsProvider = FutureProvider<List<RentPayment>>(
  (ref) => ref.read(rentRepositoryProvider).listPayments(),
);
