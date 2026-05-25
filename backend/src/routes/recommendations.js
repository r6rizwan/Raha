const router = require('express').Router();
const controller = require('../controllers/recommendationController');
router.get('/:userId', controller.recommendations);
module.exports = router;
