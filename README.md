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
    │   └── app_router.dart            # GoRouter with onboarding protection and routing
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
    │   ├── onboarding/                    # ✨ NEW — User registration onboarding flow
    │   │   ├── domain/
    │   │   │   └── onboarding_state.dart      # OnboardingState model with steps and completion status
    │   │   ├── application/
    │   │   │   └── onboarding_provider.dart   # StateNotifierProvider for onboarding flow
    │   │   └── presentation/
    │   │       ├── simple_select_registration_type_screen.dart   # Choose manual vs AI voice
    │   │       ├── simple_manual_registration_screen.dart       # Traditional form registration
    │   │       ├── simple_ai_voice_registration_screen.dart     # Voice-powered registration
    │   │       └── simple_audio_playback_screen.dart            # Review voice recordings
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

Routes are declared in `app_router.dart` using a `@riverpod` GoRouter with onboarding protection:

| Route | Name | Screen | Protected |
|---|---|---|---|
| `/onboarding` | `onboarding` | `SimpleSelectRegistrationTypeScreen` | No |
| `/` | `feed` | `FeedScreen` | Yes (requires onboarding) |
| `/profile/:userId` | `profile` | `ProfileScreen` | Yes (requires onboarding) |

### Onboarding Flow Protection
The router automatically redirects users to `/onboarding` if they haven't completed registration. Once onboarding is complete, users are redirected to the main app.

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
- [x] ✅ **Onboarding Flow** — User registration with manual and AI voice options
- [x] ✅ **Route Protection** — Automatic redirect to onboarding for new users
- [x] ✅ **Voice Registration** — Simulated AI voice capture and audio playback
- [x] ✅ **Accessibility Integration** — Full WCAG compliance in onboarding flow
- [ ] Replace mock API base URL with production endpoint
- [ ] Implement real audio recording and playback functionality
- [ ] Add user persistence (SharedPreferences/Secure Storage)
- [ ] Implement swipe gesture (Dismissible or gesture detector) on the feed card
- [ ] Add authentication and user management
- [ ] Add a messaging feature (`features/messaging/`)
- [ ] Implement match detection and notification
- [ ] Add deep-link support for "Share Profile" via `/profile/:userId`
- [ ] Write widget and integration tests for feed and profile flows
- [ ] CI/CD pipeline with `flutter analyze` + `flutter test` gates

---

## Development Log

### 2024-03-14: Accessibility & Theme Consistency Fixes
**Issues Fixed:**
1. **Accessibility Violations** — Added semantic labels and tooltips to all `IconButton` widgets in onboarding screens
2. **Navigation Error** — Replaced `Navigator.pop()` calls with GoRouter's `context.go()` to prevent "popped last page off stack" errors
3. **Theme Consistency** — Refactored all onboarding screens to follow strict B&W theme:
   - Removed gradients, `Colors.grey[]` shades, and colored backgrounds
   - Applied consistent black background with white text/borders
   - Updated all buttons to use white-on-black or black-on-white only
   - Fixed `AlertDialog` styling to match B&W theme

**Files Modified:**
- `simple_manual_registration_screen.dart` — B&W theme, GoRouter navigation, semantic labels
- `simple_select_registration_type_screen.dart` — B&W theme, removed gradient
- `simple_ai_voice_registration_screen.dart` — B&W theme, GoRouter navigation, semantic labels
- `simple_audio_playback_screen.dart` — B&W theme, GoRouter navigation, semantic labels

---

### ✅ Onboarding Feature Implementation (Latest)
**Architecture Integration**: Successfully integrated 4-screen onboarding flow following established clean architecture patterns.

#### Features Implemented:
- **Route Protection**: Automatic redirect to onboarding for unregistered users
- **Registration Options**: Manual form vs AI voice registration paths
- **Voice Registration**: Simulated AI voice capture with step-by-step recording
- **Audio Playback**: Review interface with play/pause controls and seek functionality
- **State Management**: Riverpod StateNotifier for onboarding flow coordination
- **Accessibility**: Full WCAG 2.1 AA compliance with semantic labels and focus management
- **Black & White Theme**: Consistent monochrome design throughout onboarding

#### Technical Implementation:
- **Clean Architecture**: Domain/Application/Presentation layers
- **State Management**: `onboardingNotifierProvider` with `StateNotifier`
- **Navigation**: GoRouter with redirect logic for onboarding protection
- **Accessibility**: Semantic labels, screen reader support, keyboard navigation
- **Responsive Design**: SingleChildScrollView with ConstrainedBox for overflow protection

#### File Structure:
```
src/features/onboarding/
├── domain/onboarding_state.dart           # Onboarding steps and state model
├── application/onboarding_provider.dart   # State management with StateNotifier
└── presentation/                          # UI screens
    ├── simple_select_registration_type_screen.dart
    ├── simple_manual_registration_screen.dart
    ├── simple_ai_voice_registration_screen.dart
    └── simple_audio_playback_screen.dart
```

#### Integration Points:
- **App Router**: Updated with onboarding route and protection logic
- **Main App**: Onboarding completion gates access to feed and profile screens
- **Theme**: Consistent black & white design system
- **Accessibility**: Integration with existing accessible widgets
