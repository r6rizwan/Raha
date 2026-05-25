const router = require('express').Router();
const controller = require('../controllers/foodController');
router.get('/', controller.listFood);
router.get('/:id', controller.getFoodSpot);
router.get('/:id/place', controller.getFoodPlaceDetails);
module.exports = router;
