# Raha Mobile App

The frontend of the Raha platform, built with **Flutter** and **Dart**. The app is optimized for expats in the UAE, providing them with a user-friendly interface to configure their profiles, discover local cuisines, book services, and get AI-powered concierge recommendations.

---

## 🚀 Key Features

* **Expat Onboarding**: Interactive profile setup capturing nationality, city, neighborhood, and interests.
* **AI Concierge Dashboard**: A dynamic homepage displaying personalized recommendations (restaurants, services, and expat tips) powered by Gemini.
* **Cuisine Discovery**: Search and filter options for authentic home cuisines, with detail views enriched by the Google Places API.
* **Service Booking**: Intuitive listing of verified service providers (cleaners, handymen) and a booking scheduling flow.
* **Firebase Authentication**: Secure client-side authentication with email/password signup and login.

---

## 🛠️ Tech Stack & Libraries

* **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod) and `riverpod_generator` for clean, modular, and reactive state management.
* **Navigation & Routing**: [GoRouter](https://pub.dev/packages/go_router) for declarative routing and deep link support.
* **HTTP Client**: [Dio](https://pub.dev/packages/dio) / Http client for robust connection handling and interceptors.
* **Authentication**: [Firebase Auth Client](https://pub.dev/packages/firebase_auth) for secure credentials management.

---

## 📂 Feature Directory Layout (`lib/`)

The application codebase follows a feature-first structure:

```txt
├── core/
│   ├── config/          # Configurations and environment setups
│   ├── constants/       # App-wide UI constants, colors, and strings
│   ├── errors/          # Exception handling and API error mappings
│   ├── router/          # Declared app routes via GoRouter
│   └── theme/           # Premium dark/light themes and typographies
│
├── data/
│   ├── models/          # Data schemas and serialization (JSON parsing)
│   ├── repositories/    # Repositories for data queries and mutations
│   └── services/        # Low-level clients (API HTTP client, Cache service)
│
├── features/
│   ├── auth/            # Sign in, registration, and password recovery
│   ├── home/            # Recommendations dashboard and newsfeed
│   ├── onboarding/      # Profile configuration wizard
│   ├── food/            # Food spot discovery, search, and maps detail UI
│   ├── services/        # Service providers list and reservation booking
│   └── profile/         # Expat settings and preferences
│
└── shared/
    └── widgets/         # Shared UI buttons, loaders, and input fields
```

---

## ⚙️ Setup & Local Execution

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable channel)
* Xcode (for iOS builds, macOS only)
* Android Studio / SDK (for Android builds)

### 1. Retrieve Packages
Fetch the required pub dependencies:
```sh
flutter pub get
```

### 2. Configure Firebase Projects
Download and place your Firebase client config files inside the platform folders:
* **Android**: [android/app/google-services.json](file:///Users/rizwan/Documents/GitHub/Raha/frontend/android/app/google-services.json)
* **iOS**: [ios/Runner/GoogleService-Info.plist](file:///Users/rizwan/Documents/GitHub/Raha/frontend/ios/Runner/GoogleService-Info.plist)

### 3. Run the App
To run the app against a local backend, define the `BASE_URL` pointing to your API server. 

**Android Emulator (connecting to host localhost API):**
```sh
flutter run --dart-define=BASE_URL=http://10.0.2.2:5000
```

**iOS Simulator or Web browser:**
```sh
flutter run --dart-define=BASE_URL=http://localhost:5000
```

---

## 🧪 Quality Assurance & Testing

Maintain clean code quality and run the built-in tests:

```sh
# Perform static code analysis
flutter analyze

# Run unit and widget tests
flutter test
```
