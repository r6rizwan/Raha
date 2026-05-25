const router = require('express').Router();
const controller = require('../controllers/serviceController');
router.get('/', controller.listServices);
router.get('/:id', controller.getProvider);
module.exports = router;
