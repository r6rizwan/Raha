const router = require('express').Router();

router.get('/', (req, res) => {
  res.json({
    success: true,
    data: {
      status: 'ok',
      uptime: process.uptime(),
      minAppVersion: process.env.MIN_APP_VERSION || '1.0.0',
      latestAppVersion: process.env.LATEST_APP_VERSION || '1.0.0',
      updateUrl:
        process.env.UPDATE_URL || 'https://github.com/r6rizwan/Raha/releases',
    },
  });
});

module.exports = router;
