const Booking = require('../models/Booking');
const User = require('../models/User');

exports.createBooking = async (req, res, next) => {
  try {
    const user = await User.findOne({ firebaseUid: req.user.uid }).select('_id');
    if (!user) return res.status(404).json({ success: false, error: 'User not found' });
    const booking = await Booking.create({ userId: user._id, providerId: req.body.providerId, scheduledAt: req.body.scheduledAt, notes: req.body.notes, amount: req.body.amount });
    const populated = await Booking.findById(booking._id).populate('providerId', 'name').select('-__v');
    res.status(201).json({ success: true, data: { ...populated.toObject(), providerName: populated.providerId.name } });
  } catch (err) { next(err); }
};

exports.myBookings = async (req, res, next) => {
  try {
    const user = await User.findOne({ firebaseUid: req.user.uid }).select('_id');
    if (!user) return res.json({ success: true, data: [] });
    const bookings = await Booking.find({ userId: user._id }).populate('providerId', 'name').sort({ createdAt: -1 }).select('-__v');
    res.json({ success: true, data: bookings.map((b) => ({ ...b.toObject(), providerName: b.providerId?.name || '' })) });
  } catch (err) { next(err); }
};

exports.cancelBooking = async (req, res, next) => {
  try {
    const user = await User.findOne({ firebaseUid: req.user.uid }).select('_id');
    if (!user) return res.status(404).json({ success: false, error: 'User not found' });
    const booking = await Booking.findOne({ _id: req.params.id, userId: user._id });
    if (!booking) return res.status(404).json({ success: false, error: 'Booking not found' });
    if (booking.status === 'cancelled') return res.status(400).json({ success: false, error: 'Booking already cancelled' });
    booking.status = 'cancelled';
    await booking.save();
    res.json({ success: true, data: { id: booking._id, status: booking.status } });
  } catch (err) { next(err); }
};
