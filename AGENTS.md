# AGENTS.md

> **Canonical guide: [CLAUDE.md](./CLAUDE.md).** Read it first for stack, structure, commands, and conventions.

## Repo Purpose

360 Estate — Flutter property-management app (Phases 1–3) for India PG / large owners on the 360Ghar backend. (Backend distinguishes Owner/RM/Tenant, but the app does no role-based gating — see CLAUDE.md.)

## Build, Test, and Development Commands

```bash
cp .env.example .env
flutter pub get
flutter run
dart run build_runner build --delete-conflicting-outputs   # after Freezed / json model changes
flutter analyze
flutter test
```

## Conventions

- Feature-first under `lib/features/<feature>/`; Riverpod for state, `go_router` for navigation, Dio for HTTP.
- Strict analyzer (`unused_import` / `dead_code` are errors) — keep imports clean.
- Run `build_runner` after any Freezed / `@JsonSerializable` change.

See [CLAUDE.md](./CLAUDE.md) for the full guide.
