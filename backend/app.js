require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const mongoSanitize = require('express-mongo-sanitize');
const mongoose = require('mongoose');
const authRoutes = require('./src/routes/auth');
const foodRoutes = require('./src/routes/food');
const serviceRoutes = require('./src/routes/services');
const bookingRoutes = require('./src/routes/bookings');
const recommendationRoutes = require('./src/routes/recommendations');
const healthRoutes = require('./src/routes/health');
const verifyToken = require('./src/middleware/verifyToken');
const { globalLimiter, bookingLimiter } = require('./src/middleware/rateLimiter');
const errorHandler = require('./src/middleware/errorHandler');
const { requireEnv, allowedOrigins } = require('./src/utils/env');
const { initializeFirebaseAdmin } = require('./src/utils/firebaseAdmin');

const app = express();

requireEnv(['MONGO_URI', 'FIREBASE_PROJECT_ID']);
initializeFirebaseAdmin();

app.use(helmet());
app.use(cors({ origin: allowedOrigins() }));
app.use(express.json());
app.use(mongoSanitize());
app.use(globalLimiter);
app.use('/health', healthRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/food', verifyToken, foodRoutes);
app.use('/api/services', verifyToken, serviceRoutes);
app.use('/api/bookings', verifyToken, bookingLimiter, bookingRoutes);
app.use('/api/recommendations', verifyToken, recommendationRoutes);
app.use(errorHandler);

const port = process.env.PORT || 5000;
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log('MongoDB connected');
    app.listen(port, () => console.log(`Server running on ${port}`));
  })
  .catch((err) => {
    console.error('MongoDB connection error', err);
    process.exit(1);
  });

module.exports = app;
