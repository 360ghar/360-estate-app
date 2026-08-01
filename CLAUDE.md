# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Canonical guide.** `AGENTS.md` adds agent workflow notes. Backend is the shared 360Ghar FastAPI monolith at `../360ghar-backend` (`/api/v1`).

## Project Overview

**360 Estate** is a Flutter property-management app for the Indian PG / large-owner segment, built on the 360Ghar backend. It covers properties, tenants, leases, rent collections/payments, maintenance, inspections, expenses, documents, reports, and rental applications (incl. public submission links).

- **Package:** `estate_app` ("360 Estate"), `publish_to: 'none'`, `version: 1.0.0+1`
- **Dart SDK:** `^3.10.4`
- **Deep-link scheme:** `com.the360ghar.estateapp` (Google OAuth redirect), `estate360://` (custom scheme), canonical domain `the360ghar.com/estate/...`

> **Roles:** The backend distinguishes Owner / RM / Tenant, but **the Flutter app does no role-based gating.** `UserProfile.role` is a plain `String?`, there is no `Role` enum, no `isOwner`/`isTenant` helpers, and no role-based branches in routes, the shell, or pages. All authenticated users see the same UI. If you need role-gated UX, it does not exist yet — build it; don't assume it.

## Tech Stack

- **Flutter / Dart** `^3.10.4`
- **State management:** Riverpod (`flutter_riverpod 2.5` + `riverpod_annotation`); pagination uses a `StateNotifier`-based `PagedListController`
- **Navigation:** `go_router 14` (path-based, no named routes) + `app_links` deep links
- **Networking:** `dio 5.9` with 4 interceptors
- **Models:** `freezed 2.5` + `json_serializable 6.8` + `freezed_annotation` / `json_annotation`
- **Auth/storage:** `supabase_flutter 2.10` (auth + session), `flutter_secure_storage 9.2` (token), `shared_preferences` (prefs)
- **Env:** `flutter_dotenv 5.1` (`.env` bundled as an asset)
- **Maps:** `maplibre_gl 0.26` with **OpenFreeMap** `liberty` style (`https://tiles.openfreemap.org/styles/liberty`)
- **Sign-in:** `google_sign_in 7`, `sign_in_with_apple 8`, `smart_auth` / `sms_autofill` (OTP autofill)
- **Other:** `geolocator`, `image_picker` / `file_picker`, `cached_network_image`, `flutter_markdown`, `url_launcher` / `share_plus`, `package_info_plus`, `uuid`
- **i18n:** ARB-based (`app_en.arb` template + `app_hi.arb`) → generated `AppLocalizations` (`nullable-getter: false`)
- **Test:** `flutter_test` only (`mocktail` declared but currently unused; **no integration tests**)

## Commands

```bash
cp .env.example .env           # fill SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY (app won't boot without them)
flutter pub get
flutter run                    # selected device

# Code generation — ONLY files matching lib/**/models/*.dart are codegen targets (see build.yaml)
dart run build_runner build --delete-conflicting-outputs

# Quality
flutter analyze                # strict-casts / strict-inference / strict-raw-types ON; unused_import & dead_code are ERRORS
flutter test                   # test/core + test/data

# Launcher icons (after changing assets/images/logo.png)
dart run flutter_launcher_icons

# Builds
flutter build apk --release
flutter build ios --release
```

## Environment Variables (`.env.example`)

Loaded via `flutter_dotenv` (`EnvLoader.load()` → `dotenv.load(fileName: '.env')`). `AppConfig.fromEnvironment()` reads `--dart-define` first, then dotenv, then a default. **Throws `StateError` if `apiBaseUrl` or Supabase URL/key are empty.**

