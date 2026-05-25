const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  firebaseUid: { type: String, required: true },
  name: String,
  email: { type: String, required: true },
  nationality: String,
  city: String,
  neighbourhood: String,
  interestTags: [String],
}, { timestamps: true });

userSchema.index({ firebaseUid: 1 }, { unique: true });
userSchema.index({ email: 1 }, { unique: true });
module.exports = mongoose.model('User', userSchema);
