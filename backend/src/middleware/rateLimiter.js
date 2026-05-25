const rateLimit = require('express-rate-limit');

const tooMany = { success: false, error: 'Too many requests' };
const windowMs = Number(process.env.RATE_LIMIT_WINDOW_MS || 900000);

const globalLimiter = rateLimit({ windowMs, max: Number(process.env.RATE_LIMIT_MAX || 100), standardHeaders: true, legacyHeaders: false, message: tooMany });
const bookingLimiter = rateLimit({ windowMs, max: 20, standardHeaders: true, legacyHeaders: false, message: tooMany });

module.exports = { globalLimiter, bookingLimiter };
