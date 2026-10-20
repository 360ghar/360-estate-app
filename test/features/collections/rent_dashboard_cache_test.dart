import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/owner_scope.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/home/data/dashboard_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../contract/fixture_api.dart';

/// Home KPIs such as `outstanding_rent_total` come from the dashboard cache
/// (2 minute TTL). A payment or a charge run changes them, so both calls must
/// drop that cache and let Home read the backend again.
void main() {
  final routes = loadRoutes();

  ({RentRepository rent, DashboardRepository dashboard, FixtureAdapter http})
  build() {
    final http = FixtureAdapter(routes);
    final client = fixtureApiClient(
      http,
      ownerScope: () => OwnerScope.forRole(UserRole.user, null),
    );
    final cache = CacheStore();
    return (
      rent: RentRepository(client, cache),
      dashboard: DashboardRepository(client, cache),
      http: http,
    );
  }

  int overviewReads(FixtureAdapter http) => http.requests
      .where((r) => r.path.endsWith('/pm/dashboard/overview'))
      .length;

  for (final write in <String, Future<void> Function(RentRepository)>{
    'recordPayment': (rent) => rent.recordPayment(
      const RentPaymentRequest(chargeId: 1, amountPaid: 100),
    ),
    'generateCharges': (rent) => rent.generateCharges(),
  }.entries) {
    test('${write.key} makes the dashboard read the backend again', () async {
      final app = build();
      await app.dashboard.fetchOverview();
      await app.dashboard.fetchOverview();
      expect(overviewReads(app.http), 1, reason: 'second read is cached');

      await write.value(app.rent);
      await app.dashboard.fetchOverview();
      expect(overviewReads(app.http), 2);
    });
  }
}
