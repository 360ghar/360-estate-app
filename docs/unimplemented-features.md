# Unimplemented / stub / no-op features in 360 Estate

Placeholders and gaps in the `360-estate-app` client, as of the contract pass (October 2026). None of the production code paths calls the backend for them; a debug build can call one route by hand (see Push registration).

Every page has a route.

## Flows that are not wired

| Feature | File | What is missing |
| --- | --- | --- |
| Push registration | `lib/features/notifications/presentation/notifications_page.dart` | The app has no push token source (`firebase_messaging` is not a dependency). The inbox says so in plain words. A debug build can register a token by hand (`POST /notifications/devices/register` with `app_key` estate). The app calls no unregister route. |
| Notification preferences | `lib/features/settings/presentation/pages/notification_settings_page.dart` | The toggles are saved on the phone only, and the page says so. `PUT /users/me` accepts `notification_settings`, but no repository method sends it. |
| Profile privacy | `lib/features/settings/presentation/pages/privacy_settings_page.dart` | Profile visibility and analytics controls were removed: nothing read them. `PUT /users/me` accepts `privacy_settings`; a repository method is needed before the controls come back. Download-my-data and clear-history were removed too (no backend route). |
| Owner directory for agents | `lib/features/auth/presentation/widgets/owner_scope_card.dart` | An agent names the owner by the owner's user id. The backend has no route that lists the owners of an agent (`/pm/assignments` only creates and updates). |

## Infrastructure stubs

| Feature | File | What is missing |
| --- | --- | --- |
| Crash reporting | `lib/core/crash_reporting/crash_reporter.dart` | `ConsoleCrashReporter` only logs. `ENABLE_CRASH_REPORTING` defaults to `false`. |

## Local data

Inspection checklist templates live in app preferences, one list per signed-in account (`inspection_templates_<user id>`). They are not an API cache and are not sent to the backend. The old global list moves to the first account that opens it.