| Var | Default | Purpose |
|-----|---------|---------|
| `APP_ENV` | `dev` | `dev` / `staging` / `prod` |
| `API_BASE_URL` | `https://api.360ghar.com/api/v1` | Backend base (**already includes `/api/v1`** — see gotcha) |
| `SUPABASE_URL` | _(empty, required)_ | Project URL |
| `SUPABASE_PUBLISHABLE_KEY` | _(empty, required)_ | Anon key |
| `ENABLE_DEBUG_LOGS` | `!kReleaseMode && !prod` | Verbose HTTP/logger output |
| `ENABLE_CRASH_REPORTING` | `false` | Enables `ConsoleCrashReporter` (**stub** — logs only, no Sentry/Crashlytics) |
| `ENABLE_APPLICATIONS_MODULE` | `true` | Gates `/more/applications*` routes |
| `ENABLE_PUBLIC_APPLICATIONS` | `true` | Gates `/public/applications/:slug*` routes |
| `GOOGLE_PLACES_API_KEY` | _(empty, optional)_ | Places autocomplete |
| `GOOGLE_WEB_CLIENT_ID` / `GOOGLE_IOS_CLIENT_ID` | _(optional)_ | Required for Supabase Google ID-token validation |
| `AUTH_REDIRECT_URL` | `com.the360ghar.estateapp://login-callback` | Google OAuth redirect override |

## Project Structure

```
lib/
├── main.dart                  # → bootstrap()
├── bootstrap.dart             # runZonedGuarded → binding → EnvLoader.load → AppConfig → Supabase.initialize →
│                              #   crash reporter → runApp(ProviderScope(overrides: 4 throwing providers))
├── app/
│   ├── app.dart               # MaterialApp.router (theme + locale from providers, deep-link bind on init)
│   ├── app_shell.dart         # bottom-nav shell, 5 fixed tabs (Home, Properties, Collections, Tasks, More) — NOT role-aware
│   └── router/
│       ├── routes.dart        # path constants
│       └── app_router.dart    # GoRouter + redirect guard + StatefulShellRoute.indexedStack
├── core/
│   ├── config/                # AppConfig, FeatureFlags, EnvLoader, constants (privacy/terms URLs)
│   ├── network/               # ApiClient (Dio) + interceptors + failure mapper + auth token provider + network info
│   ├── storage/               # secure_kv_store, auth_token_storage (key 'auth_token'), app_preferences (PrefKeys)
│   ├── services/              # cache_store, deep_link_service, file_upload_service, google_places_service
│   ├── pagination/            # Page<T> (cursor), PagedListController<T>
│   ├── map/                   # map_controller (OpenFreeMap liberty), safe_map (platform gate)
│   ├── presentation/
│   │   ├── design_system/     # app_colors, app_spacing, app_radii, app_text_styles, app_shadows, gradients, glass*
│   │   ├── theme/             # app_theme.dart (light/dark)
│   │   ├── widgets/  animations/  extensions/  errors/  state/
│   ├── errors/                # Failure sealed hierarchy (Network/Unauthorized/NotFound/Validation/Api)
│   ├── logger/  crash_reporting/  utils/  providers.dart
├── features/                  # see "Features" below
└── l10n/                      # arb/ (app_en, app_hi) + gen/ (AppLocalizations)
test/
├── core/services/deep_link_service_test.dart
├── core/utils/parse_test.dart
└── data/dto_parsing_test.dart
```

## App Bootstrap (`bootstrap.dart`)

`runZonedGuarded` → `WidgetsFlutterBinding.ensureInitialized()` → `EnvLoader.load('.env')` → `AppConfig.fromEnvironment()` → `AppLogger.init` → **throw if Supabase not configured** → `Supabase.initialize(url, anonKey)` → `AppPreferences` + `SecureKvStore` → crash reporter (`ConsoleCrashReporter` or `NoopCrashReporter`, both stubs) → `runApp(ProviderScope(overrides: [appConfig, appPreferences, secureStore, crashReporter], child: App()))`. The four overridden providers **throw `UnimplementedError`** if not overridden.

## Routing (`app_router.dart`)

`appRouterProvider` → `GoRouter`, `initialLocation: '/splash'`, `refreshListenable: GoRouterRefreshStream(authController.stream)`.

**Redirect guard order:** (1) public-route gate (`/public/*` blocked unless `enablePublicApplications`); (2) `isChecking` → stay on `/splash`; (3) replay pending deep link if logged in; (4) not logged in → allow auth routes else `/enter-phone`; (5) `needsPassword` → `/set-password` (non-skippable); (6) `needsPhone` → `/add-phone` (skippable); (7) `needsProfileCompletion` → `/profile-completion`; (8) `needsOnboarding` → `/onboarding`; (9) applications-module flag gates `/more/applications*`; (10) logged in + on auth/splash → `/home`.

