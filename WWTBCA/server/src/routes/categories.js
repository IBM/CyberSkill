const express = require("express");
const asyncHandler = require("express-async-handler");

const router = express.Router();
const CategoriesController = require("../controllers/CategoriesController");

// GET serverBaseUrl/categories
router.get("/", asyncHandler(CategoriesController.getAllCategories));

// GET serverBaseUrl/categories/{categoryId}/questions/{questionLevel}
router.get(
  "/:categoryId/questions/:questionLevel",
  asyncHandler(CategoriesController.getCategoryQuestion)
);

// POST serverBaseUrl/categories/{categoryId}/questions/{questionLevel}/{questionId}
router.post(
  "/:categoryId/questions/:questionLevel/:questionId",
  asyncHandler(CategoriesController.postQuestionAnswer)
);

// GET /categories/{categoryId}/questions/{questionLevel}/{questionId}/fiftyfifty
router.get(
  "/:categoryId/questions/:questionLevel/:questionId/fiftyfifty",
  CategoriesController.getFiftyFiftyAnswers
);

// GET /categories/{categoryId}/questions/{questionLevel}/{questionId}/expert
router.get(
  "/:categoryId/questions/:questionLevel/:questionId/expert",
  CategoriesController.getExpertAnswer
);
module.exports = router;
