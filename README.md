# Voca — High-Contrast Accessible Dating App

A Flutter dating app built with a strict **Black & White monochrome theme** targeting **WCAG 2.1 AA** accessibility compliance.

---

## Tech Stack

| Concern | Package |
|---|---|
| State Management | `flutter_riverpod` + `riverpod_annotation` (code-gen) |
| Navigation | `go_router` (declarative, typed routes) |
| HTTP Networking | `dio` (with custom logging interceptors) |
| Accessibility audit | `accessibility_tools` |
| Haptics | `flutter_haptic` |
| Fonts | `google_fonts` (Inter) |

---

## Project Structure

```
lib/
├── main.dart                          # Entry point — ProviderScope + MaterialApp.router + AccessibilityTools
└── src/
    ├── routing/
    │   └── app_router.dart            # GoRouter — / (FeedScreen) and /profile/:userId (ProfileScreen)
    ├── shared/
    │   ├── theme/
    │   │   └── app_theme.dart         # Strict B&W ColorScheme.dark, bold 3px focus borders (keyboard nav)
    │   ├── utils/
    │   │   └── app_logger.dart        # Chunked logging utility to avoid console truncation
    │   └── widgets/
    │       ├── accessible_tappable.dart  # Semantics + min 48×48 tap target + HapticFeedback
    │       ├── accessible_button.dart    # Elevated/Outlined button with haptics + semantic label
    │       └── accessible_card.dart      # MergeSemantics card — screen reader reads as one announcement
    ├── features/
    │   ├── feed/
    │   │   ├── domain/
    │   │   │   ├── feed_profile.dart          # Legacy FeedProfile model (DEPRECATED)
    │   │   │   └── profile_model.dart         # New Profile model with fromJson/toJson
    │   │   ├── data/
    │   │   │   └── feed_repository.dart       # Repository pattern — Abstract + HTTP + Mock implementations
    │   │   ├── application/
    │   │   │   └── feed_provider.dart         # @riverpod FeedNotifier with API integration + error handling
    │   │   └── presentation/
    │   │       └── feed_screen.dart           # Card-style feed UI with Like / Pass actions
    │   └── profile/
    │       ├── domain/
    │       │   └── user_profile.dart          # UserProfile model with interests list
    │       ├── application/
    │       │   └── profile_provider.dart      # Async @riverpod provider — fetch by userId
    │       └── presentation/
    │           └── profile_screen.dart        # Full profile view with interests chips
    └── services/
        ├── network/
        │   └── api_client.dart        # Dio HTTP client with logging interceptor
        └── haptics_service.dart       # Centralised haptic patterns (light, medium, heavy, warning)
```

---

## Accessibility Design Decisions

- **MergeSemantics** on every profile card — screen reader announces name, age, and bio as a single item instead of requiring three swipes.
- Every `Image` carries a descriptive `semanticsLabel` (e.g. `"Photo of Sarah, smiling in a park"`).
- All interactive elements meet the **48×48 dp minimum tap target** mandated by WCAG 2.1 Success Criterion 2.5.5.
- **Bold focus borders** (3 px white outline) on all inputs and interactive surfaces for keyboard/switch-access navigation.
- `AccessibilityTools` widget wraps the entire app in debug mode to surface accessibility violations at runtime.

---

## Theme

`AppTheme.darkTheme` uses `ColorScheme.dark` with:

- `primary` → `Colors.white` (on `Colors.black` background) — contrast ratio ≥ 21:1
- All buttons, chips, and borders use white-on-black or black-on-white only
- No colour is used to convey meaning alone

---

## Navigation

Routes are declared in `app_router.dart` using a `@riverpod` GoRouter:

| Route | Name | Screen |
|---|---|---|
| `/` | `feed` | `FeedScreen` |
| `/profile/:userId` | `profile` | `ProfileScreen` |

Deep-link to a profile:
```dart
context.pushNamed('profile', pathParameters: {'userId': '42'});
```

---

## Getting Started

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Run code generation (Riverpod)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> For continuous generation during development:
> ```bash
> flutter pub run build_runner watch --delete-conflicting-outputs
> ```

### 3. Run the app
```bash
flutter run
```

### 4. Analyze
```bash
flutter analyze
```

---

## API Integration & Logging

### Chunked Logging
`AppLogger` utility automatically chunks log messages over 800 characters to avoid Flutter's console truncation:

```dart
AppLogger.log('Your very long message here...'); // Auto-chunked if needed
AppLogger.logError('API error details...');     // For error logging
AppLogger.logData('Large JSON response...');     // For data logging
```

### Repository Pattern
The app uses a clean repository pattern for data fetching:

- **`FeedRepository`** (abstract) - Contract for data operations
- **`HttpFeedRepository`** - Production API implementation
- **`MockFeedRepository`** - Fallback/development data source

### HTTP Client
`apiClient` provider configures Dio with:
- Custom logging interceptor for all requests/responses
- Automatic fallback to mock data on network failures
- Base URL configuration and timeout handling

---

## Roadmap / Next Steps

- [x] ✅ **API Integration** — Repository pattern with Dio HTTP client
- [x] ✅ **Chunked Logging** — Console-friendly logging utility
- [x] ✅ **Error Handling** — Graceful fallbacks and user feedback
- [ ] Replace mock API base URL with production endpoint
- [ ] Implement swipe gesture (Dismissible or gesture detector) on the feed card
- [ ] Add authentication and user management
- [ ] Add a messaging feature (`features/messaging/`)
- [ ] Implement match detection and notification
- [ ] Add deep-link support for "Share Profile" via `/profile/:userId`
- [ ] Write widget and integration tests for feed and profile flows
- [ ] CI/CD pipeline with `flutter analyze` + `flutter test` gates
