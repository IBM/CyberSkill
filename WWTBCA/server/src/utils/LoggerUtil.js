const logger = require("../config/winston");

const logError = (req, err, caller) => {
  logger.error(
    `[${caller}] - ${req.method} - ${err.message}  - ${req.originalUrl} - ${req.ip}`
  );
};

module.exports = { logError };
