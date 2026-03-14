# Voca — High-Contrast Accessible Dating App

A Flutter dating app built with a strict **Black & White monochrome theme** targeting **WCAG 2.1 AA** accessibility compliance.

---

## Tech Stack

| Concern | Package |
|---|---|
| State Management | `flutter_riverpod` + `riverpod_annotation` (code-gen) |
| Navigation | `go_router` (declarative, typed routes) |
| HTTP Networking | `dio` (with custom logging interceptors) |
| Secure Token Storage | `flutter_secure_storage` (Keychain / EncryptedSharedPreferences) |
| Accessibility audit | `accessibility_tools` |
| Haptics | `flutter_haptic` |
| Fonts | `google_fonts` (Inter) |
| Local persistence | `shared_preferences` |

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
    │   │   ├── application/
    │   │   │   └── auth_api_service.dart      # AuthApiService — signup, login, logout, logoutAll
    │   │   └── presentation/
    │   │       └── sign_in_screen.dart         # Sign-in form wired to login API + bottom Sign Up action
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
        │   ├── api_client.dart            # Dio HTTP client, endpoint constants, logging interceptor
        │   ├── api_exception.dart         # ApiException — typed error with statusCode, message, fieldErrors
        │   └── token_storage_service.dart # TokenStorageService — secure token persistence (Keychain / EncryptedSharedPrefs)
        └── haptics_service.dart           # Centralised haptic patterns (light, medium, heavy, warning)
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

### API Service Layer

The app uses a centralized **service layer** that encapsulates all API calls behind typed Dart classes with Riverpod providers. Screens never interact with Dio directly.

| Service | Provider | Endpoints |
|---|---|---|
| `AuthApiService` | `authApiServiceProvider` | `POST /auth/signup`, `POST /auth/login`, `POST /auth/logout`, `POST /auth/logout-all` |
| `UserApiService` | `userApiServiceProvider` | `GET /users/me`, `PATCH /users/me`, `PATCH /users/me/password`, `DELETE /users/me` |
| `TokenStorageService` | `tokenStorageProvider` | Secure read/write/clear of `userToken` + `sessionToken` |

#### Usage Example
```dart
// In a ConsumerState or ConsumerWidget:
final authService = ref.read(authApiServiceProvider);

try {
  final data = await authService.login(email: email, password: password);
  // Tokens are persisted automatically — navigate forward
} on ApiException catch (e) {
  // Structured server error (400, 401, 409, etc.)
  showSnackbar(e.displayMessage);
  // Per-field validation: e.fieldErrors?['email']
} on DioException catch (e) {
  // Network / timeout error
  showSnackbar('Check your connection.');
}
```

#### Error Handling — `ApiException`
Server errors with JSON bodies are wrapped in `ApiException`:
- `statusCode` — HTTP status (400, 401, 409…)
- `message` — `String` or `Map<String, String>` of per-field errors
- `displayMessage` — single human-readable string (joins field errors)
- `fieldErrors` — nullable `Map<String, String>` for per-field highlighting

### Token Storage
Tokens are stored using **`flutter_secure_storage`** (Keychain on iOS, EncryptedSharedPreferences on Android) instead of plain `SharedPreferences`:
- `saveTokens()` / `getUserToken()` / `getSessionToken()` / `hasSession()` / `clearAll()`
- Auth services call `saveTokens` automatically after signup/login
- Logout calls `clearAll` automatically

### HTTP Client
`apiClientProvider` configures Dio with:
- Custom `LoggingInterceptor` for all requests/responses/errors
- Base URL: `https://ckn4m91r-3000.inc1.devtunnels.ms`
- 15-second timeouts (connect, receive, send)
- JSON content-type headers

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

### Authentication Status
- **Sign Up** — `AuthApiService.signup()` → `POST /auth/signup` with email, password, phoneNumber
- **Sign In** — `AuthApiService.login()` → `POST /auth/login` with email, password
- **Logout** — `AuthApiService.logout()` / `logoutAll()` → clears secure storage
- Sign up navigates forward only on `201 Created`; sign in on `200 OK`
- Tokens (`userToken`, `sessionToken`) are securely persisted via `flutter_secure_storage`
- `ApiException` provides structured error handling (validation, duplicate-user, unauthorized)
- All errors logged via `AppLogger` and surfaced to users via white-on-black `SnackBar`

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
- [x] ✅ **Manual Sign Up API Flow** — `/auth/signup` wired with `201`-only navigation and error handling
- [x] ✅ **Sign In API Flow** — `/auth/login` wired via `AuthApiService` with loading state and error handling
- [x] ✅ **API Service Layer** — Centralized `AuthApiService` + `UserApiService` with `ApiException` error model
- [x] ✅ **Secure Token Storage** — `flutter_secure_storage` replaces `SharedPreferences` for credentials
- [x] ✅ **User Persistence** — `userToken` and `sessionToken` stored securely
- [ ] Replace devtunnel API base URL with production endpoint
- [ ] Connect questionnaire payload to backend API endpoint
- [ ] Implement real audio recording and playback functionality
- [ ] Implement swipe gesture (Dismissible or gesture detector) on the feed card
- [ ] Complete remaining authentication flows (session restore, sign-out UI, profile bootstrap)
- [ ] Add a messaging feature (`features/messaging/`)
- [ ] Implement match detection and notification
- [ ] Add deep-link support for "Share Profile" via `/profile/:userId`
- [ ] Write widget and integration tests for feed and profile flows
- [ ] CI/CD pipeline with `flutter analyze` + `flutter test` gates

