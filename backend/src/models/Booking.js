const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  providerId: { type: mongoose.Schema.Types.ObjectId, ref: 'ServiceProvider', required: true },
  scheduledAt: Date,
  status: { type: String, enum: ['pending', 'confirmed', 'cancelled'], default: 'pending' },
  notes: String,
  amount: Number,
}, { timestamps: true });

bookingSchema.index({ userId: 1, status: 1 });
bookingSchema.index({ createdAt: -1 });
module.exports = mongoose.model('Booking', bookingSchema);
