require('dotenv').config();
const mongoose = require('mongoose');
const FoodSpot = require('../models/FoodSpot');
const ServiceProvider = require('../models/ServiceProvider');

const photos = ['https://images.unsplash.com/photo-1504674900247-0877df9cc836'];
const foods = [
  ['Calicut Table', ['Indian', 'Kerala'], 'JLT', 4.6, '$$', 'ChIJNwCBp3NDXz4R6-gd8aYdEkM'],
  ['Mumbai Tiffin', ['Indian'], 'Bur Dubai', 4.4, '$', 'ChIJN81uvipDXz4RH_4cyTocRMI'],
  ['Punjab Grill Home', ['Indian', 'Punjabi'], 'Dubai Marina', 4.5, '$$', 'ChIJfQRaZTlDXz4RA0_RPMBRCeM'],
  ['Manila Bowl', ['Filipino'], 'Deira', 4.3, '$', 'ChIJl2wjTgBXXz4R2j_56BuINdM'],
  ['Cebu Lechon House', ['Filipino'], 'Al Barsha', 4.2, '$$', 'ChIJr_4NZ-FDXz4RCG-GlW2HPvs'],
  ['Karachi Darbar Plus', ['Pakistani'], 'Karama', 4.4, '$', 'ChIJzefxONdCXz4Rfb99bDHFF28'],
  ['Lahore Kebab Co', ['Pakistani'], 'JVC', 4.5, '$$', 'ChIJT8WN5SBdXz4RwtnR-EonxdI'],
  ['Peshawar Shinwari', ['Pakistani'], 'Deira', 4.1, '$$', 'ChIJfQRaZTlDXz4RA0_RPMBRCeM'],
  ['Beirut Garden', ['Lebanese'], 'Downtown Dubai', 4.7, '$$', 'ChIJSzZG1OJrXz4RwYtfSUSO1w4'],
  ['Zaatar Street', ['Lebanese'], 'Business Bay', 4.3, '$', 'ChIJmRYJAGxDXz4R_1NUwR2Bj00'],
].map(([name, cuisineTypes, districtTag, rating, priceRange, googlePlaceId]) => ({
  name, cuisineTypes, city: 'Dubai', districtTag, rating, priceRange, photos, googlePlaceId
}));
const services = [
  ['Sparkle Maids', 'Cleaning', 4.7, '$$'], ['FreshNest Cleaning', 'Cleaning', 4.5, '$'], ['TidyPro Dubai', 'Cleaning', 4.4, '$$'], ['Weekly Shine', 'Cleaning', 4.3, '$'],
  ['FixRight Maintenance', 'Maintenance', 4.6, '$$'], ['CoolAir Experts', 'Maintenance', 4.4, '$$'], ['Pipe & Power', 'Maintenance', 4.2, '$'],
  ['EasyMove UAE', 'Movers', 4.5, '$$'], ['BoxBuddy Movers', 'Movers', 4.3, '$$'], ['SwiftShift', 'Movers', 4.1, '$'],
].map(([name, category, rating, priceRange]) => ({ name, category, city: 'Dubai', rating, priceRange, isVerified: true, photos, bio: `${name} helps Dubai expats settle in faster.`, contactPhone: '+971500000000' }));

async function seed() {
  await mongoose.connect(process.env.MONGO_URI);
  await Promise.all([FoodSpot.deleteMany({}), ServiceProvider.deleteMany({})]);
  await Promise.all([FoodSpot.insertMany(foods), ServiceProvider.insertMany(services)]);
  console.log('Seeded Raha data');
  await mongoose.disconnect();
}
seed().catch((err) => { console.error(err); process.exit(1); });
