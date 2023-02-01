const BaseError = require("./BaseError");

class MissingFieldsError extends BaseError {
  constructor(message) {
    super(message);
    this.name = "MissingFieldError";
    this.statusCode = 400;
    this.internalCode = 1;
  }
}

module.exports = MissingFieldsError;
