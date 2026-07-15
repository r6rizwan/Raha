const User = require('../models/User');
const { getRecommendations, FALLBACK_EN, FALLBACK_AR } = require('../utils/geminiClient');

exports.recommendations = async (req, res, next) => {
  try {
    const lang = req.query.lang || 'en';
    const user = await User.findOne({ firebaseUid: req.params.userId }).select('-__v');
    const fallback = lang === 'ar' ? FALLBACK_AR : FALLBACK_EN;
    
    if (!user) return res.json({ success: true, data: fallback });
    const data = await getRecommendations({ 
      nationality: user.nationality, 
      city: user.city, 
      neighbourhood: user.neighbourhood, 
      interests: user.interestTags,
      lang
    });
    res.json({ success: true, data });
  } catch (err) { next(err); }
};
