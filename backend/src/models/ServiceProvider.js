const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
  name: { type: String, required: true },
  category: String,
  city: String,
  rating: { type: Number, min: 0, max: 5 },
  priceRange: String,
  isVerified: { type: Boolean, default: false },
  photos: [String],
  bio: String,
  contactPhone: String,
}, { timestamps: true });

serviceSchema.index({ city: 1, category: 1 });
module.exports = mongoose.model('ServiceProvider', serviceSchema);
