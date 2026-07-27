# Unimplemented / Stub / No-Op Features in 360 Estate

This document catalogs the known placeholder, stub, and not-yet-implemented features in the `360-estate-app` Flutter client. The goal is to make the remaining Phase-4 work explicit and to avoid losing track of data-layer scaffolds that currently have no UI or no route.

## Unreachable placeholder pages

These pages exist under `lib/features/` but have **no registered `GoRoute`**, so they are effectively dead code unless navigated to directly.

| Page | File | Why it is a stub |
|------|------|------------------|
| **Analytics** | `lib/features/analytics/presentation/analytics_page.dart` | Shows a full "Analytics Coming Soon" screen. No analytics API is wired and the comment says `Analytics data will be fetched from the API when the backend analytics endpoints are available`. |
| **Calendar** | `lib/features/calendar/presentation/calendar_page.dart` | Renders a calendar UI, but `_eventsForSelectedDay` and `_eventsForMonth` always return `const []`. The empty state says `Events will appear here once connected to the API`. |
| **Messaging** | `lib/features/messaging/presentation/messaging_page.dart` | Shows a full "Messaging Coming Soon" screen. The comment says `Messaging will be available when the chat/messaging API endpoints are implemented`. |
| **Onboarding** | `lib/features/auth/presentation/onboarding_page.dart` | Described as a placeholder that only marks onboarding as complete and redirects to `/home`. There is no real onboarding flow. |

## Feature scaffolds with no UI / route

These directories contain clean-arch data/domain files but no `presentation` layer and no route wiring.

| Feature | File(s) | Why it is a stub |
|---------|---------|------------------|
| **Applications** | `lib/features/applications/data/*`, `lib/features/applications/domain/*` | Data/domain scaffold. The actual UI lives under `lib/features/rental_applications`; the router uses `rental_applications`, not this. |
| **Feedback** | `lib/features/feedback/data/feedback_repository.dart`, `lib/features/feedback/feedback_providers.dart`, `lib/features/feedback/models/bug_report.dart` | Has a repository and model, but no presentation layer or route. The `report` page in the UI uses a different flow. |

## Pages / flows that are not wired to APIs

| Feature | File | What is missing |
|---------|------|-----------------|
| **Notifications / push setup** | `lib/features/notifications/presentation/notifications_page.dart` | Auto FCM registration is a no-op. `_registerDeviceAuto` only shows a snackbar: `Push notifications will be available once FCM is configured`. Manual token entry is the only working path. |
| **Reports drill-down automation** | `lib/features/more/reports/presentation/report_drilldown_page.dart` | The "Automation hooks" card is a placeholder: `Export and automation triggers will be added in a later phase`. |
| **Tenant form** | `lib/features/more/tenants/presentation/tenant_form_page.dart` | `_submit` shows `Tenant management is not available yet`. The property selection dialog has a TODO comment. The page is not routed from `tenants_page.dart`. |
| **Move-in checklist** | `lib/features/more/tenants/presentation/move_in_checklist_page.dart` | `_saveChecklist` shows `Saving move-in checklists is not available yet`. The signature dialog shows `Signature capture will be implemented here`. Not routed. |
| **Move-out checklist** | `lib/features/more/tenants/presentation/move_out_checklist_page.dart` | `_saveChecklist` shows `Saving move-out checklists is not available yet`. The signature dialog shows `Signature capture will be implemented here`. Not routed. |
| **Work orders** | `lib/features/tasks/presentation/work_order_form_page.dart` | `_submit` shows `Work orders are not available yet`. The page is not routed in `app_router.dart`. |
| **Lease templates** | `lib/features/leases/presentation/lease_templates_page.dart` | `_showCreateTemplateDialog` shows `Custom template creation coming soon` and the custom templates section is a `Placeholder for custom templates`. The page is not routed. |
| **Public application link** | `lib/features/rental_applications/presentation/application_form_detail_page.dart` | When the form has no slug, the public link section displays `Link not available yet. The form needs a slug to generate a public link`. |

## Settings and preferences that do not persist

| Feature | File | What is missing |
|---------|------|-----------------|
| **Notification preferences** | `lib/features/settings/presentation/pages/notification_settings_page.dart` | `NotificationPreferencesNotifier.setPreference` only updates in-memory state. The comment is `// TODO: Save to storage`. |
| **Privacy settings** | `lib/features/settings/presentation/pages/privacy_settings_page.dart` | Crash reporting toggle has `// TODO: Implement crash reporting toggle`. `_updatePrivacy` has `// TODO: Save to storage via privacy preferences provider`. Download and clear-history actions only show snackbars. |

## Core infrastructure stubs

| Feature | File | What is missing |
|---------|------|-----------------|
| **Crash reporting** | `lib/core/crash_reporting/crash_reporter.dart` | `NoopCrashReporter` is a no-op. `ConsoleCrashReporter` is described as a `Stub implementation intended to be swapped with Sentry/Crashlytics`. The env flag `ENABLE_CRASH_REPORTING` defaults to `false`. |

## Historical / migrated data sources

Several data source files under `features/` are retained for migration history only and are never instantiated at runtime. They contain comments like `Placeholder removed in Phase 5. Retained only so the file diff stays in the migration history; never instantiated at runtime.` Examples include:

- `lib/features/tenants/data/datasources/tenants_remote_data_source.dart`
- `lib/features/properties/data/datasources/properties_remote_data_source.dart`
- `lib/features/applications/data/datasources/applications_remote_data_source.dart`

These are not bugs, but they should be cleaned up once the migration is fully verified.

## Notes on routing

- `CalendarPage`, `AnalyticsPage`, and `MessagingPage` are not registered in `lib/app/router/app_router.dart`, so even if they were fully implemented, the app has no navigation path to them.
- `TenantFormPage`, `MoveInChecklistPage`, `MoveOutChecklistPage`, `WorkOrderFormPage`, and `LeaseTemplatesPage` are not imported or routed in `lib/app/router/app_router.dart`.

## Last updated

Generated from a codebase scan of the `360-estate-app` repository. Update this doc when a feature is fully implemented or when a new placeholder is added.