**Shell:** one `StatefulShellRoute.indexedStack` with 5 branches — `/home`, `/properties` (+`create`, `:id`, `:id/edit`), `/collections` (+`payments/new`), `/tasks` (+`create`, `:id` → `MaintenanceDetailPage`), `/more` (nested `applications`, `tenants`, `leases`, `inspections`, `expenses`, `documents`, `reports`, `notifications`, deep `profile` subtree). Plus top-level auth routes, `/properties/map`, `/location-search`, and public `/public/applications/:slug` (+`success`).

Deep links are resolved outside GoRouter by `DeepLinkService` (`router.go(path)` + pending-path replay): `the360ghar.com/estate/{apply|property|task|tenant|lease}/{id}` and `estate360://{entity}/{id}`.

## Networking (`core/network/`)

`ApiClient` builds `Dio` (`baseUrl`, connect/send/receive `30s`, `Accept: application/json`, 2xx-only). **Interceptors in order:** `RequestIdInterceptor` (stamps `x-request-id` + attempt + started-at) → `AuthInterceptor` → `LoggingInterceptor` (gated by `enableDebugLogs`) → `RetryInterceptor` (idempotent verbs on 408/429/5xx/timeouts, max 2, 350ms base + jitter).

- **Auth attach:** `AuthInterceptor.onRequest` calls `RefreshingAuthTokenProvider.getAccessToken()` → reads `Supabase.instance.client.auth.currentSession`, refreshes if expired (10s skew), caches to secure storage → sets `Authorization: Bearer <token>`.
- **401 → logout (indirect):** `AuthInterceptor.onError` calls `tokenProvider.clearSession()` (clears storage + `supabase.auth.signOut()`) on 401 or 403-with-expired-token body. The interceptor **does not touch the router** — the storage clear fires `AuthTokenStorage.onTokenChanged`, `AuthController._handleTokenChange` flips state to `unauthenticated`, and `GoRouterRefreshStream` re-runs the redirect.
- **Errors:** `DioFailureMapper` → `Failure` sealed hierarchy (cancel/timeout/connection → `NetworkFailure(isOffline:)`, 401 → `UnauthorizedFailure`, 404 → `NotFoundFailure`, 400/422 → `ValidationFailure` parsing FastAPI `detail` field list, else `ApiFailure`).

## Auth Flow (Supabase-backed, not a custom token system)

Multiple methods, all persisting the **Supabase JWT access token** to secure storage (key `'auth_token'`); refresh is delegated to Supabase via `RefreshingAuthTokenProvider` — the app never calls a custom refresh endpoint.

1. `EnterPhonePage` → `POST /api/v1/auth/identifier-status` → next step (password vs OTP) + channel (phone vs email).
2. **Password:** `_supabase.auth.signInWithPassword(...)`. **OTP:** phone/email OTP. **Google:** native `signInWithIdToken` or OAuth redirect (`com.the360ghar.estateapp://login-callback`). **Apple:** `sign_in_with_apple`.
3. On success → save `session.accessToken` to secure storage.
4. `GET /users/profile/` hydrates `UserProfile` (falls back to Supabase user metadata on failure).
5. **Gate:** `GET /api/v1/users/me/auth-state?app=estate` returns a `stage` mapped to `AuthStatus` (`identifier_verification`→unauthenticated, `password_setup`→needsPassword, `profile_completion`→needsProfileCompletion, `app_onboarding`→needsOnboarding, `active`→authenticated). On endpoint failure → defaults to `authenticated` (never lock users out).

## Features (`lib/features/`)

Each feature is feature-first (presentation + `*_providers.dart`); some are clean-arch data/domain only.