---

## Development Log

### 2026-03-15: API Service Layer & Secure Token Storage
**Feature Implemented:**
Centralized all API interactions behind typed service classes with Riverpod providers. Replaced `SharedPreferences` with `flutter_secure_storage` for credential persistence. Wired sign-in screen to the login endpoint.

**Architecture:**
- **Service layer pattern** — Screens call `ref.read(authApiServiceProvider)` / `ref.read(userApiServiceProvider)` instead of using Dio directly
- **Typed exceptions** — `ApiException` wraps server error JSON with `statusCode`, `message`, `displayMessage`, `fieldErrors`
- **Secure storage** — `TokenStorageService` wraps `flutter_secure_storage` for Keychain/EncryptedSharedPrefs token persistence
- **Auto-token management** — `signup()` and `login()` persist tokens automatically; `logout()` clears them

**What Changed:**
1. **`api_client.dart`** — Added all endpoint constants: `AuthApiEndpoints` (signup, login, logout, logoutAll) + `UserApiEndpoints` (me, changePassword)
2. **`api_exception.dart`** *(new)* — `ApiException` with `displayMessage` and `fieldErrors` getters
3. **`token_storage_service.dart`** *(new)* — Secure token CRUD with `tokenStorageProvider`
4. **`auth_api_service.dart`** *(new)* — `AuthApiService` with `signup`, `login`, `logout`, `logoutAll` + `authApiServiceProvider`
5. **`user_api_service.dart`** *(new)* — `UserApiService` with `getProfile`, `updateProfile`, `changePassword`, `deleteAccount` + `userApiServiceProvider`
6. **`manual_registration_screen.dart`** — Refactored to use `AuthApiService` instead of raw Dio + SharedPreferences
7. **`sign_in_screen.dart`** — Converted to `ConsumerStatefulWidget`, wired `_handleSignIn` to `AuthApiService.login()`, added loading spinner, added semantic label to password toggle IconButton (fixing accessibility audit warning)
8. **`pubspec.yaml`** — Added `flutter_secure_storage`

**Files Created:**
- `lib/src/services/network/api_exception.dart`
- `lib/src/services/network/token_storage_service.dart`
- `lib/src/features/auth/application/auth_api_service.dart`
- `lib/src/features/profile/application/user_api_service.dart`

**Files Modified:**
- `lib/src/services/network/api_client.dart`
- `lib/src/features/onboarding/presentation/manual_registration_screen.dart`
- `lib/src/features/auth/presentation/sign_in_screen.dart`
- `pubspec.yaml`

---

### 2026-03-15: Manual Sign Up API Integration
**Feature Implemented:**
Completed the backend-driven manual sign up flow and aligned the entry path from the sign-in screen to onboarding.

**What Changed:**
1. **Live API Base URL** — Updated `api_client.dart` to use the configured devtunnel API base URL instead of the placeholder host
2. **Sign Up Endpoint Integration** — Connected manual registration to `POST /auth/signup` with payload fields `email`, `password`, and `phoneNumber`
3. **Strict Success Gating** — Navigation now happens only after a `201 Created` response from the backend
4. **Token Persistence** — Stored `userToken` and `sessionToken` in `SharedPreferences` after successful registration
5. **Error Handling** — Added error logging plus `SnackBar` feedback for validation, duplicate-user, throttling, and unexpected API failures
6. **Entry Flow Fix** — Updated the Sign Up button on the sign-in screen to open onboarding and routed the active onboarding manual path to `manual_registration_screen.dart`

**Files Modified:**
- `lib/src/services/network/api_client.dart` — Added devtunnel base URL and auth endpoint constant
- `lib/src/features/onboarding/presentation/manual_registration_screen.dart` — Implemented backend sign up, token storage, and `201`-gated navigation
- `lib/src/features/auth/presentation/sign_in_screen.dart` — Sign Up CTA now opens onboarding
- `lib/src/features/onboarding/presentation/simple_select_registration_type_screen.dart` — Manual option now opens the API-enabled registration screen
- `pubspec.yaml` — Added `shared_preferences`

---

### 2026-03-14: Manual Registration Screen Improvements
**Issues Fixed:**
1. **Back Button Navigation** — Changed `context.go('/onboarding')` to `Navigator.pop(context)` so the header back button properly returns to the registration type selection screen
2. **Removed Redundant Button** — Removed the "Back to Registration Type" TextButton below the Register button
3. **Phone Number Validation** — Implemented E.164 international standard validation:
   - Accepts multiple formats: `+1234567890`, `(123) 456-7890`, `123-456-7890`
   - Minimum 10 digits, maximum 15 digits per ITU-T E.164
   - International format validation when `+` prefix is present
   - Normalizes phone numbers for API storage
4. **Password Validation** — Enhanced to industry standards:
   - Minimum 8 characters (up from 6)
   - Requires at least one uppercase letter
   - Requires at least one lowercase letter
   - Requires at least one number
5. **Email Validation** — Added RFC 5322 compliant regex validation
6. **Error Styling** — Added proper `errorBorder` and `focusedErrorBorder` styling for B&W theme consistency

**Files Modified:**
- `simple_manual_registration_screen.dart` — All improvements above

---

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
