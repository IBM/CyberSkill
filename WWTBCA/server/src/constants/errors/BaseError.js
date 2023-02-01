class BaseError extends Error {
  constructor(message) {
    super(message);
    this.name = "BaseError";
    this.statusCode = 500;
    this.internalCode = 0;
  }
}

module.exports = BaseError;
