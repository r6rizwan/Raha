require('dotenv').config();
const mongoose = require('mongoose');
const FoodSpot = require('../models/FoodSpot');
const ServiceProvider = require('../models/ServiceProvider');

const foods = [
  {
    name: 'Calicut Table',
    cuisineTypes: ['Indian', 'Kerala'],
    city: 'Dubai',
    districtTag: 'JLT',
    rating: 4.6,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'ChIJNwCBp3NDXz4R6-gd8aYdEkM',
    photos: ['https://images.unsplash.com/photo-1601050690597-df056fb4ce78']
  },
  {
    name: 'Mumbai Tiffin',
    cuisineTypes: ['Indian'],
    city: 'Dubai',
    districtTag: 'Bur Dubai',
    rating: 4.4,
    priceRange: '$',
    source: 'seed',
    googlePlaceId: 'ChIJN81uvipDXz4RH_4cyTocRMI',
    photos: ['https://images.unsplash.com/photo-1589301760014-d929f3979dbc']
  },
  {
    name: 'Punjab Grill Home',
    cuisineTypes: ['Indian', 'Punjabi'],
    city: 'Dubai',
    districtTag: 'Dubai Marina',
    rating: 4.5,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'ChIJfQRaZTlDXz4RA0_RPMBRCeM',
    photos: ['https://images.unsplash.com/photo-1565557623262-b51c2513a641']
  },
  {
    name: 'Manila Bowl',
    cuisineTypes: ['Filipino'],
    city: 'Dubai',
    districtTag: 'Deira',
    rating: 4.3,
    priceRange: '$',
    source: 'seed',
    googlePlaceId: 'ChIJl2wjTgBXXz4R2j_56BuINdM',
    photos: ['https://images.unsplash.com/photo-1622851249226-807c5c0d8e87']
  },
  {
    name: 'Cebu Lechon House',
    cuisineTypes: ['Filipino'],
    city: 'Dubai',
    districtTag: 'Al Barsha',
    rating: 4.2,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'ChIJr_4NZ-FDXz4RCG-GlW2HPvs',
    photos: ['https://images.unsplash.com/photo-1544025162-d76694265947']
  },
  {
    name: 'Karachi Darbar Plus',
    cuisineTypes: ['Pakistani'],
    city: 'Dubai',
    districtTag: 'Karama',
    rating: 4.4,
    priceRange: '$',
    source: 'seed',
    googlePlaceId: 'ChIJzefxONdCXz4Rfb99bDHFF28',
    photos: ['https://images.unsplash.com/photo-1606491956689-2ea866880c84']
  },
  {
    name: 'Lahore Kebab Co',
    cuisineTypes: ['Pakistani'],
    city: 'Dubai',
    districtTag: 'JVC',
    rating: 4.5,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'ChIJT8WN5SBdXz4RwtnR-EonxdI',
    photos: ['https://images.unsplash.com/photo-1599487488170-d11ec9c172f0']
  },
  {
    name: 'Peshawar Shinwari',
    cuisineTypes: ['Pakistani'],
    city: 'Dubai',
    districtTag: 'Deira',
    rating: 4.1,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'ChIJfQRaZTlDXz4RA0_RPMBRCeM',
    photos: ['https://images.unsplash.com/photo-1544025162-d76694265947']
  },
  {
    name: 'Beirut Garden',
    cuisineTypes: ['Lebanese'],
    city: 'Dubai',
    districtTag: 'Downtown Dubai',
    rating: 4.7,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'ChIJSzZG1OJrXz4RwYtfSUSO1w4',
    photos: ['https://images.unsplash.com/photo-1541518763669-27fef04b14ea']
  },
  {
    name: 'Zaatar Street',
    cuisineTypes: ['Lebanese'],
    city: 'Dubai',
    districtTag: 'Business Bay',
    rating: 4.3,
    priceRange: '$',
    source: 'seed',
    googlePlaceId: 'ChIJmRYJAGxDXz4R_1NUwR2Bj00',
    photos: ['https://images.unsplash.com/photo-1565299624946-b28f40a0ae38']
  },
  {
    name: 'Najd Majlis',
    cuisineTypes: ['Saudi', 'Gulf'],
    city: 'Dubai',
    districtTag: 'Jumeirah',
    rating: 4.6,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'seed-saudi-najd-majlis',
    photos: ['https://images.unsplash.com/photo-1543353071-10c8ba85a904']
  },
  {
    name: 'Riyadh Kabsa House',
    cuisineTypes: ['Saudi', 'Gulf'],
    city: 'Dubai',
    districtTag: 'Al Barsha',
    rating: 4.4,
    priceRange: '$$',
    source: 'seed',
    googlePlaceId: 'seed-saudi-riyadh-kabsa',
    photos: ['https://images.unsplash.com/photo-1512058564366-18510be2db19']
  },
  {
    name: 'Gulf Mandi Kitchen',
    cuisineTypes: ['Gulf', 'Saudi'],
    city: 'Dubai',
    districtTag: 'Deira',
    rating: 4.5,
    priceRange: '$',
    source: 'seed',
    googlePlaceId: 'seed-gulf-mandi-kitchen',
    photos: ['https://images.unsplash.com/photo-1563379091339-03246963d96c']
  },
  {
    name: 'Emirati Machboos Co',
    cuisineTypes: ['Emirati', 'Gulf'],
    city: 'Dubai',
    districtTag: 'Downtown Dubai',
    rating: 4.7,
    priceRange: '$$$',
    source: 'seed',
    googlePlaceId: 'seed-emirati-machboos',
    photos: ['https://images.unsplash.com/photo-1504674900247-0877df9cc836']
  }
];

