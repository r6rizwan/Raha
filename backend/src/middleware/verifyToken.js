const admin = require('firebase-admin');

module.exports = async function verifyToken(req, res, next) {
  try {
    const header = req.headers.authorization || '';
    const [scheme, token] = header.split(' ');
    if (scheme !== 'Bearer' || !token) return res.status(401).json({ success: false, error: 'Unauthorized' });
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = { uid: decoded.uid, email: decoded.email };
    next();
  } catch (_) {
    res.status(401).json({ success: false, error: 'Unauthorized' });
  }
};
