const BaseError = require("./BaseError");

class EntityNotFoundError extends BaseError {
  constructor(message) {
    super(message);
    this.name = "EntityNotFoundError";
    this.statusCode = 404;
    this.internalCode = 2;
  }
}

module.exports = EntityNotFoundError;
