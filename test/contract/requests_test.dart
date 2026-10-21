import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/owner_scope.dart';
import 'package:estate_app/core/services/cache_store.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/core/storage/auth_token_storage.dart';
import 'package:estate_app/core/storage/secure_kv_store.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart';
import 'package:estate_app/features/auth/models/auth_method.dart';
import 'package:estate_app/features/collections/data/rent_repository.dart';
import 'package:estate_app/features/home/data/dashboard_repository.dart';
import 'package:estate_app/features/inspections/data/inspections_repository.dart';
import 'package:estate_app/features/leases/data/leases_repository.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/maintenance/data/datasources/maintenance_remote_data_source.dart';
import 'package:estate_app/features/maintenance/data/repositories/maintenance_repository_impl.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/more/documents/data/documents_repository.dart';
import 'package:estate_app/features/more/expenses/data/expenses_repository.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/tenants/data/tenants_repository.dart';
import 'package:estate_app/features/notifications/data/notifications_repository.dart';
import 'package:estate_app/features/properties/data/amenities_repository.dart';
import 'package:estate_app/features/properties/data/properties_repository.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_data.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixture_api.dart';

/// Runs every repository method of the app against a recording HTTP adapter and
/// checks each real request (method, path, query, body) against the route
/// contract in `test/fixtures/api/routes.json`. The contract is written by
/// `tool/api_fixtures.py` from the backend's `docs/openapi.json`.
///
/// A request fails the test when the route does not exist, a query key or body
/// key is not declared (the backend answers 422), a required body key is
/// missing, an enum value is not a wire value, or `limit` is above the maximum.
/// An agent must send `owner_id` on every route that declares it, and an owner
/// must never send it.

const _agentOwnerId = 7;

XFile _file(String name, String mime) => XFile.fromData(
  Uint8List.fromList([1, 2, 3]),
  name: name,
  mimeType: mime,
  length: 3,
);

