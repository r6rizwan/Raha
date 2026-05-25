# Raha REST API Backend

The backend server for the Raha platform, built using **Node.js**, **Express**, and **MongoDB**. It serves as the primary REST API, managing expat accounts, bookings, local food spots, and integrating with external APIs for location enrichment and AI recommendations.

---

## 🛠️ Tech Stack & Key Dependencies

* **Core**: Node.js & Express.
* **Database**: MongoDB using [Mongoose](https://mongoosejs.com/) for schema modeling.
* **Authentication**: [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup) to authenticate users securely by validating JWT tokens on incoming requests.
* **AI & Integration**:
  * **Gemini API (`gemini-2.0-flash`)**: Used to generate personalized recommendations based on expat profile criteria.
  * **Google Places API (New v1)**: Fetches and displays reviews, coordinates, photos, opening hours, and phone numbers of food spots.
* **Security & Reliability**:
  * [Helmet](https://helmetjs.github.io/) for setting secure HTTP response headers.
  * [Express Rate Limit](https://www.npmjs.com/package/express-rate-limit) to prevent abuse of endpoints (specifically bookings and authentication).
  * [Express Mongo Sanitize](https://www.npmjs.com/package/express-mongo-sanitize) to guard against NoSQL Injection.

---

## 📂 Backend Directory Layout (`src/`)

```txt
├── src/
│   ├── controllers/         # Business logic functions map to API endpoints
│   │   ├── authController.js           # User registration and sync
│   │   ├── bookingController.js        # Creating/updating booking reservations
│   │   ├── foodController.js           # Querying and retrieving cuisine locations
│   │   ├── recommendationController.js # Managing AI concierge calls
│   │   └── serviceController.js        # Querying list of providers
│   │
│   ├── middleware/          # Route handlers running before controllers
│   │   ├── verifyToken.js              # Authorizes requests using Firebase token
│   │   ├── rateLimiter.js              # Rate limits calls globally and to bookings
│   │   └── errorHandler.js             # Global server error formatter
│   │
│   ├── models/              # Mongoose collection schemas
│   │   ├── User.js                     # Expat data (nationality, interests)
│   │   ├── FoodSpot.js                 # Restaurants and local spots
│   │   ├── ServiceProvider.js          # Plumbers, cleaners, handymen
│   │   └── Booking.js                  # Reservation statuses and details
│   │
│   ├── routes/              # Express API routers mapping controllers to URLs
│   │
│   └── utils/               # Configurations and external clients
│       ├── env.js                      # Environment validator
│       ├── firebaseAdmin.js            # Initializer for Firebase Admin SDK
│       ├── geminiClient.js             # Integration client for Gemini 2.0
│       ├── placesClient.js             # Integration client for Google Places v1
│       └── seedData.js                 # Mock database seeds
│
└── app.js                   # Application bootstrap and database connector
```

---

## ⚙️ Configuration & Environment

Ensure you have **Node 20 or newer** installed.

### 1. Configure Environment variables
Copy the template file to set up local environment variables:
```sh
cp .env.example .env
```

Define the variables inside `.env`:
```env
MONGO_URI=your-mongodb-connection-string
FIREBASE_PROJECT_ID=your-firebase-project-id
GEMINI_API_KEY=your-gemini-api-key
GOOGLE_PLACES_API_KEY=your-google-places-key (optional)
PORT=5000
ALLOWED_ORIGINS=http://localhost:3000,http://10.0.2.2:5000
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX=100
```

### 2. Firebase Admin Credentials Setup
To authenticate user tokens, the server needs permission from your Firebase project. Choose **one** of the options:
* **Option A**: Download your project service account JSON file from the Firebase Console and save it as `backend/serviceAccountKey.json`.
* **Option B**: Set the environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the absolute path of your credentials JSON file.

---

## 🚀 Running & Verification Commands

Execute the following commands in the `backend/` directory:

```sh
# 1. Install dependencies
npm install

# 2. Verify dependencies and connection limits
npm run verify

# 3. Seed initial dataset (restaurants & providers)
npm run seed

# 4. Start Server in Development mode
npm start
```

On successful verify, you should see:
```txt
Firebase Admin verified
MongoDB verified
```

---

## 🧪 Verification & Code Checks

To run security checks, lint rules, and syntax analysis:
```sh
npm run check
```
