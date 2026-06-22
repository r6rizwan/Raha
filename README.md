# Raha

**Raha** is a mobile app for expats and immigrants — built with Flutter + Node.js. Discover food from your home cuisine, book trusted home services, and get AI-personalised recommendations tailored to whatever city you live in and your nationality.

---

## Features

| Feature | Status |
|---------|--------|
| Firebase Auth (Google + email/password) | ✅ |
| Onboarding (name, nationality, city) | ✅ |
| AI-personalised home screen picks (Gemini 2.0 Flash) | ✅ |
| Food discovery — filtered by cuisine & city | ✅ |
| Live food data via Google Places API | ✅ |
| Multi-city support (Dubai, Jeddah, Riyadh, Abu Dhabi, …) | ✅ |
| Food detail — hours, rating, district, photos | ✅ |
| Expandable weekly opening hours | ✅ |
| Home services discovery (Cleaning, Maintenance, Movers) | ✅ |
| Service provider detail + booking flow | ✅ |
| Booking management with cancellation | ✅ |
| Profile & settings (edit profile details) | ✅ |
| Splash screen — no login flash on cold start | ✅ |
| App update checker — links to GitHub Releases | ✅ |
| Stateful tab routing — caches screen layouts | ✅ |
| Branded native splash & app launcher icons | ✅ |


---

## Design System

| Token | Value |
|-------|-------|
| Primary | `#0A5D4B` (dark teal) |
| Background | `#F8F3EB` (warm off-white) |
| Gold accent | `#C5A84C` |
| Card | `#FFFFFF` |
| Text | `#1C2433` |
| Muted | `#8A9BA8` |
| Border | `#E5DDD2` |
| Card radius | `16` |
| Sheet clip radius | `24` |
| Bottom nav | Floating pill — `Color(0xFF1B5E4B).withOpacity(0.12)` behind active icon |

---

## Project Structure

```txt
Raha/
├── backend/              # Node.js + Express + MongoDB API
│   ├── src/
│   │   ├── controllers/  # bookingController, foodController, …
│   │   ├── models/       # FoodSpot, ServiceProvider, Booking, User
│   │   ├── routes/       # REST endpoints
│   │   ├── scripts/      # syncPlacesFood.js, seedData.js, fixPhotos.js
│   │   └── utils/        # placesClient.js, geminiClient.js
│   └── app.js
├── frontend/             # Flutter mobile app
│   └── lib/
│       ├── core/         # router, theme, errors, constants
│       ├── data/         # models, repositories, services
│       ├── features/     # auth, home, food, services, profile, onboarding
│       └── shared/       # widgets (RahaCard, RahaLoadingWidget, …)
└── render.yaml
```

---

## Stack

- **Frontend** — Flutter, Riverpod, GoRouter, Firebase Auth, Dio
- **Backend** — Node.js 20, Express, MongoDB/Mongoose, Firebase Admin SDK
- **AI** — Google Gemini 2.0 Flash (recommendation engine)
- **Places** — Google Places API New (v1)
- **Offline** — Cached read fallback in Flutter repositories

---

## Backend Setup

```sh
cd backend
npm install
```

Create `backend/.env`:

```env
MONGO_URI=
GEMINI_API_KEY=
GOOGLE_PLACES_API_KEY=
FIREBASE_PROJECT_ID=
GOOGLE_APPLICATION_CREDENTIALS=./serviceAccountKey.json
MIN_APP_VERSION=1.0.0
LATEST_APP_VERSION=1.0.0
UPDATE_URL=https://github.com/your-org-or-user/Raha/releases
PORT=5000
ALLOWED_ORIGINS=http://localhost:3000,http://10.0.2.2:5000
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX=100
```

Firebase Admin credentials:

- Put the service account JSON at `backend/serviceAccountKey.json`, or
- Set `GOOGLE_APPLICATION_CREDENTIALS` to the absolute JSON path.

Verify backend runtime:

```sh
npm run verify
```

Expected output:

```txt
Firebase Admin verified
MongoDB verified
```

Start backend:

```sh
npm start
```

The `/health` endpoint also exposes app update metadata for the mobile update checker. Configure `MIN_APP_VERSION`, `LATEST_APP_VERSION`, and `UPDATE_URL` in production to control optional/required updates.