/// Calls every repository method of the app once. A failure after the request
/// went out (a reply the app cannot parse) does not matter here: the request is
/// what is checked, and the fixtures tests check the replies.
Future<void> _exerciseApp(ApiClient client) async {
  Future<void> call(Future<Object?> Function() action) async {
    try {
      await action();
    } on Object {
      // Parsing is checked elsewhere.
    }
  }

  final cache = CacheStore();
  final uploads = FileUploadService(client);

  final properties = PropertiesRepositoryImpl(client, cache);
  await call(
    () => properties.listPage(
      cursor: 'abc',
      limit: 20,
      occupancy: OccupancyFilter.occupied,
      q: 'sector',
    ),
  );
  await call(properties.listAll);
  await call(() => properties.fetch('1'));
  final wizard = PropertyWizardData()
    ..name = 'Green Villa'
    ..type = PropertyType.apartment
    ..address = '12 Park Road'
    ..city = 'Pune'
    ..state = 'MH'
    ..pincode = '411001'
    ..latitude = 18.5
    ..longitude = 73.8
    ..areaSqft = 900
    ..bedrooms = 2
    ..bathrooms = 2
    ..balconies = 1
    ..ageOfProperty = 3
    ..amenityIds = {1, 2}
    ..monthlyRent = 25000
    ..securityDeposit = 50000
    ..paymentDueDay = 5
    ..gracePeriodDays = 3;
  await call(() => properties.create(wizard.toCreateBody()));
  wizard.markSaved();
  wizard
    ..name = 'Green Villa 2'
    ..status = ManagedPropertyStatus.archived
    ..monthlyRent = 26000
    ..latitude = null
    ..longitude = null;
  await call(() => properties.update('1', wizard.toPatchBody()));
  await call(
    () => properties.update(
      '1',
      wizard.mediaPatch(
        photoUrls: ['https://cdn.test/a.jpg'],
        floorPlanUrls: ['https://cdn.test/f.jpg'],
      ),
    ),
  );
  await call(
    () => AmenitiesRepository(client).listPage(cursor: 'c', limit: 100),
  );

  final leases = LeasesRepositoryImpl(client, uploads);
  await call(
    () => leases.listPage(
      cursor: 'abc',
      limit: 20,
      propertyId: 1,
      tenantUserId: 3,
      status: LeaseStatus.expiringSoon,
    ),
  );
  await call(() => leases.listAll(status: LeaseStatus.active));
  await call(() => leases.fetch('31'));
  await call(
    () => leases.create(
      LeaseCreateRequest(
        propertyId: 1,
        startDate: DateTime(2026, 11),
        endDate: DateTime(2027, 10, 31),
        monthlyRent: 30000,
        securityDeposit: 60000,
        tenantUserId: 52,
        tenantName: 'Meera',
        tenantPhone: '+919999999999',
        tenantEmail: 'm@example.com',
        status: LeaseStatus.pendingSignature,
        paymentDueDay: 5,
        gracePeriodDays: 3,
        lateFeeAmount: 500,
        lateFeePercentage: 2,
        specialClauses: 'No pets',
      ),
    ),
  );
  await call(
    () => leases.uploadSigned('31', _file('lease.pdf', 'application/pdf')),
  );
  await call(
    () => leases.renew(
      '31',
      LeaseRenewRequest(
        startDate: DateTime(2027, 4),
        endDate: DateTime(2028, 3, 31),
        monthlyRent: 33000,
        securityDeposit: 66000,
        makeActive: true,
      ),
    ),
  );
  await call(
    () => leases.terminate(
      '31',
      LeaseTerminateRequest(
        reason: 'Moved out',
        terminationDate: DateTime(2026, 9, 15),
      ),
    ),
  );

  final rent = RentRepository(client, cache);
  await call(
    () => rent.listChargesPage(
      cursor: 'abc',
      limit: 20,
      status: RentChargeStatus.overdue,
      propertyId: 1,
      leaseId: 2,
    ),
  );
  await call(rent.listAllCharges);
  await call(rent.generateCharges);
  await call(
    () => rent.recordPayment(
      RentPaymentRequest(
        chargeId: 11,
        amountPaid: 5000,
        paidAt: DateTime(2026, 10, 5, 10),
        paymentMethod: PaymentMethod.upi,
        reference: 'UTR123',
        notes: 'Paid in full',
      ),
    ),
  );

  final maintenance = MaintenanceRepositoryImpl(
    ApiMaintenanceRemoteDataSource(client),
  );
  await call(
    () => maintenance.getRequests(
      cursor: 'abc',
      limit: 20,
      propertyId: 1,
      status: MaintenanceRequestStatus.open,
    ),
  );
  await call(() => maintenance.getAllRequests(propertyId: 1));
  await call(
    () => maintenance.createRequest(
      propertyId: 1,
      category: MaintenanceCategory.plumbing,
      urgency: MaintenanceUrgency.high,
      title: 'Leak',
      description: 'Kitchen tap',
      leaseId: 31,
      estimatedCost: 1500,
      scheduledFor: DateTime(2026, 10, 20, 9),
      assignedAgentId: 4,
      availabilityNotes: 'After 5pm',
    ),
  );
  await call(
    () => maintenance.updateRequest(
      9,
      MaintenanceUpdate(
        status: MaintenanceRequestStatus.resolved,
        urgency: MaintenanceUrgency.low,
        completionNotes: 'Fixed',
        assignedAgentId: 4,
        estimatedCost: 1500,
        actualCost: 1400,
        scheduledFor: DateTime(2026, 10, 20, 9),
      ),
    ),
  );

  final inspections = InspectionsRepository(client);
  await call(
    () => inspections.listPage(
      cursor: 'abc',
      limit: 20,
      propertyId: 1,
      leaseId: 31,
    ),
  );
  await call(() => inspections.listAll(propertyId: 1));
  await call(() => inspections.fetch(5));
  await call(
    () => inspections.create(
      InspectionCreateRequest(
        leaseId: 31,
        inspectionType: InspectionType.moveIn,
        conductedAt: DateTime(2026, 10, 1, 10),
        overallNotes: 'Clean',
        items: const ['Door', 'Windows'],
      ),
    ),
  );
  await call(() => inspections.sign(5));

  final expenses = ExpensesRepository(client);
  await call(() => expenses.listPage(cursor: 'abc', limit: 20, propertyId: 1));
  await call(() => expenses.listAll(propertyId: 1));
  final expense = ExpensePayload(
    propertyId: 1,
    category: ExpenseCategory.repairs,
    amount: 1200,
    date: DateTime(2026, 10, 2),
    title: 'Pipe',
    notes: 'Plumber',
  );
  await call(() => expenses.create(expense));
  await call(() => expenses.update(3, expense));

  final documents = DocumentsRepository(client, uploads);
  await call(
    () => documents.listPage(
      cursor: 'abc',
      limit: 20,
      propertyId: 1,
      leaseId: 31,
    ),
  );
  await call(() => documents.listAll(propertyId: 1));
  await call(
    () => documents.upload(
      file: _file('deed.pdf', 'application/pdf'),
      documentType: DocumentType.values.first,
      title: 'Deed',
      propertyId: 1,
      leaseId: 31,
    ),
  );
  await call(() => documents.fetchDownloadUrl(9));

  final tenants = TenantsRepository(client, cache);
  await call(() => tenants.listPage(cursor: 'abc', limit: 20));
  await call(() => tenants.fetch(52));

  final applications = ApplicationsRepository(client);
  await call(() => applications.listFormsPage(cursor: 'abc', limit: 20));
  await call(() => applications.fetchForm(2));
  await call(
    () => applications.createForm(
      ApplicationFormCreateRequest(
        title: 'Flat 4B',
        propertyId: 1,
        description: 'Apply here',
        expiresAt: DateTime(2026, 12, 31),
        fields: [
          ApplicationFormField(
            id: 'job',
            label: 'Job',
            fieldType: ApplicationFieldType.text,
            isRequired: true,
          ),
          ApplicationFormField(
            id: 'pets',
            label: 'Pets',
            fieldType: ApplicationFieldType.select,
            options: ['Yes', 'No'],
          ),
        ],
      ),
    ),
  );
  await call(
    () => applications.listApplicationsPage(
      cursor: 'abc',
      limit: 20,
      status: RentalApplicationStatus.applicant,
    ),
  );
  await call(() => applications.fetchApplication(8));
  await call(
    () => applications.decide(
      8,
      ApplicationDecisionRequest(
        decision: ApplicationDecision.approved,
        notes: 'Good fit',
      ),
    ),
  );
  await call(() => applications.fetchPublicForm('flat-4b'));
  await call(
    () => applications.submitPublicForm(
      'flat-4b',
      PublicApplicationSubmitRequest(
        applicantFullName: 'Ravi Kumar',
        applicantEmail: 'ravi@example.com',
        applicantPhone: '+919888888888',
        answers: {'job': 'Engineer'},
        notes: 'Move in soon',
      ),
    ),
  );

  final notifications = NotificationsRepository(client);
  await call(
    () => notifications.registerDevice(
      DeviceRegistrationRequest(
        token: 'fcm-token',
        platform: DevicePlatform.android,
        appVersion: '1.0.0',
        locale: 'en',
      ),
    ),
  );
  await call(() => notifications.listPage(cursor: 'abc', limit: 20));
  await call(() => notifications.markOpened('44'));

  final reports = ReportsRepository(client);
  for (final type in ReportType.values) {
    await call(
      () => reports.fetchReport(
        type,
        from: DateTime(2026, 4),
        to: DateTime(2026, 9, 30),
      ),
    );
  }

  final dashboard = DashboardRepository(client, cache);
  await call(dashboard.fetchOverview);
  await call(dashboard.fetchActivity);

  await call(
    () => uploads.uploadPublicImage(file: _file('a.jpg', 'image/jpeg')),
  );
  await call(() => client.get<dynamic>('/agents/assigned'));

  final auth = AuthRepository(client, AuthTokenStorage(SecureKvStore()));
  await call(() => auth.checkIdentifierStatus('+919999999999'));
  await call(() => auth.recordLastMethod(AuthMethod.phoneOtp));
  await call(auth.getAuthGateState);
  await call(auth.completeOnboarding);
  await call(auth.fetchProfile);
  await call(
    () => auth.updateProfile(
      UserProfileUpdate(
        fullName: 'Asha Rao',
        phone: '+919999999999',
        dateOfBirth: DateTime(1990, 5, 17),
      ),
    ),
  );
}

