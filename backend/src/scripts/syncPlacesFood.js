const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });
const mongoose = require('mongoose');
const FoodSpot = require('../models/FoodSpot');
const { searchText } = require('../utils/placesClient');

const DEFAULT_JOBS = [
  { query: 'Indian restaurants in {CITY}', cuisines: ['Indian'] },
  { query: 'Kerala restaurants in {CITY}', cuisines: ['Indian', 'Kerala'] },
  { query: 'Punjabi restaurants in {CITY}', cuisines: ['Indian', 'Punjabi'] },
  { query: 'Filipino restaurants in {CITY}', cuisines: ['Filipino'] },
  { query: 'Pakistani restaurants in {CITY}', cuisines: ['Pakistani'] },
  { query: 'Lebanese restaurants in {CITY}', cuisines: ['Lebanese'] },
  { query: 'Saudi restaurants in {CITY}', cuisines: ['Saudi', 'Gulf'] },
  { query: 'Gulf restaurants in {CITY}', cuisines: ['Gulf'] },
  { query: 'Emirati restaurants in {CITY}', cuisines: ['Emirati', 'Gulf'] },
];

function priceRange(priceLevel) {
  if (!priceLevel || priceLevel === 'PRICE_LEVEL_UNSPECIFIED') return '$$';
  if (['PRICE_LEVEL_FREE', 'PRICE_LEVEL_INEXPENSIVE'].includes(priceLevel)) return '$';
  if (priceLevel === 'PRICE_LEVEL_EXPENSIVE' || priceLevel === 'PRICE_LEVEL_VERY_EXPENSIVE') return '$$$';
  return '$$';
}

function districtFromAddress(address, city) {
  if (!address) return city;
  const parts = address.split(',').map((part) => part.trim()).filter(Boolean);
  const cityRegex = new RegExp(`^${city}$`, 'i');
  const cityIndex = parts.findIndex((part) => cityRegex.test(part) || new RegExp(city, 'i').test(part));
  if (cityIndex > 0) return parts[cityIndex - 1];
  return parts[0] || city;
}

function photoUrls(place) {
  return (place.photos || []).slice(0, 3).map((photo) => {
    if (!photo.name) return null;
    return `https://places.googleapis.com/v1/${photo.name}/media?maxHeightPx=600&maxWidthPx=900&key=${process.env.GOOGLE_PLACES_API_KEY}`;
  }).filter(Boolean);
}

async function syncJob(job, { pageSize, city }) {
  const actualQuery = job.query.replace('{CITY}', city);
  const places = await searchText(actualQuery, { pageSize });
  let count = 0;
  for (const place of places) {
    if (!place.id || !place.displayName?.text) continue;
    await FoodSpot.findOneAndUpdate(
      { googlePlaceId: place.id },
      {
        $set: {
          name: place.displayName.text,
          cuisineTypes: job.cuisines,
          city: city,
          districtTag: districtFromAddress(place.formattedAddress, city),
          rating: place.rating || 0,
          priceRange: priceRange(place.priceLevel),
          photos: photoUrls(place),
          googlePlaceId: place.id,
          source: 'google_places',
          importedAt: new Date(),
          rawGooglePlace: place,
          isActive: true,
        },
      },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );
    count += 1;
  }
  console.log(`${job.query}: ${count} synced`);
  return count;
}

async function main() {
  const args = new Set(process.argv.slice(2));
  const pageSizeArg = process.argv.find((arg) => arg.startsWith('--page-size='));
  const pageSize = Number(pageSizeArg?.split('=')[1] || 8);
  
  const cityArg = process.argv.find((arg) => arg.startsWith('--city='));
  const city = cityArg ? cityArg.split('=')[1] : 'Dubai';

  if (!process.env.MONGO_URI) throw new Error('MONGO_URI is required');
  await mongoose.connect(process.env.MONGO_URI);

  if (args.has('--deactivate-seed')) {
    const result = await FoodSpot.updateMany({ $or: [{ source: 'seed' }, { source: null }, { source: { $exists: false } }] }, { $set: { source: 'seed', isActive: false } });
    console.log(`Seed records deactivated: ${result.modifiedCount}`);
  }

  let total = 0;
  for (const job of DEFAULT_JOBS) {
    total += await syncJob(job, { pageSize, city });
  }

  console.log(`Google Places food sync complete: ${total} records processed`);
  await mongoose.disconnect();
}

main().catch(async (err) => {
  console.error(err.message);
  await mongoose.disconnect().catch(() => {});
  process.exit(1);
});
