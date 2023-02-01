const EntityNotFoundError = require("../constants/errors/EntityNotFoundError");
const QuestionCategories = require("../constants/QuestionCategories");
const logger = require("../config/winston");

function arrayShuffle(array) {
  var currentIndex = array.length,
    randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {
    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;

    // And swap it with the current element.
    [array[currentIndex], array[randomIndex]] = [
      array[randomIndex],
      array[currentIndex],
    ];
  }

  return array;
}

//
// GET /categories
//
const getAllCategories = async (req, res) => {
  logger.info(
    `[getAllCategories] - Accessing getAllCategories from ip ${
      req.ip
    }. Request Data is: ${JSON.stringify(req.body)}`
  );
  const categories = QuestionCategories.map((cat) => {
    return {
      id: cat.id,
      name: cat.name,
    };
  });
  logger.info(
    `[getAllCategories] - Returning categories: ${JSON.stringify(categories)}`
  );
  res.json({
    success: true,
    data: categories,
  });
};

//
// GET /categories/{categoryId}/questions/{questionLevel}
//
const getCategoryQuestion = async (req, res) => {
  logger.info(
    `[getCategoryQuestion] - Accessing getCategoryQuestion from ip ${
      req.ip
    }. Request Data is: ${JSON.stringify(req.body)}`
  );
  const { categoryId, questionLevel } = req.params;

  const category = QuestionCategories.find((c) => c.id === categoryId);

  if (!category) {
    logger.warn(
      `[getCategoryQuestion] - Could not find category with Id ${categoryId}`
    );
    throw new EntityNotFoundError(
      `Could not retrieve category with Id ${categoryId}`
    );
  }

  const questionsArray = category.questions[questionLevel - 1];

  if (!questionsArray) {
    logger.warn(
      `[getCategoryQuestion] - Could not find level ${questionLevel} in category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find level ${questionLevel} in category ${category.name}`
    );
  }



  const randomQuestion =
    questionsArray[Math.floor(Math.random() * questionsArray.length)];

  const questionResponse = {
    id: randomQuestion.id,
    level: questionLevel,
    question: randomQuestion.question,
    answers: arrayShuffle(randomQuestion.answers.map((a) => a.text)),
  };

  logger.info(
    `[getCategoryQuestion] - Returning question: ${JSON.stringify(
      questionResponse
    )}`
  );
  res.json({
    success: true,
    data: questionResponse,
  });
};

