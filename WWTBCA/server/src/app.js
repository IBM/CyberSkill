require("dotenv").config();
const express = require("express");
const path = require("path");
const morgan = require("morgan");
const logger = require("./config/winston");
const httpContext = require("express-http-context");
const { v4: uuidv4 } = require("uuid");

const BaseError = require("./constants/errors/BaseError");

const app = express();

app.use(
  morgan("short", {
    stream: logger.stream,
  })
);
app.use(express.json());
app.use(httpContext.middleware);

app.use((req, res, next) => {
  httpContext.set("reqId", uuidv4());
  next();
});

app.use("", require("./routes"));

const BUILD_PATH = path.join(__dirname, "../public", "build");
app.use(express.static(BUILD_PATH));
app.get("*", (req, res) => res.sendFile(path.join(BUILD_PATH, "index.html")));

app.use((err, req, res, next) => {
  if (err instanceof BaseError) {
    res
      .status(err.statusCode)
      .json({ success: false, code: err.internalCode, msg: err.message });
  } else {
    logger.error(
      `${req.method} - ${err.message}  - ${req.originalUrl} - ${req.ip}`
    );
    res.status(500).json({ success: false, msg: "Something broke!" });
  }
});

module.exports = app;
