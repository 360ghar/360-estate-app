import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/features/collections/presentation/collections_page.dart';
import 'package:estate_app/features/collections/presentation/record_payment_page.dart';
import 'package:estate_app/features/home/presentation/home_page.dart';
import 'package:estate_app/features/inspections/presentation/inspection_detail_page.dart';
import 'package:estate_app/features/inspections/presentation/inspections_page.dart';
import 'package:estate_app/features/leases/presentation/lease_detail_page.dart';
import 'package:estate_app/features/leases/presentation/leases_page.dart';
import 'package:estate_app/features/more/documents/presentation/documents_page.dart';
import 'package:estate_app/features/more/expenses/presentation/expenses_page.dart';
import 'package:estate_app/features/more/presentation/more_page.dart';
import 'package:estate_app/features/more/tenants/presentation/tenant_detail_page.dart';
import 'package:estate_app/features/more/tenants/presentation/tenants_page.dart';
import 'package:estate_app/features/notifications/presentation/notifications_page.dart';
import 'package:estate_app/features/properties/presentation/properties_page.dart';
import 'package:estate_app/features/properties/presentation/property_detail_page.dart';
import 'package:estate_app/features/rental_applications/presentation/application_form_detail_page.dart';
import 'package:estate_app/features/rental_applications/presentation/application_inbox_detail_page.dart';
import 'package:estate_app/features/rental_applications/presentation/applications_page.dart';
import 'package:estate_app/features/rental_applications/presentation/public_application_page.dart';
import 'package:estate_app/features/tasks/presentation/maintenance_detail_page.dart';
import 'package:estate_app/features/tasks/presentation/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../contract/fixture_app.dart';

/// A screen must not throw when the backend sends a value the app does not
/// know (an enum value added later, a field that is null). The contract says an
/// unknown enum value reads as null, with no fallback to a real value.

/// Keys whose string value is a wire enum.
const _enumKeys = {
  'status',
  'category',
  'urgency',
  'request_status',
  'work_order_status',
  'document_type',
  'inspection_type',
  'property_type',
  'purpose',
  'management_status',
  'furnishing_level',
  'type',
  'field_type',
  'role',
  'next_step',
  'stage',
  'channel',
  'next_action',
  'occupancy',
  'payment_method',
};

/// Keys that hold the structure of a reply: pages, wrappers and ids.
const _structure = {
  'items',
  'next_cursor',
  'has_more',
  'limit',
  'total',
  'charge',
  'property',
  'active_lease',
  'leases',
  'unread_count',
  'id',
  'user_id',
  'property_id',
  'lease_id',
  'form_id',
  'slug',
  'custom_fields',
  'answers',
  'rooms_data',
};

Object? _unknownEnums(Object? json) {
  if (json is Map) {
    return {
      for (final e in json.entries)
        e.key: _enumKeys.contains(e.key) && e.value is String
            ? 'zzz_new_value'
            : _unknownEnums(e.value),
    };
  }
  if (json is List) return json.map(_unknownEnums).toList();
  return json;
}

Object? _sparse(Object? json) {
  if (json is Map) {
    return {
      for (final e in json.entries)
        e.key: _structure.contains(e.key) ? _sparse(e.value) : null,
    };
  }
  if (json is List) return json.map(_sparse).toList();
  return json;
}

final _pages = <String, Widget>{
  'properties': const PropertiesPage(),
  'property detail': const PropertyDetailPage(propertyId: '1'),
  'leases': const LeasesPage(),
  'lease detail': const LeaseDetailPage(leaseId: '31'),
  'collections': const CollectionsPage(),
  'record payment': const RecordPaymentPage(chargeId: '101'),
  'tenants': const TenantsPage(),
  'tenant detail': const TenantDetailPage(tenantId: '52'),
  'applications': const ApplicationsPage(),
  'application form': const ApplicationFormDetailPage(formId: '41'),
  'application inbox': const ApplicationInboxDetailPage(applicationId: '301'),
  'public application': const PublicApplicationPage(slug: 'sector-51-abc'),
  'documents': const DocumentsPage(),
  'expenses': const ExpensesPage(),
  'inspections': const InspectionsPage(),
  'inspection detail': const InspectionDetailPage(inspectionId: '61'),
  'tasks': const TasksPage(),
  'maintenance detail': const MaintenanceDetailPage(requestId: '71'),
  'home': const HomePage(),
  'notifications': const NotificationsPage(),
  'more': const MorePage(),
};

void main() {
  final variants = <String, Object? Function(Object?)>{
    'unknown enum values': _unknownEnums,
    'null fields': _sparse,
  };
  for (final variant in variants.entries) {
    testWidgets('no screen throws on ${variant.key}', (tester) async {
      final failures = <String>[];
      for (final page in _pages.entries) {
        final app = await buildFixtureApp(page.value, mutate: variant.value);
        await pumpFixtureApp(tester, app);
        final error = tester.takeException();
        if (error != null) {
          failures.add('${page.key}: ${error.toString().split('\n').first}');
        }
        // A screen that fails to read the reply shows an error view instead of
        // the data.
        final shown = tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data ?? '')
            .where(
              (t) =>
                  t.contains('Unable to') ||
                  t.contains('Something went wrong') ||
                  t.contains('Failed to load') ||
                  t.contains('Unexpected') ||
                  t.contains("Couldn't load"),
            )
            .toList();
        if (shown.isNotEmpty) failures.add('${page.key}: shows $shown');
        // The shared error view, whatever its copy says.
        if (find.byType(AppErrorView).evaluate().isNotEmpty) {
          failures.add('${page.key}: shows the error view');
        }
      }
      expect(failures, isEmpty);
    });
  }
}
