## Running Club Tunis – Hackaton Project

This repository contains the Flutter application for **Running Club Tunis**, organized under the `app` directory. The root only adds Git metadata and this `README`; **all source code lives in `app/`**.

### Project structure

- **`app/`**: main Flutter application
  - **`lib/main.dart`**: application entry point, sets up:
    - localization (French, English, Arabic, Italian, German) with `flutter_localizations` and `AppLocalizations`
    - theming and text scaling via `AppTheme`, `ThemeModeProvider`, `TextScaleProvider`, `LocaleProvider`
    - push notifications via `PushNotificationService` (Firebase Cloud Messaging)
    - authentication bootstrap via `AuthWrapper` (redirects to welcome screen, member main screen, or change-password screen)
  - **`lib/screens/`**: feature screens
    - `evenement_serie_form_screen.dart`: form to create **daily or weekly event series** (trainings, long runs). It:
      - loads running groups from the backend (`GroupeService`)
      - lets the user pick a date range, time, and mode (daily / weekly)
      - optionally picks a meeting location on a map (`LieuPickerScreen`)
      - creates multiple events in the backend via `EvenementService` using `EvenementRequest`
  - **`lib/widgets/`**: shared UI components (navigation drawer, floating nav bar, language/theme/text-scale switches, etc.)
  - **`lib/l10n/`**: localization (`app_localizations.dart` and ARB/strings files)
  - **`lib/services/`**: API, storage, and push-notification services
    - `AuthService` + `StorageService` to persist user + token and restore on startup
    - `PushNotificationService` for FCM initialization and token registration against the backend
  - **`lib/models/`**: request/response DTOs such as `LoginResponse`, `EvenementRequest`, `GroupeRunning`, etc.
  - **`test/`**: Flutter widget and feature tests (accessibility, language switch, basic smoke tests)
  - **`pubspec.yaml`**: Flutter and Dart configuration, including:
    - **SDK**: Dart `^3.10.4`
    - **Core**: `flutter`, `flutter_localizations`, `cupertino_icons`
    - **Networking & storage**: `http`, `shared_preferences`
    - **Firebase push**: `firebase_core`, `firebase_messaging`
    - **Location & maps**: `geolocator`, `flutter_map`, `latlong2`
    - **Utilities**: `url_launcher`, `share_plus`
    - **Dev**: `flutter_test`, `flutter_lints`
  - **`web/`, `android/`, `ios/`, `macos/`**: platform-specific runners and configuration (including `google-services.json` and FCM setup files).

The file `app/README.md` is the default Flutter template README; this root README is the primary documentation for this project.

### Prerequisites

- **Flutter SDK** installed (matching at least **Dart `^3.10.4`** as declared in `app/pubspec.yaml`)
- **Dart** (bundled with Flutter)
- A configured **IDE** (Android Studio, VS Code, or IntelliJ) or Flutter command-line tools
- For Firebase push notifications:
  - Valid Firebase project configuration for each target platform (Android `google-services.json`, iOS/macOS `GoogleService-Info.plist`, web FCM config in `index.html`/`firebase-messaging-sw.js`)
  - Backend endpoint reachable by the app for token registration and event/group APIs

### How to install dependencies

From the repository root:

```bash
cd app
flutter pub get
```

This will download all Dart/Flutter packages defined in `pubspec.yaml`.

### How to run the app

1. **Change into the app directory**:

   ```bash
   cd app
   ```

2. **Make sure Flutter sees your device/emulator**:

   ```bash
   flutter devices
   ```

   Start an Android emulator, iOS simulator, or connect a physical device as needed.

3. **Run in debug mode**:

   ```bash
   flutter run
   ```

   Flutter will build and launch the app on the selected device.

4. **Run for specific platforms** (optional):

   - Android: `flutter run -d android`
   - iOS: `flutter run -d ios`
   - Web (if enabled): `flutter run -d chrome`

### How authentication & startup flow work (overview)

- On startup, `main()`:
  - ensures Flutter bindings are initialized
  - configures a custom `ErrorWidget` to log build errors
  - initializes `PushNotificationService` (wrapped in a `try` so app still runs when FCM is not configured)
  - launches `MyApp`
- `MyApp` creates notifiers for theme mode, text scale, and locale, and injects them with providers.
- `AuthWrapper`:
  - checks for a stored token via `AuthService`
  - loads the serialized user from `StorageService`
  - if the user exists and must change password ⇒ shows `ChangePasswordScreen`
  - if the user exists ⇒ shows `MemberMainScreen`
  - otherwise ⇒ shows `WelcomeScreen`
  - once authenticated, it also registers the FCM token with the backend and retries a few times if registration initially fails.

### How event series creation works (overview)

- `EvenementSerieFormScreen` lets club admins or organizers:
  - select a running group
  - choose **daily** or **weekly** mode
  - pick:
    - time of day
    - date range
    - for weekly mode: day of the week
  - enter an optional description and meeting location, or pick the location from a map.
- The screen computes:
  - **daily mode**: every day between start and end (inclusive)
  - **weekly mode**: all dates that fall on the selected weekday in the date range
- For each computed date, it builds an `EvenementRequest` and calls `EvenementService.create(...)`.
- On success, a localized success message is shown and the screen pops with `true`; on error, it:
  - displays a localized error message (and how many events were created before the failure)
  - logs the error string.

### How to run tests

From inside the `app` directory:

```bash
cd app
flutter test
```

This will execute the tests under `test/`, including widget and feature tests (accessibility, language switching, etc.).

### Environment & configuration notes

- **Firebase**:
  - Make sure `firebase_core` and `firebase_messaging` are properly configured using `flutterfire configure`.
  - Place configuration files (`google-services.json`, `GoogleService-Info.plist`, etc.) in the correct platform directories.
  - Ensure your backend endpoints for registering FCM tokens and managing events/groups are reachable from the devices you test on.
- **Maps & location**:
  - `geolocator` is used to access GPS; you must accept location permissions when prompted on the device.
  - `flutter_map` + `latlong2` are used with OpenStreetMap tiles (no API key required by default), but you may configure your own tile server if needed.
- **Localization**:
  - Supported languages are French (`fr`), English (`en`), Arabic (`ar`), Italian (`it`), and German (`de`).
  - New strings are added via the localization system in `lib/l10n/`.

### Production build commands

From inside `app`:

- **Android APK**:

  ```bash
  flutter build apk --release
  ```

- **Android App Bundle**:

  ```bash
  flutter build appbundle --release
  ```

- **iOS** (requires macOS + Xcode):

  ```bash
  flutter build ios --release
  ```

- **Web**:

  ```bash
  flutter build web --release
  ```

Adjust signing, bundle identifiers, and store metadata in the platform-specific projects as usual for Flutter.