const services = [
  {
    name: 'Sparkle Maids',
    category: 'Cleaning',
    rating: 4.7,
    priceRange: '$$',
    photos: ['https://images.unsplash.com/photo-1581578731548-c64695cc6952']
  },
  {
    name: 'FreshNest Cleaning',
    category: 'Cleaning',
    rating: 4.5,
    priceRange: '$',
    photos: ['https://images.unsplash.com/photo-1527515637462-cff94eecc1ac']
  },
  {
    name: 'TidyPro Dubai',
    category: 'Cleaning',
    rating: 4.4,
    priceRange: '$$',
    photos: ['https://images.unsplash.com/photo-1581578731548-c64695cc6952']
  },
  {
    name: 'Weekly Shine',
    category: 'Cleaning',
    rating: 4.3,
    priceRange: '$',
    photos: ['https://images.unsplash.com/photo-1581578731548-c64695cc6952']
  },
  {
    name: 'FixRight Maintenance',
    category: 'Maintenance',
    rating: 4.6,
    priceRange: '$$',
    photos: ['https://images.unsplash.com/photo-1581092921461-eab62e97a780']
  },
  {
    name: 'CoolAir Experts',
    category: 'Maintenance',
    rating: 4.4,
    priceRange: '$$',
    photos: ['https://images.unsplash.com/photo-1621905251189-08b45d6a269e']
  },
  {
    name: 'Pipe & Power',
    category: 'Maintenance',
    rating: 4.2,
    priceRange: '$',
    photos: ['https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1']
  },
  {
    name: 'EasyMove UAE',
    category: 'Movers',
    rating: 4.5,
    priceRange: '$$',
    photos: ['https://images.unsplash.com/photo-1600585154526-990dced4db0d']
  },
  {
    name: 'BoxBuddy Movers',
    category: 'Movers',
    rating: 4.3,
    priceRange: '$$',
    photos: ['https://images.unsplash.com/photo-1522273400909-fd1a8f77637e']
  },
  {
    name: 'SwiftShift',
    category: 'Movers',
    rating: 4.1,
    priceRange: '$',
    photos: ['https://images.unsplash.com/photo-1600585154526-990dced4db0d']
  }
].map(item => ({
  ...item,
  city: '__CITY__',   // replaced at runtime
  isVerified: true,
  bio: `${item.name} helps expats settle in faster with high-quality, trusted services.`,
  contactPhone: '+00000000000'
}));

async function seed() {
  const cityArg = process.argv.find((a) => a.startsWith('--city='));
  const city = cityArg ? cityArg.split('=')[1] : 'Dubai';

  const localizedServices = services.map((s) => ({
    ...s,
    city,
    bio: s.bio.replace('__CITY__', city),
  }));

  await mongoose.connect(process.env.MONGO_URI);

  // Food seed is Dubai-only fallback; live data comes from syncPlacesFood.js
  if (city === 'Dubai') {
    await FoodSpot.deleteMany({ source: 'seed' });
    const uniqueFoods = Array.from(
      new Map(
        foods.map((food) => [food.googlePlaceId, { ...food, city: 'Dubai' }]),
      ).values(),
    );
    await FoodSpot.insertMany(uniqueFoods);
    console.log('Seeded food fallback data for Dubai');
  }

  // Service providers are seeded per city
  await ServiceProvider.deleteMany({ city });
  await ServiceProvider.insertMany(localizedServices);
  console.log(`Seeded ${localizedServices.length} service providers for city: ${city}`);

  await mongoose.disconnect();
}
seed().catch((err) => { console.error(err); process.exit(1); });
