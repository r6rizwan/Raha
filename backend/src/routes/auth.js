const router = require('express').Router();
const verifyToken = require('../middleware/verifyToken');
const controller = require('../controllers/authController');
router.post('/profile', verifyToken, controller.saveProfile);
router.get('/me', verifyToken, controller.me);
module.exports = router;
