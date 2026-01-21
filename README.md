# 360 Estate (Flutter)

Phase 1-3 Property Management app for India PG / large owners using the 360Ghar backend.

## Tech
- Flutter 3.x
- State management: Riverpod
- Navigation: go_router
- Networking: Dio
- Models: Freezed + json_serializable
- Auth storage: flutter_secure_storage
- Env: flutter_dotenv

## Project structure (Phase 1-3)
- `lib/core`: env, storage, dio, error handling, shared widgets
- `lib/features/auth`: phone/password auth, profile
- `lib/features/home`: dashboard overview + activity
- `lib/features/properties`: list, create, edit, detail
- `lib/features/collections`: charges, payments
- `lib/features/tasks`: maintenance requests
- `lib/features/more`: tenants, expenses, documents, reports, profile
- `lib/features/tenant`: tenant navigation + payments + requests + documents
- `lib/features/leases`: lease lifecycle
- `lib/features/inspections`: inspection checklists + signing
- `lib/features/notifications`: device registration + list
- `lib/features/rental_applications`: forms, inbox, public submission

## Setup
```bash
cp .env.example .env
```
Update `.env`:
```
API_BASE_URL=https://api.360ghar.com/api/v1
ENABLE_APPLICATIONS_MODULE=true
ENABLE_PUBLIC_APPLICATIONS=true
```

Run:
```bash
flutter pub get
flutter run
```

## Auth flow
- Sign in with phone + password
- Sign up with phone + password (optional name/email)
- Token saved in secure storage
- Dio attaches `Authorization: Bearer <token>`
- 401 clears token and forces logout

## Notes
- Tenant role is supported alongside Owner/RM.
- Public rental application links are available at `/public/applications/:slug`.
- Payment intents are initiated from tenant charges; no gateway is hardcoded.
- Pagination is enabled for large lists (properties, tenants, charges, maintenance).
- In-memory cache is used for dashboard and list data.
- If you add new Freezed models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

