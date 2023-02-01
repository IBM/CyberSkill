const express = require("express");
const asyncHandler = require("express-async-handler");

const router = express.Router();
const PlayerController = require("../controllers/PlayerController");

// POST serverBaseUrl/player
router.post("/", asyncHandler(PlayerController.storePlayer));

// GET serverBaseUrl/player/leaderboard
router.get("/:id/leaderboard", asyncHandler(PlayerController.getTopPlayers));

module.exports = router;
