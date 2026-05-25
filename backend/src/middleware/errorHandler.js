const winston = require('winston');

const logger = winston.createLogger({
  level: 'error',
  transports: process.env.NODE_ENV === 'production'
    ? [new winston.transports.File({ filename: 'error.log' })]
    : [new winston.transports.Console()],
});

module.exports = function errorHandler(err, req, res, next) {
  logger.error(err);
  res.status(500).json({ success: false, error: 'Something went wrong' });
};
