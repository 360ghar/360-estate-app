# 360 Estate (Flutter)

Assumption: Runtime config is loaded from `.env` at startup using `flutter_dotenv` (and can be overridden via `--dart-define`). If Supabase values are missing, the app still runs but authentication screens show a configuration error.

## Tech
- Flutter 3.38 (stable), Dart 3.10
- GetX: routing (`GetMaterialApp`/`GetPage`), DI (Bindings), middleware (route guards), controllers
- Clean Architecture: presentation → domain → data (dependency inversion via repository interfaces)
- Localization: Flutter `gen_l10n` ARB (`lib/l10n/arb/*`)
- Networking: Dio with request-id, auth token injection, retry/backoff, and failure mapping
- Auth: Supabase (phone + password), session persistence, refresh-on-401, deep-link handling (magic links/OAuth redirects)

## Project Structure (high level)
- `lib/app`: app shell, routes, initial bindings
- `lib/core`: config, logging, networking, storage, design system, shared widgets/controllers
- `lib/features/<feature>`: each feature follows `presentation/`, `domain/`, `data/`

## Setup
```bash
flutter --version
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

## Environment & Configuration
Configuration is typed in `lib/core/config/app_config.dart` and reads from `.env` (recommended) or `--dart-define` overrides.

Create/update `.env` (an example is provided in `.env.example`):
```bash
cp .env.example .env
```

| Key | Example | Notes |
| --- | --- | --- |
| `APP_ENV` | `dev` / `staging` / `prod` | Defaults to `dev` |
| `API_BASE_URL` | `https://api.example.com` | Optional; if empty or `USE_MOCK_API=true`, the pagination demo uses mock data |
| `SUPABASE_URL` | `https://xxxxx.supabase.co` | Required for auth |
| `SUPABASE_ANON_KEY` | `eyJ...` | Required for auth |
| `USE_MOCK_API` | `true` / `false` | Defaults to `true` outside `prod` |
| `ENABLE_DEBUG_LOGS` | `true` / `false` | Defaults to `true` in non-prod debug builds |
| `ENABLE_CRASH_REPORTING` | `true` / `false` | Enables a console stub (swap with Sentry/Crashlytics) |
| `ENABLE_PUBLIC_APPLICATIONS` | `true` / `false` | Enables public application route |

### Run (dev)
```bash
flutter run
```

### Run (prod-like, real API)
```bash
flutter run \
  --dart-define=APP_ENV=prod \
  --dart-define=USE_MOCK_API=false \
  --dart-define=ENABLE_DEBUG_LOGS=false
```

## Supabase Auth Notes (phone + password)
- Phone numbers should be in E.164 format (e.g. `+919876543210`).
- If your Supabase project requires phone confirmation, sign-up may not create an active session until verified.
- The "phone exists → login / else → signup" flow is best-effort:
  - If you create a `profiles` table with a `phone` column accessible via RLS, the app can check existence.
  - If not available, the flow defaults to login and still provides navigation to sign up.

## Deep Links (magic links / OAuth redirects)
This app listens to incoming URIs using `app_links` and passes them to Supabase via `auth.getSessionFromUrl(uri)`.

Configured schemes in this repo:
- Android intent filter: `com.gh360.estateapp://login-callback`
- iOS URL scheme: `com.gh360.estateapp`

Supabase setup:
1. In Supabase Dashboard → Auth → URL Configuration, add the redirect URL: `com.gh360.estateapp://login-callback`.
2. For OAuth providers, ensure the same redirect URL is configured.

## QA / Lints / Tests
- Lints: `analysis_options.yaml` (strict inference/casts + strong lints)
- Unit tests: domain usecase + repository mock
- Controller tests: pagination controller state transitions
- Widget tests: smoke tests for key screens

```bash
flutter analyze
flutter test
```
