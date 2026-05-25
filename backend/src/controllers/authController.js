const User = require('../models/User');

exports.saveProfile = async (req, res, next) => {
  try {
    const { nationality, city, neighbourhood, interestTags = [], name } = req.body;
    const user = await User.findOneAndUpdate(
      { firebaseUid: req.user.uid },
      { firebaseUid: req.user.uid, email: req.user.email, name, nationality, city, neighbourhood, interestTags },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    ).select('-__v');
    res.status(201).json({ success: true, data: user });
  } catch (err) { next(err); }
};

exports.me = async (req, res, next) => {
  try {
    const user = await User.findOne({ firebaseUid: req.user.uid }).select('-__v');
    res.json({ success: true, data: user });
  } catch (err) { next(err); }
};
