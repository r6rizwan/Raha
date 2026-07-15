# Raha Frontend

Flutter mobile app for Raha. It helps expats discover home-style food, book services, and get AI-powered recommendations.

## Features

- Firebase Auth with Google Sign-In and email/password
- Onboarding flow for nationality, city, neighbourhood, and interests
- Stateful bottom-tab navigation with Home, Food, Services, and Profile
- Home recommendations powered by the backend recommendation API
- Food discovery by city and cuisine with live place detail enrichment
- Food detail photos served through the backend Google Places photo proxy
- Service booking flow with booking history and cancellation
- Edit profile screen for name, city, neighbourhood, and nationality
- App update checker backed by the backend `/health` endpoint
- Branded splash screen and launcher icons
- Offline support with cached read fallback in Flutter repositories
- Arabic and English support with locale switching
- RTL support for Arabic

## Stack

- Flutter 3 / Dart 3.11+
- Riverpod
- GoRouter
- Dio
- Firebase Core + Firebase Auth
- Google Sign-In
- Flutter Secure Storage
- Cached Network Image
- Shimmer
- url_launcher

## Project Layout

```txt
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── router/
│   └── theme/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── features/
│   ├── auth/
│   ├── food/
│   ├── home/
│   ├── onboarding/
│   ├── profile/
│   └── services/
└── shared/
    └── widgets/
```

## Setup

### Requirements

- Flutter stable
- Android Studio / Android SDK
- Xcode for iOS builds on macOS
- A Firebase project with Android and iOS apps configured

### Install dependencies

```sh
cd frontend
flutter pub get
```

### Firebase files

Place the Firebase client config files here:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

Android package name:

```txt
com.raha.mobile
```

### Base URL & Google Sign-In

The app reads configuration variables from `--dart-define`.

- `BASE_URL`: The backend server URL.
- `GOOGLE_WEB_CLIENT_ID`: The Web Client ID from the Firebase/Google Cloud Console (needed to prevent `clientConfigurationError` on Android).

If `BASE_URL` is not provided, the app defaults to:

```txt
http://10.0.2.2:5000
```

That default is only suitable for the Android emulator against a local backend.

Android emulator run example:

```sh
flutter run \
  --dart-define=BASE_URL=http://10.0.2.2:5000 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=your_web_client_id.apps.googleusercontent.com
```

iOS simulator run example:

```sh
flutter run \
  --dart-define=BASE_URL=http://localhost:5000 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=your_web_client_id.apps.googleusercontent.com
```

Release example:

```sh
flutter build apk --release --split-per-abi \
  --obfuscate --split-debug-info=build/debug-info \
  --dart-define=BASE_URL=https://your-production-api.example
```

Local helper from repo root:

```sh
chmod +x build_apk.sh
./build_apk.sh
```

This writes the APK to:

```txt
build_artifacts/raha-v<version>.apk
```

## Quality checks

```sh
flutter analyze
flutter test
```

## Notes

- The app expects the backend `/health` endpoint to return `minAppVersion`, `latestAppVersion`, and `updateUrl`.
- The repo also exposes `/api/health` for the backend keep-warm GitHub Action.
- Food detail images come from backend proxy URLs, so the mobile app never receives the raw Google Places server key.
- Native splash and launcher icons are configured through `flutter_native_splash` and `flutter_launcher_icons`.
- Production builds should use an HTTPS backend URL.
