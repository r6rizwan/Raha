const mongoose = require('mongoose');

const foodSchema = new mongoose.Schema({
  name: { type: String, required: true },
  cuisineTypes: [String],
  city: String,
  districtTag: String,
  rating: { type: Number, min: 0, max: 5 },
  priceRange: { type: String, enum: ['$', '$$', '$$$'] },
  photos: [String],
  googlePlaceId: String,
  source: { type: String, enum: ['seed', 'google_places', 'manual'], default: 'manual' },
  importedAt: Date,
  rawGooglePlace: mongoose.Schema.Types.Mixed,
  isActive: { type: Boolean, default: true },
}, { timestamps: true });

foodSchema.index({ city: 1, cuisineTypes: 1 });
foodSchema.index({ googlePlaceId: 1 }, { unique: true, sparse: true });
foodSchema.index({ source: 1, isActive: 1 });
module.exports = mongoose.model('FoodSpot', foodSchema);
