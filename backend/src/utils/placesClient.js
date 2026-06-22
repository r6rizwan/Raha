const SEARCH_FIELD_MASK = [
  'places.id',
  'places.displayName',
  'places.formattedAddress',
  'places.location',
  'places.rating',
  'places.userRatingCount',
  'places.priceLevel',
  'places.photos',
  'places.types',
].join(',');

function requirePlacesKey() {
  if (!process.env.GOOGLE_PLACES_API_KEY) {
    throw new Error('GOOGLE_PLACES_API_KEY is required');
  }
}

async function searchText(textQuery, { pageSize = 8 } = {}) {
  requirePlacesKey();
  const response = await fetch('https://places.googleapis.com/v1/places:searchText', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': process.env.GOOGLE_PLACES_API_KEY,
      'X-Goog-FieldMask': SEARCH_FIELD_MASK,
    },
    body: JSON.stringify({ textQuery, pageSize }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Google Places Text Search failed with ${response.status}: ${body}`);
  }

  const data = await response.json();
  return data.places || [];
}

async function getPlaceDetails(placeId) {
  if (!process.env.GOOGLE_PLACES_API_KEY || !placeId || placeId.startsWith('seed-')) {
    return null;
  }

  const url = `https://places.googleapis.com/v1/places/${encodeURIComponent(placeId)}`;
  const response = await fetch(url, {
    headers: {
      'X-Goog-Api-Key': process.env.GOOGLE_PLACES_API_KEY,
      'X-Goog-FieldMask': 'id,displayName,formattedAddress,internationalPhoneNumber,websiteUri,googleMapsUri,currentOpeningHours,rating,userRatingCount,photos',
    },
  });

  if (!response.ok) {
    throw new Error(`Google Places failed with ${response.status}`);
  }

  const data = await response.json();
  return {
    placeId: data.id || placeId,
    name: data.displayName?.text || '',
    address: data.formattedAddress || '',
    phone: data.internationalPhoneNumber || '',
    website: data.websiteUri || '',
    mapsUrl: data.googleMapsUri || '',
    rating: data.rating || 0,
    userRatingCount: data.userRatingCount || 0,
    openingHours: data.currentOpeningHours?.weekdayDescriptions || [],
    photoNames: (data.photos || []).slice(0, 5).map((photo) => {
      if (!photo.name) return null;
      return `https://places.googleapis.com/v1/${photo.name}/media?maxHeightPx=600&maxWidthPx=900&key=${process.env.GOOGLE_PLACES_API_KEY}`;
    }).filter(Boolean),
  };
}

module.exports = { getPlaceDetails, searchText };