- **`auth`** — sign-in/up, set-password, add-phone, profile-completion, onboarding gates; `auth_controller.dart`.
- **`home`** — dashboard (KPI cards, quick actions, activity feed).
- **`properties`** — list / multi-step create wizard / detail / map; `/properties/map` takes `List<PropertyMarker>` extra.
- **`collections`** — rent charges + payments (`record_payment_page`).
- **`tasks`** — **the maintenance UI** ("Tasks" tab): `tasks_page`, `task_create_page`, `maintenance_detail_page`, `work_order_form_page`. Consumes the `maintenance` feature's data/domain layer.
- **`maintenance`** — clean-arch data/domain only (no UI); also imported by `properties/property_detail_page`.
- **`leases`** — list / form / detail / templates.
- **`inspections`** — list / form / detail / templates.
- **`rental_applications`** — **the actual applications UI** (forms, inbox, public submission). Gated by flags in the router.
- **`applications`** — clean-arch data/domain scaffold, **no presentation, no external imports** — a parallel/dead scaffold; the router uses `rental_applications`, not this.
- **`tenants`**, **`documents`**, **`finance`**, **`reports`** — clean-arch data/domain only; their UI lives under `more/...`.
- **`more`** — "More" tab container + sub-modules (`documents`, `expenses`, `reports`, `tenants`, `profile`).
- **`notifications`**, **`settings`** (theme/locale/notif/privacy/legal/delete-account).
- **`analytics`**, **`calendar`**, **`messaging`**, **`feedback`** — have pages but **no registered `GoRoute`**; phase-4 placeholders, currently unreachable.

## Core Providers (`core/providers.dart`)

`appConfigProvider`, `appPreferencesProvider`, `secureStoreProvider`, `crashReporterProvider` (all throw until overridden in bootstrap); `networkInfoProvider`, `cacheStoreProvider` (in-memory), `authTokenStorageProvider`, `authTokenProvider` (`RefreshingAuthTokenProvider`), `apiClientProvider`, `fileUploadServiceProvider`, `deepLinkServiceProvider`.

## Pagination & Map

- **`PagedListController<T>`** (`core/pagination/`) — cursor-based (`Page<T>{items, hasMore, nextCursor}`, default page 20). On initial/refresh error it sets `hasMore=false` (avoids infinite reload loops); `loadMore` errors keep the loaded page and surface `loadMoreError`.
- **Map** — `map_controller.dart` uses OpenFreeMap `liberty` style, zoom 12 (min 3 / max 18); `SafeMap` renders only on Android/iOS/Web (placeholder + OSM link elsewhere).

## Conventions & Gotchas

- **Codegen only runs on `lib/**/models/*.dart`** (`build.yaml`). Freezed/`@JsonSerializable` classes placed outside a `models/` folder (e.g. in `domain/entities/`) will **not** be generated — keep them under `models/`.
- **`@JsonKey` on freezed factory params is intentional** — `analysis_options.yaml` ignores `invalid_annotation_target` (the annotation is forwarded to generated fields).
- **`unused_import` and `dead_code` are ERRORS**, not warnings. **`always_use_package_imports`** is on (no relative imports). `discarded_futures` is deliberately **off** in favor of `unawaited_futures` (it fires pervasively on fire-and-forget `showDialog`/animation calls).
- **App won't boot without Supabase** — `bootstrap.dart` throws if `SUPABASE_URL`/`SUPABASE_PUBLISHABLE_KEY` are missing; `.env.example` ships them empty, so a fresh checkout crashes on launch until filled.
- **`API_BASE_URL` already includes `/api/v1`** (`.env.example`). Most call sites use bare paths (`/users/profile/`), but a few in `auth_repository.dart` and `uploadProfilePhoto` use `/api/v1/...` prefixes — those double-prefix to `/api/v1/api/v1/...`. Match the bare-path convention when adding endpoints.
- **`tasks` ≠ `maintenance`**, and **`rental_applications` ≠ `applications`** (see Features). Don't wire UI to the `applications` clean-arch layer.
- **Feature flags default to `true`** — set `ENABLE_APPLICATIONS_MODULE=false` / `ENABLE_PUBLIC_APPLICATIONS=false` in `.env` to hide those flows.
- **Crash reporting is a stub** — `ConsoleCrashReporter` only logs; `ENABLE_CRASH_REPORTING=true` (or the persisted Privacy-settings toggle) sends nothing external.
- **Token is the Supabase JWT** (key `'auth_token'`), not a backend-issued opaque token. Never add a custom refresh endpoint.
- **`UserProfile.role` exists but is unused for gating** — see the Roles note at the top.

## Key Docs

- `README.md` — phases, structure, setup, auth flow notes
- `AGENTS.md` — agent workflow notes
- `l10n.yaml` + `lib/l10n/arb/` — localization sources (`app_en.arb` template, `app_hi.arb`)
- `analysis_options.yaml` — the source of truth for the strict lint rules above
