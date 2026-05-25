const User = require('../models/User');
const { getRecommendations, FALLBACK } = require('../utils/geminiClient');

exports.recommendations = async (req, res, next) => {
  try {
    const user = await User.findOne({ firebaseUid: req.params.userId }).select('-__v');
    if (!user) return res.json({ success: true, data: FALLBACK });
    const data = await getRecommendations({ nationality: user.nationality, city: user.city, neighbourhood: user.neighbourhood, interests: user.interestTags });
    res.json({ success: true, data });
  } catch (err) { next(err); }
};
