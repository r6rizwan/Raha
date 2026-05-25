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
  isActive: { type: Boolean, default: true },
}, { timestamps: true });

foodSchema.index({ city: 1, cuisineTypes: 1 });
module.exports = mongoose.model('FoodSpot', foodSchema);