//
// POST /categories/{categoryId}/questions/{questionLevel}/{questionId}
//
const postQuestionAnswer = async (req, res) => {
  logger.info(
    `[postQuestionAnswer] - Accessing postQuestionAnswer from ip ${
      req.ip
    }. Request Data is: ${JSON.stringify(req.body)}`
  );
  const { categoryId, questionLevel, questionId } = req.params;
  const { answer } = req.body;

  const category = QuestionCategories.find((c) => c.id === categoryId);

  if (!category) {
    logger.warn(
      `[postQuestionAnswer] - Could not find category with Id ${categoryId}`
    );
    throw new EntityNotFoundError(
      `Could not retrieve category with Id ${categoryId}`
    );
  }

  const questionsArray = category.questions[questionLevel - 1];

  if (!questionsArray) {
    logger.warn(
      `[postQuestionAnswer] - Could not find level ${questionLevel} in category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find level ${questionLevel} in category ${category.name}`
    );
  }

  const question = questionsArray.find((q) => q.id === questionId);

  if (!question) {
    logger.warn(
      `[postQuestionAnswer] - Could not find question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
  }

  const selectedAnswer = question.answers.find((ans) => ans.text === answer);

  if (!selectedAnswer) {
    logger.warn(
      `[postQuestionAnswer] - Could not find answer '${answer}' in question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find answer '${answer}' in question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
  }

  logger.info(
    `[postQuestionAnswer] - Returning correct value: ${(
      selectedAnswer.correct 
    ).toString()}`
  );

  res.json({
    success: true,
    data: {
      correct: selectedAnswer.correct,
    },
  });
};

//
// GET /categories/{categoryId}/questions/{questionLevel}/{questionId}/fiftyfifty
//
const getFiftyFiftyAnswers = async (req, res) => {
  logger.info(
    `[getFiftyFiftyAnswers] - Accessing getFiftyFiftyAnswers from ip ${req.ip}.`
  );
  const { categoryId, questionLevel, questionId } = req.params;
  logger.info(
    `[getFiftyFiftyAnswers] - Requested Parameters are categoryId: ${categoryId}, questionLevel: ${questionLevel}, questionId: ${questionId}.`
  );

  const category = QuestionCategories.find((c) => c.id === categoryId);

  if (!category) {
    logger.warn(
      `[getFiftyFiftyAnswers] - Could not find category with Id ${categoryId}`
    );
    throw new EntityNotFoundError(
      `Could not retrieve category with Id ${categoryId}`
    );
  }

  const questionsArray = category.questions[questionLevel - 1];

  if (!questionsArray) {
    logger.warn(
      `[getFiftyFiftyAnswers] - Could not find level ${questionLevel} in category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find level ${questionLevel} in category ${category.name}`
    );
  }

  const question = questionsArray.find((q) => q.id === questionId);

  if (!question) {
    logger.warn(
      `[getFiftyFiftyAnswers] - Could not find question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
  }
  const answers = [question.answers.find((ans) => ans.correct).text];
  const remainingAnswers = question.answers.filter((ans) => !ans.correct);
  answers.push(remainingAnswers[Math.floor(Math.random() * 2)].text);

  logger.info(
    `[getFiftyFiftyAnswers] - Returning values: ${JSON.stringify(answers)}`
  );

  res.json({
    success: true,
    data: answers,
  });
};

const getExpertAnswer = async (req, res) => {  
  logger.info(
    `[getExpertAnswer] - Accessing getExpertAnswer from ip ${req.ip}.`
  );

  const { categoryId, questionLevel, questionId } = req.params;
  logger.info(
    `[getExpertAnswer] - Requested Parameters are categoryId: ${categoryId}, questionLevel: ${questionLevel}, questionId: ${questionId}.`
  );

  const category = QuestionCategories.find((c) => c.id === categoryId);

  if (!category) {
    logger.warn(
      `[getExpertAnswer] - Could not find category with Id ${categoryId}`
    );
    throw new EntityNotFoundError(
      `Could not retrieve category with Id ${categoryId}`
    );
  }

  const questionsArray = category.questions[questionLevel - 1];

  if (!questionsArray) {
    logger.warn(
      `[getExpertAnswer] - Could not find level ${questionLevel} in category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find level ${questionLevel} in category ${category.name}`
    );
  }

  const question = questionsArray.find((q) => q.id === questionId);

  if (!question) {
    logger.warn(
      `[getExpertAnswer] - Could not find question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
    throw new EntityNotFoundError(
      `Could not find question with Id ${questionId} in level ${questionLevel} of category ${category.name}`
    );
  }

  const confidenceAlg = () => {
    if (questionLevel < 10) {
      // random number in range min, max: random() * (max - min) + min
      return Math.random() * (0.99 - 0.45) + 0.45;
    } else {
      return ((Math.random() * ((questionLevel * 0.667) - 1) + 1)/questionLevel)
    }
    
  }

  const confidence = confidenceAlg();
  const answer = confidence > 0.45 ? question.answers.find(ans => ans.correct).text : question.answers.find(ans => !ans.correct).text;

  const expertResponse = {
    answer: answer,
    confidence: confidence
  }

  logger.info(
    `[getExpertAnswer - Returning values: ${JSON.stringify(expertResponse)}`
  );

  res.json({
    success: true,
    data: expertResponse,
  });
};

module.exports = {
  getAllCategories,
  getCategoryQuestion,
  postQuestionAnswer,
  getFiftyFiftyAnswers,
  getExpertAnswer
};
