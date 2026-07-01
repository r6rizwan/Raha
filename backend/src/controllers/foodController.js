const FoodSpot = require('../models/FoodSpot');
const { getPhotoMedia, getPlaceDetails } = require('../utils/placesClient');

function foodQuery(req) {
  const query = { city: req.query.city, isActive: true };
  if (req.query.cuisine) query.cuisineTypes = req.query.cuisine;
  return query;
}

exports.listFood = async (req, res, next) => {
  try {
    const page = Math.max(Number(req.query.page || 1), 1);
    const limit = Math.min(Number(req.query.limit || 10), 50);
    const baseQuery = foodQuery(req);
    const liveQuery = { ...baseQuery, source: { $in: ['google_places', 'manual'] } };
    const liveTotal = await FoodSpot.countDocuments(liveQuery);
    const query = liveTotal > 0 ? liveQuery : baseQuery;
    const [spots, total] = await Promise.all([
      FoodSpot.find(query).select('-__v -rawGooglePlace').sort({ source: 1, rating: -1 }).skip((page - 1) * limit).limit(limit),
      FoodSpot.countDocuments(query),
    ]);
    res.json({ success: true, data: { spots, total, page } });
  } catch (err) {
    next(err);
  }
};

exports.getFoodSpot = async (req, res, next) => {
  try {
    const spot = await FoodSpot.findById(req.params.id).select('-__v -rawGooglePlace');
    if (!spot) return res.status(404).json({ success: false, error: 'Food spot not found' });
    res.json({ success: true, data: spot });
  } catch (err) {
    next(err);
  }
};

exports.getFoodPlaceDetails = async (req, res, next) => {
  try {
    const spot = await FoodSpot.findById(req.params.id).select('-__v -rawGooglePlace');
    if (!spot) return res.status(404).json({ success: false, error: 'Food spot not found' });
    const place = await getPlaceDetails(spot.googlePlaceId);
    const host = req.get('host');
    const protocol = req.get('x-forwarded-proto') || req.protocol;
    const placeWithProxyPhotos = place == null
      ? null
      : {
          ...place,
          photoNames: place.photoNames.map(
            (photoName) =>
              `${protocol}://${host}/api/food/photo?name=${encodeURIComponent(photoName)}`,
          ),
        };
    res.json({ success: true, data: { spot, place: placeWithProxyPhotos } });
  } catch (err) {
    next(err);
  }
};

exports.getFoodPhoto = async (req, res, next) => {
  try {
    const photoName = req.query.name;
    if (!photoName) {
      return res.status(400).json({ success: false, error: 'Photo name is required' });
    }
    const media = await getPhotoMedia(photoName);
    res.set('Content-Type', media.contentType);
    res.set('Cache-Control', media.cacheControl);
    res.send(media.buffer);
  } catch (err) {
    next(err);
  }
};
