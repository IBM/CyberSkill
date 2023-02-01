const app = require("./src/app");

const SERVER_PORT = process.env.SERVER_PORT || 8090;

app.listen(SERVER_PORT, function () {
  console.log(`🚀 Server running on port ${SERVER_PORT}.`);
});
module.export = app;
