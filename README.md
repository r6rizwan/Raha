# Raha

**Raha** is a mobile app for expats and immigrants — built with Flutter + Node.js. Discover food from your home cuisine, book trusted home services, and get AI-personalised recommendations tailored to whatever city you live in and your nationality.

---

## Features

- Firebase Auth with Google and email/password
- Onboarding with nationality, city, neighbourhood, and interests
- AI-personalised home recommendations with Gemini 2.0 Flash
- Food discovery by cuisine and city
- Live food data via Google Places API
- Google Places photos proxied through the backend
- Multi-city support including Dubai, Jeddah, Riyadh, and Abu Dhabi
- Food detail with hours, rating, district, and photos
- Expandable weekly opening hours
- Home services discovery, provider detail, and booking flow
- Booking history with cancellation
- Profile and edit profile flow
- Splash screen with no login flash on cold start
- App update checker linked to GitHub Releases
- Stateful bottom-tab routing
- Branded native splash screen and launcher icons
- Offline support with cached read fallback in Flutter repositories
- Arabic and English support with locale switching
- RTL support for Arabic

---

## Stack

- **Frontend** — Flutter, Riverpod, GoRouter, Firebase Auth, Dio
- **Backend** — Node.js 20, Express, MongoDB/Mongoose, Firebase Admin SDK
- **AI** — Google Gemini 2.0 Flash (recommendation engine)
- **Places** — Google Places API New (v1)
- **Offline** — Cached read fallback in Flutter repositories

---

## Setup

```sh
cd backend
npm install
```

```sh
cd frontend
flutter pub get
```

- Backend setup: [backend/README.md](/Users/rizwan/Documents/GitHub/Raha/backend/README.md)
- Frontend setup: [frontend/README.md](/Users/rizwan/Documents/GitHub/Raha/frontend/README.md)

Required backend env vars include:

- `MONGO_URI`
- `FIREBASE_PROJECT_ID`
- `GOOGLE_APPLICATION_CREDENTIALS`
- `GEMINI_API_KEY`
- `GOOGLE_PLACES_API_KEY`

---

## GitHub Actions

Flutter analyze runs from [.github/workflows/analyze.yml](/Users/rizwan/Documents/GitHub/Raha/.github/workflows/analyze.yml).

Backend keep-alive runs from [.github/workflows/keep-backend-warm.yml](/Users/rizwan/Documents/GitHub/Raha/.github/workflows/keep-backend-warm.yml).

Create this GitHub repository variable:

- `BACKEND_HEALTH_URL=https://raha-c9e7.onrender.com/api/health`

The keep-alive workflow pings the backend every 10 minutes to reduce cold starts on Render.

---

## Local APK Build

Use the root script [build_apk.sh](/Users/rizwan/Documents/GitHub/Raha/build_apk.sh):

```sh
chmod +x build_apk.sh
./build_apk.sh
```

Output:

```txt
build_artifacts/raha-v<version>.apk
```

---

## Verification

```sh
cd backend
npm run check
npm run verify
```

```sh
cd frontend
flutter analyze
flutter test
```

Android debug build:

```sh
flutter build apk --debug --dart-define=BASE_URL=http://10.0.2.2:5000
```

## Runtime Notes

- Home recommendations are fetched from the backend, not hardcoded in the app.
- Food detail images are loaded through the backend photo proxy at `/api/food/photo`.
