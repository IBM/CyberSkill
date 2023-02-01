const express = require("express");

const router = express.Router();

router.use("/player", require("./player"));
router.use("/categories", require("./categories"));

module.exports = router;
