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
    │   └── app_router.dart            # GoRouter with onboarding + questionnaire protection
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
    │   ├── auth/
    │   │   └── presentation/
    │   │       └── sign_in_screen.dart       # Simple sign-in form (email + password) with bottom Sign Up action
    │   ├── onboarding/
    │   │   ├── domain/
    │   │   │   └── onboarding_state.dart      # OnboardingState model with steps and completion status
    │   │   ├── application/
    │   │   │   └── onboarding_provider.dart   # StateNotifierProvider for onboarding flow
    │   │   └── presentation/
    │   │       ├── simple_select_registration_type_screen.dart   # Choose manual vs AI voice
    │   │       ├── simple_manual_registration_screen.dart       # Traditional form registration
    │   │       ├── simple_ai_voice_registration_screen.dart     # Voice-powered registration
    │   │       └── simple_audio_playback_screen.dart            # Review voice recordings
    │   ├── questionnaire/                  # ✨ Personality & preferences questionnaire
    │   │   ├── domain/
    │   │   │   ├── question_model.dart        # QuestionModel + QuestionType enum (API-ready)
    │   │   │   ├── questionnaire_state.dart   # QuestionnaireState with answers, progress, payload builder
    │   │   │   └── questionnaire_questions.dart # Default question definitions (18 questions)
    │   │   ├── application/
    │   │   │   └── questionnaire_provider.dart # StateNotifierProvider for questionnaire flow
    │   │   └── presentation/
    │   │       ├── questionnaire_screen.dart   # Step-by-step questionnaire UI
    │   │       └── widgets/
    │   │           ├── question_widget_factory.dart  # Dynamic widget mapper
    │   │           ├── text_question_widget.dart     # Text / number input
    │   │           ├── single_choice_widget.dart     # Radio-style single selection
    │   │           ├── multi_choice_widget.dart      # Chip-style multi / pickN selection
    │   │           ├── slider_question_widget.dart   # Continuous slider + discrete scale
    │   │           └── emoji_choice_widget.dart      # Emoji-based single choice
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

Routes are declared in `app_router.dart` using a `@riverpod` GoRouter with onboarding + questionnaire protection:

| Route | Name | Screen | Protected |
|---|---|---|---|
| `/sign-in` | `sign-in` | `SignInScreen` | No |
| `/onboarding` | `onboarding` | `SimpleSelectRegistrationTypeScreen` | No |
| `/questionnaire` | `questionnaire` | `QuestionnaireScreen` | Yes (requires onboarding) |
| `/` | `feed` | `FeedScreen` | Yes (requires onboarding + questionnaire) |
| `/profile/:userId` | `profile` | `ProfileScreen` | Yes (requires onboarding + questionnaire) |

### User Flow Protection
The router enforces this progression:

```
Sign In → Onboarding → Questionnaire → Feed
```

- Users who haven't completed onboarding are redirected to `/onboarding`
- Users who completed onboarding but not the questionnaire are redirected to `/questionnaire`
- Users who completed both are allowed into the main app

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
- [x] ✅ **Authentication Entry UI** — Sign In screen with bottom Sign Up action
- [x] ✅ **Onboarding Flow** — User registration with manual and AI voice options
- [x] ✅ **Route Protection** — Automatic redirect to onboarding for new users
- [x] ✅ **Voice Registration** — Simulated AI voice capture and audio playback
- [x] ✅ **Accessibility Integration** — Full WCAG compliance in onboarding flow
- [x] ✅ **Questionnaire Flow** — 18-question personality & preferences setup with dynamic widget system
- [x] ✅ **Questionnaire Route Protection** — Users must complete questionnaire before accessing feed
- [ ] Replace mock API base URL with production endpoint
- [ ] Connect questionnaire payload to backend API endpoint
- [ ] Implement real audio recording and playback functionality
- [ ] Add user persistence (SharedPreferences/Secure Storage)
- [ ] Implement swipe gesture (Dismissible or gesture detector) on the feed card
- [ ] Complete authentication and user management (backend/session/sign-up flow)
- [ ] Add a messaging feature (`features/messaging/`)
- [ ] Implement match detection and notification
- [ ] Add deep-link support for "Share Profile" via `/profile/:userId`
- [ ] Write widget and integration tests for feed and profile flows
- [ ] CI/CD pipeline with `flutter analyze` + `flutter test` gates

---

## Development Log

### 2026-03-14: Questionnaire / Personality Setup Flow
**Feature Implemented:**
Dynamic 18-question personality questionnaire inserted between onboarding and the main feed.

**Architecture:**
- **Domain**: `QuestionModel` with `QuestionType` enum (text, number, singleChoice, multiChoice, pickN, slider, scale, emojiChoice)
- **Application**: `QuestionnaireNotifier` StateNotifier with answer tracking, step navigation, validation, and API payload builder
- **Presentation**: `QuestionnaireScreen` with `QuestionWidgetFactory` dispatching to 5 specialized widgets
- **Navigation**: `/questionnaire` route with redirect protection (onboarding → questionnaire → feed)

**Files Created:**
- `features/questionnaire/domain/question_model.dart` — QuestionModel + QuestionType enum
- `features/questionnaire/domain/questionnaire_state.dart` — Immutable state with payload builder
- `features/questionnaire/domain/questionnaire_questions.dart` — 18 default questions
- `features/questionnaire/application/questionnaire_provider.dart` — StateNotifier provider
- `features/questionnaire/presentation/questionnaire_screen.dart` — Step-by-step UI
- `features/questionnaire/presentation/widgets/question_widget_factory.dart` — Dynamic widget mapper
- `features/questionnaire/presentation/widgets/text_question_widget.dart` — Text/number input
- `features/questionnaire/presentation/widgets/single_choice_widget.dart` — Radio-style selection
- `features/questionnaire/presentation/widgets/multi_choice_widget.dart` — Multi/pickN chip selection
- `features/questionnaire/presentation/widgets/slider_question_widget.dart` — Slider + scale
- `features/questionnaire/presentation/widgets/emoji_choice_widget.dart` — Emoji choice cards

**Files Modified:**
- `routing/app_router.dart` — Added `/questionnaire` route + updated redirect logic

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
