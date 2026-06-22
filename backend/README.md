# Raha Backend

Node.js + Express API for Raha. It handles Firebase-authenticated users, food discovery, service providers, bookings, AI recommendations, and Google Places food imports.

## Requirements

- Node 20+
- MongoDB
- Firebase project with Authentication enabled
- Firebase Admin service account
- Gemini API key
- Google Places API key

## Environment

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

## Commands

```sh
npm install
npm run verify
npm run check
npm start
```

Verify should print:

```txt
Firebase Admin verified
MongoDB verified
```

## Keep Backend Warm

The repo includes [.github/workflows/keep-backend-warm.yml](/Users/rizwan/Documents/GitHub/Raha/.github/workflows/keep-backend-warm.yml), which pings the backend every 10 minutes.

Create this GitHub repository variable:

```txt
BACKEND_HEALTH_URL=https://raha-c9e7.onrender.com/api/health
```

## Live Google Places Food Sync

Food records are stored in MongoDB. Google Places is used by a backend sync script, not directly by the Flutter app.

```sh
npx -y node@20 src/scripts/syncPlacesFood.js --deactivate-seed --page-size=5
```

The sync script searches Dubai for supported cuisines and upserts restaurants by `googlePlaceId`.

Supported imported cuisines currently include:

```txt
Indian, Kerala, Punjabi, Filipino, Pakistani, Lebanese, Saudi, Gulf, Emirati
```

Food record source behavior:

- `google_places`: imported live Google Places data
- `manual`: manually curated records
- `seed`: sample fallback records

The food API serves live/manual records first. Seed records are only a fallback when no live/manual records exist for the query.

## Development Seed Data

```sh
npm run seed
```

Use this only for local/demo reset data. For live food display, run the Google Places sync after seeding.

## API Health

```txt
GET /health
GET /api/health
```

Returns:

```json
{
  "success": true,
  "data": {
    "status": "ok",
    "uptime": 123.45,
    "minAppVersion": "1.0.0",
    "latestAppVersion": "1.0.0",
    "updateUrl": "https://github.com/your-org-or-user/Raha/releases"
  }
}
```

The health payload also carries app-update metadata used by the Flutter client:

- `minAppVersion`
- `latestAppVersion`
- `updateUrl`
