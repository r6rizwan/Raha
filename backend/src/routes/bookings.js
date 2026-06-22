const router = require('express').Router();
const controller = require('../controllers/bookingController');
router.post('/', controller.createBooking);
router.get('/my', controller.myBookings);
router.patch('/:id/cancel', controller.cancelBooking);
module.exports = router;