final _dateOnly = RegExp(r'^\d{4}-\d{2}-\d{2}$');
final _utcInstant = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z$');

/// The reason [value] is not a valid [kind] (`integer`, `number`, `string:date`,
/// ...), or null. A multipart field is a string, so it is read as its type.
String? _badKind(String kind, Object? value, {required bool form}) {
  if (value == null) return null;
  Object? read = value;
  if (form && value is String) {
    read = switch (kind) {
      'integer' => int.tryParse(value),
      'number' => num.tryParse(value),
      'boolean' => switch (value) {
        'true' => true,
        'false' => false,
        _ => null,
      },
      _ => value,
    };
  }
  return switch (kind) {
    'integer' when read is! int => 'is not an integer',
    'number' when read is! num => 'is not a JSON number',
    'boolean' when read is! bool => 'is not a boolean',
    'string' when read is! String => 'is not a string',
    'array' when read is! List => 'is not a list',
    'object' when read is! Map => 'is not an object',
    'string:date' when read is! String || !_dateOnly.hasMatch(read) =>
      'is not a YYYY-MM-DD date',
    'string:date-time' when read is! String || !_utcInstant.hasMatch(read) =>
      'is not a UTC instant ending in Z',
    _ => null,
  };
}

List<String> _check(FixtureAdapter recorder, {required bool agent}) {
  final problems = <String>[];
  for (final o in recorder.requests) {
    final label = '${o.method} ${o.path}';
    final route = matchRoute(recorder.routes, o.method, o.path);
    if (route == null) {
      problems.add('$label: the backend has no such route');
      continue;
    }

    // Query keys.
    for (final entry in o.queryParameters.entries) {
      final spec = route.query[entry.key] as Map<String, dynamic>?;
      if (spec == null) {
        problems.add('$label: query ${entry.key} is not declared (422)');
        continue;
      }
      final enumValues = (spec['enum'] as List<dynamic>?)?.cast<String>();
      if (enumValues != null && !enumValues.contains('${entry.value}')) {
        problems.add(
          '$label: query ${entry.key}=${entry.value} is no wire value',
        );
      }
      final kind = spec['kind'] as String?;
      final bad = kind == null
          ? null
          : _badKind(kind, entry.value, form: false);
      if (bad != null) {
        problems.add('$label: query ${entry.key}=${entry.value} $bad');
      }
      final max = spec['maximum'];
      if (max is num && entry.value is num && (entry.value as num) > max) {
        problems.add('$label: query ${entry.key}=${entry.value} is above $max');
      }
    }

    // Body keys.
    final spec = route.body;
    final data = o.data;
    final keys = <String>{};
    Map<String, dynamic>? json;
    if (data is FormData) {
      keys
        ..addAll(data.fields.map((e) => e.key))
        ..addAll(data.files.map((e) => e.key));
      json = {for (final e in data.fields) e.key: e.value};
    } else if (data is Map) {
      json = Map<String, dynamic>.from(data);
      keys.addAll(json.keys);
    }
    if (spec == null) {
      if (keys.isNotEmpty) {
        problems.add('$label: sends a body, the route takes none');
      }
    } else {
      final properties = (spec['properties'] as List<dynamic>).cast<String>();
      final required = (spec['required'] as List<dynamic>).cast<String>();
      if (data == null && spec['required_body'] == true) {
        problems.add('$label: sends no body, the route needs one');
      }
      for (final key in keys.where((k) => !properties.contains(k))) {
        problems.add('$label: body key $key is not declared (422)');
      }
      if (data != null) {
        for (final key in required.where((k) => !keys.contains(k))) {
          problems.add('$label: required body key $key is missing (422)');
        }
      }
      final kinds = (spec['kinds'] as Map<String, dynamic>)
          .cast<String, String>();
      if (data is Map) {
        for (final entry in data.entries) {
          final kind = kinds['${entry.key}'];
          final bad = kind == null
              ? null
              : _badKind(kind, entry.value, form: false);
          if (bad != null) {
            problems.add('$label: body ${entry.key}=${entry.value} $bad');
          }
        }
      } else if (data is FormData) {
        for (final field in data.fields) {
          final kind = kinds[field.key];
          final bad = kind == null
              ? null
              : _badKind(kind, field.value, form: true);
          if (bad != null) {
            problems.add('$label: field ${field.key}=${field.value} $bad');
          }
        }
      }
      final enums = (spec['enums'] as Map<String, dynamic>)
          .cast<String, dynamic>();
      if (json != null) {
        for (final entry in enums.entries) {
          final value = json[entry.key];
          if (value == null) continue;
          final allowed = (entry.value as List<dynamic>).cast<String>();
          final values = value is List ? value : [value];
          for (final item in values) {
            if (!allowed.contains('$item')) {
              problems.add('$label: body ${entry.key}=$item is no wire value');
            }
          }
        }
      }
    }

    // Owner scope: an agent names the owner wherever the route declares it. An
    // owner never does.
    final declaresOwner =
        route.query.containsKey('owner_id') ||
        (spec != null &&
            (spec['properties'] as List<dynamic>).contains('owner_id'));
    final sentOwner =
        o.queryParameters.containsKey('owner_id') ||
        (json?.containsKey('owner_id') ?? false);
    if (agent && declaresOwner && !sentOwner) {
      problems.add('$label: an agent must send owner_id here');
    }
    if (!agent && sentOwner) {
      problems.add('$label: an owner must not send owner_id');
    }
    if (agent && sentOwner && !declaresOwner) {
      problems.add('$label: owner_id is not declared (422)');
    }
  }
  return problems;
}

void main() {
  final routes = loadRoutes();

  for (final agent in [false, true]) {
    test('every request of the app matches the route contract '
        '(${agent ? 'agent with an owner' : 'owner'})', () async {
      final recorder = FixtureAdapter(routes);
      final client = fixtureApiClient(
        recorder,
        ownerScope: () => agent
            ? OwnerScope.forRole(UserRole.agent, _agentOwnerId)
            : OwnerScope.forRole(UserRole.user, null),
      );

      await _exerciseApp(client);

      expect(recorder.requests.length, greaterThan(60));
      expect(_check(recorder, agent: agent), isEmpty);
    });
  }
}
