const ServiceProvider = require('../models/ServiceProvider');

exports.listServices = async (req, res, next) => {
  try {
    const page = Math.max(Number(req.query.page || 1), 1);
    const limit = Math.min(Number(req.query.limit || 10), 50);
    const query = { city: req.query.city };
    if (req.query.category) query.category = req.query.category;
    const [providers, total] = await Promise.all([
      ServiceProvider.find(query).select('-__v').skip((page - 1) * limit).limit(limit),
      ServiceProvider.countDocuments(query),
    ]);
    res.json({ success: true, data: { providers, total, page } });
  } catch (err) { next(err); }
};

exports.getProvider = async (req, res, next) => {
  try {
    const provider = await ServiceProvider.findById(req.params.id).select('-__v');
    if (!provider) return res.status(404).json({ success: false, error: 'Provider not found' });
    res.json({ success: true, data: provider });
  } catch (err) { next(err); }
};
