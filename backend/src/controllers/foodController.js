const FoodSpot = require('../models/FoodSpot');
const { getPlaceDetails } = require('../utils/placesClient');

exports.listFood = async (req, res, next) => {
  try {
    const page = Math.max(Number(req.query.page || 1), 1);
    const limit = Math.min(Number(req.query.limit || 10), 50);
    const query = { city: req.query.city, isActive: true };
    if (req.query.cuisine) query.cuisineTypes = req.query.cuisine;
    const [spots, total] = await Promise.all([
      FoodSpot.find(query).select('-__v').skip((page - 1) * limit).limit(limit),
      FoodSpot.countDocuments(query),
    ]);
    res.json({ success: true, data: { spots, total, page } });
  } catch (err) {
    next(err);
  }
};

exports.getFoodSpot = async (req, res, next) => {
  try {
    const spot = await FoodSpot.findById(req.params.id).select('-__v');
    if (!spot) return res.status(404).json({ success: false, error: 'Food spot not found' });
    res.json({ success: true, data: spot });
  } catch (err) {
    next(err);
  }
};

exports.getFoodPlaceDetails = async (req, res, next) => {
  try {
    const spot = await FoodSpot.findById(req.params.id).select('-__v');
    if (!spot) return res.status(404).json({ success: false, error: 'Food spot not found' });
    const place = await getPlaceDetails(spot.googlePlaceId);
    res.json({ success: true, data: { spot, place } });
  } catch (err) {
    next(err);
  }
};
