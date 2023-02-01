const winston = require("winston");
const httpContext = require("express-http-context");

const config = {
  levels: {
    error: 0,
    warn: 1,
    info: 2,
    debug: 3,
    data: 4,
  },
  colors: {
    error: "red",
    warn: "yellow",
    info: "green",
    debug: "blue",
    data: "grey",
  },
};

winston.addColors(config.colors);

const myFormatter = winston.format((info) => {
  const reqId = httpContext.get("reqId");
  const { message } = info;

  info.message = reqId ? "REQID: " + reqId + " - " + message : message;
  return info;
})();

// creates a new Winston Logger
const logger = (module.exports = winston.createLogger({
  levels: config.levels,
  format: winston.format.combine(
    winston.format.timestamp({
      format: "YYYY-MM-DD HH:mm:ss",
    }),
    myFormatter,
    winston.format.simple()
  ),
  transports: [
    new winston.transports.File({
      filename: `./logs/errors.log`,
      level: "error",
      handleExceptions: true,
      humanReadableUnhandledException: true,
    }),
    new winston.transports.File({
      filename: `./logs/logs.log`,
    }),
  ],
  exitOnError: false,
}));

module.exports = logger;
module.exports.stream = {
  write: function (message, encoding) {
    logger.info(message);
  },
};
