const BaseError = require("./BaseError");

class LogicalError extends BaseError {
  constructor(message) {
    super(message);
    this.name = "LogicalError";
    this.statusCode = 400;
    this.internalCode = 3;
  }
}

module.exports = LogicalError;