Example `/health` payload:

```json
{
  "success": true,
  "data": {
    "status": "ok",
    "minAppVersion": "1.0.0",
    "latestAppVersion": "1.0.0",
    "updateUrl": "https://github.com/your-org-or-user/Raha/releases"
  }
}
```

---

## Live Food Data

Food data is imported from Google Places into MongoDB. Flutter reads it through the backend — no direct Places calls from the app.

### Sync a city

```sh
cd backend
npm run sync:places:food -- --city=Dubai
npm run sync:places:food -- --city=Jeddah
npm run sync:places:food -- --city=Riyadh
npm run sync:places:food -- --city="Abu Dhabi"
```

Omit `--city` to default to Dubai. Add `--page-size=N` (default 8) to control results per cuisine query.

Currently imported cuisines:

```txt
Indian, Kerala, Punjabi, Filipino, Pakistani, Lebanese, Saudi, Gulf, Emirati
```

### Deactivate seed data and go live

```sh
npm run sync:places:food -- --deactivate-seed --page-size=5
```

### Data source priority

| `source` field | Description |
|----------------|-------------|
| `google_places` | Live imported from Google Places |
| `manual` | Hand-curated production records |
| `seed` | Sample fallback records (local dev only) |

The Food API prefers `google_places` and `manual`. Seed records activate only if no live/manual records exist for the query city.

### Fix photo URLs (one-time migration)

If photos show as broken after a backend change:

```sh
node src/scripts/fixPhotos.js
```

### Development seed (no Google Places calls)

Seeds fallback food data (Dubai only) + service providers for any city:

```sh
npm run seed                          # Dubai (default)
node src/utils/seedData.js --city=Jeddah
node src/utils/seedData.js --city=Riyadh
node src/utils/seedData.js --city="Abu Dhabi"
```

> **Note:** Food seed entries are Dubai-only fallback (shared `googlePlaceId` unique index prevents duplication). Service providers are seeded independently per city. For live food data in other cities, use `syncPlacesFood.js --city=<City>` instead.

---

## Frontend Setup

```sh
cd frontend
flutter pub get
```

Android Firebase package name: `com.raha.mobile`

Required Firebase client files:

```txt
frontend/android/app/google-services.json
frontend/ios/Runner/GoogleService-Info.plist
```

Run on Android emulator against local backend:

```sh
flutter run --dart-define=BASE_URL=http://10.0.2.2:5000
```

---

## GitHub Actions

Flutter analyze runs from [.github/workflows/analyze.yml](/Users/rizwan/Documents/GitHub/Raha/.github/workflows/analyze.yml).

Backend keep-alive runs from [.github/workflows/keep-backend-warm.yml](/Users/rizwan/Documents/GitHub/Raha/.github/workflows/keep-backend-warm.yml).

Create this GitHub repository variable:

- `BACKEND_HEALTH_URL=https://raha-c9e7.onrender.com/api/health`

The keep-alive workflow pings the backend every 10 minutes to reduce cold starts on Render.

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

Backend lint & type check:

```sh
cd backend
npm run check
```

Frontend analysis:

```sh
cd frontend
flutter analyze
flutter test
```

Android debug build:

```sh
flutter build apk --debug --dart-define=BASE_URL=http://10.0.2.2:5000
```

Android release build:

```sh
flutter build apk --release --split-per-abi \
  --obfuscate --split-debug-info=build/debug-info \
  --dart-define=BASE_URL=https://your-production-api.example
```

Or use the root helper:

```sh
./build_apk.sh
```

---

## Production Notes

- Deploy backend with **Node 20** or newer.
- Set `BASE_URL` to the production HTTPS API URL at build time.
- Android release builds block cleartext HTTP by default — use HTTPS in production.
- Add certificate pins once the final production API hostname is confirmed.
- Keep these files **out of git** (already in `.gitignore`):
  - `backend/.env`
  - `backend/serviceAccountKey.json`
  - `backend/*firebase-adminsdk*.json`
  - `frontend/android/app/google-services.json`
  - `frontend/ios/Runner/GoogleService-Info.plist`
