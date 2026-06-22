require('dotenv').config({ path: './.env' });
const mongoose = require('mongoose');
const FoodSpot = require('./src/models/FoodSpot');

async function fix() {
  await mongoose.connect(process.env.MONGO_URI);
  const spots = await FoodSpot.find({});
  let fixed = 0;
  for (const spot of spots) {
    let changed = false;
    const newPhotos = spot.photos.map(p => {
      if (p.startsWith('places/')) {
        changed = true;
        return `https://places.googleapis.com/v1/${p}/media?maxHeightPx=600&maxWidthPx=900&key=${process.env.GOOGLE_PLACES_API_KEY}`;
      }
      return p;
    });
    if (changed) {
      spot.photos = newPhotos;
      await spot.save();
      fixed++;
    }
  }
  console.log(`Fixed ${fixed} spots`);
  process.exit(0);
}
fix();
