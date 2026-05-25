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
    photoNames: (data.photos || []).slice(0, 5).map((photo) => photo.name).filter(Boolean),
  };
}

module.exports = { getPlaceDetails };
