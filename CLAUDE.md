# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bai Market (branded as Iris Cosmetics) is a Flutter mobile cosmetics e-commerce app targeting Android and iOS. It supports three locales: English, Russian, and Kazakh.

## Build & Development Commands

```bash
# Run the app
flutter run

# Generate localization files (after editing .arb files in lib/l10n/)
flutter gen-l10n

# Generate JSON serialization code (after modifying models with @JsonSerializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Configure Firebase
dart pub global run flutterfire_cli:flutterfire configure

# Generate native splash screen
flutter pub run flutter_native_splash:create

# Run tests
flutter test
flutter test test/path_to_test.dart   # single test file

# Analyze code
flutter analyze
```

## Architecture

**Feature-based structure** — each feature in `lib/features/` follows a clean architecture pattern with three layers:

- `data/` — `datasources/` (API calls via Dio), `models/` (JSON-serializable data classes)
- `domain/` — `repositories/` (abstract repository interfaces)
- `presentation/` — `cubit/` (BLoC/Cubit state management), `pages/`, `widgets/`

**Core layer** (`lib/core/`) contains shared infrastructure:
- `routing/app_routing.dart` — GoRouter configuration, all app routes defined here
- `providers/language_provider.dart` — locale management via ChangeNotifier
- `urls.dart` — API base URL and image CDN URL constants
- `widgets/` — reusable UI components
- `utils/translation_utils.dart` — localization helpers

**State management** uses a mixed approach:
- **flutter_bloc** (Cubits) for feature-level state — all cubits are provided globally in `main.dart` via `MultiBlocProvider`
- **flutter_riverpod** wraps the entire app (`ProviderScope`) 
- **provider** package for `LanguageProvider`

**API layer**: Dio-based HTTP client. Base URL: `https://api.iris-cosmetics.kz/`. Image assets served from MinIO at `https://minio.iris-cosmetics.kz/iris/`.

**Routing**: GoRouter with flat route structure. Routes pass complex objects via `state.extra`. Defined in `lib/core/routing/app_routing.dart`.

**Localization**: ARB-based (`lib/l10n/`). Template file is `app_en.arb`. Generated class is `AppLocalizations`. Run `flutter gen-l10n` after editing ARB files.

## Key Conventions

- Models use `json_serializable` — add `@JsonSerializable()` annotation and run build_runner to generate `.g.dart` files
- Font family is Gilroy (defined in pubspec.yaml), but theme sets `fontFamily: 'Inter'`
- Firebase is used for push notifications (firebase_messaging + awesome_notifications)
- SDK constraint: `^3.7.0`
