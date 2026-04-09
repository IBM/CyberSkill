package com.cyberskill.handler;

import com.cyberskill.model.*;
import com.cyberskill.service.QuizService;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Handler for Quiz-related HTTP requests
 */
public class QuizHandler {
    private static final Logger logger = LoggerFactory.getLogger(QuizHandler.class);
    private final QuizService quizService;

    public QuizHandler(QuizService quizService) {
        this.quizService = quizService;
    }

    // ==================== Quiz Endpoints ====================

    /**
     * GET /api/sections/:sectionId/quizzes
     */
    public void getQuizzesBySection(RoutingContext ctx) {
        try {
            UUID sectionId = UUID.fromString(ctx.pathParam("sectionId"));

            quizService.getQuizzesBySectionId(sectionId)
                    .onSuccess(quizzes -> {
                        JsonArray jsonArray = new JsonArray();
                        quizzes.forEach(quiz -> jsonArray.add(quizToJson(quiz)));
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(jsonArray.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting quizzes by section", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get quizzes")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid section ID")
                    .encode());
        }
    }

    /**
     * GET /api/quizzes/:id
     */
    public void getQuizById(RoutingContext ctx) {
        try {
            UUID quizId = UUID.fromString(ctx.pathParam("id"));

            quizService.getQuizById(quizId)
                    .onSuccess(quizOpt -> {
                        if (quizOpt.isPresent()) {
                            ctx.response()
                                    .putHeader("Content-Type", "application/json")
                                    .end(quizToJson(quizOpt.get()).encode());
                        } else {
                            ctx.response().setStatusCode(404).end(new JsonObject()
                                    .put("error", "Quiz not found")
                                    .encode());
                        }
                    })
                    .onFailure(err -> {
                        logger.error("Error getting quiz", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get quiz")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid quiz ID")
                    .encode());
        }
    }

    /**
     * GET /api/quizzes/:id/full - Get quiz with questions and answers for taking
     */
    public void getQuizForTaking(RoutingContext ctx) {
        try {
            UUID quizId = UUID.fromString(ctx.pathParam("id"));

            quizService.getQuizForTaking(quizId)
                    .onSuccess(quizData -> {
                        Quiz quiz = (Quiz) quizData.get("quiz");
                        List<Question> questions = (List<Question>) quizData.get("questions");
                        Map<UUID, List<Answer>> answers = (Map<UUID, List<Answer>>) quizData.get("answers");

                        JsonObject response = new JsonObject();
                        response.put("quiz", quizToJson(quiz));

                        JsonArray questionsArray = new JsonArray();
                        for (Question question : questions) {
                            JsonObject questionJson = questionToJson(question);
                            
                            // Add answers for this question (without isCorrect field)
                            JsonArray answersArray = new JsonArray();
                            List<Answer> questionAnswers = answers.get(question.getId());
                            if (questionAnswers != null) {
                                for (Answer answer : questionAnswers) {
                                    JsonObject answerJson = new JsonObject()
                                            .put("id", answer.getId().toString())
                                            .put("answerText", answer.getAnswerText())
                                            .put("orderIndex", answer.getOrderIndex());
                                    answersArray.add(answerJson);
                                }
                            }
                            questionJson.put("answers", answersArray);
                            questionsArray.add(questionJson);
                        }
                        response.put("questions", questionsArray);

                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(response.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting quiz for taking", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get quiz")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid quiz ID")
                    .encode());
        }
    }

    /**
     * POST /api/quizzes/:id/start - Start a new quiz attempt
     */
    public void startQuizAttempt(RoutingContext ctx) {
        try {
            UUID quizId = UUID.fromString(ctx.pathParam("id"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            quizService.startQuizAttempt(userId, quizId)
                    .onSuccess(attempt -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(attemptToJson(attempt).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error starting quiz attempt", err);
                        ctx.response().setStatusCode(400).end(new JsonObject()
                                .put("error", err.getMessage())
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid quiz ID")
                    .encode());
        }
    }

    /**
     * POST /api/attempts/:attemptId/answers - Submit an answer
     */
    public void submitAnswer(RoutingContext ctx) {
        try {
            UUID attemptId = UUID.fromString(ctx.pathParam("attemptId"));
            JsonObject body = ctx.body().asJsonObject();

            UUID questionId = UUID.fromString(body.getString("questionId"));
            UUID answerId = UUID.fromString(body.getString("answerId"));

            quizService.submitAnswer(attemptId, questionId, answerId)
                    .onSuccess(userAnswer -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(userAnswerToJson(userAnswer).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error submitting answer", err);
                        ctx.response().setStatusCode(400).end(new JsonObject()
                                .put("error", err.getMessage())
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid request data")
                    .encode());
        }
    }

    /**
     * POST /api/attempts/:attemptId/complete - Complete quiz attempt
     */
    public void completeQuizAttempt(RoutingContext ctx) {
        try {
            UUID attemptId = UUID.fromString(ctx.pathParam("attemptId"));

            quizService.completeQuizAttempt(attemptId)
                    .onSuccess(attempt -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(attemptToJson(attempt).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error completing quiz attempt", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to complete quiz attempt")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid attempt ID")
                    .encode());
        }
    }

    /**
     * GET /api/attempts/:attemptId - Get attempt details with results
     */
    public void getAttemptDetails(RoutingContext ctx) {
        try {
            UUID attemptId = UUID.fromString(ctx.pathParam("attemptId"));

            quizService.getQuizAttemptDetails(attemptId)
                    .onSuccess(details -> {
                        QuizAttempt attempt = (QuizAttempt) details.get("attempt");
                        Quiz quiz = (Quiz) details.get("quiz");
                        List<Question> questions = (List<Question>) details.get("questions");
                        List<UserAnswer> userAnswers = (List<UserAnswer>) details.get("userAnswers");

                        JsonObject response = new JsonObject();
                        response.put("attempt", attemptToJson(attempt));
                        response.put("quiz", quizToJson(quiz));

                        JsonArray questionsArray = new JsonArray();
                        questions.forEach(q -> questionsArray.add(questionToJson(q)));
                        response.put("questions", questionsArray);

                        JsonArray answersArray = new JsonArray();
                        userAnswers.forEach(a -> answersArray.add(userAnswerToJson(a)));
                        response.put("userAnswers", answersArray);

                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(response.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting attempt details", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get attempt details")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid attempt ID")
                    .encode());
        }
    }

    /**
     * GET /api/quizzes/:id/history - Get user's quiz history
     */
    public void getUserQuizHistory(RoutingContext ctx) {
        try {
            UUID quizId = UUID.fromString(ctx.pathParam("id"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            quizService.getUserQuizHistory(userId, quizId)
                    .onSuccess(attempts -> {
                        JsonArray jsonArray = new JsonArray();
                        attempts.forEach(attempt -> jsonArray.add(attemptToJson(attempt)));
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(jsonArray.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting quiz history", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get quiz history")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid quiz ID")
                    .encode());
        }
    }

    // ==================== Admin Endpoints ====================

    /**
     * POST /api/admin/quizzes - Create quiz
     */
    public void createQuiz(RoutingContext ctx) {
        try {
            JsonObject body = ctx.body().asJsonObject();
            Quiz quiz = jsonToQuiz(body);

            quizService.createQuiz(quiz)
                    .onSuccess(created -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(quizToJson(created).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating quiz", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to create quiz")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid quiz data")
                    .encode());
        }
    }

    /**
     * PUT /api/admin/quizzes/:id - Update quiz
     */
    public void updateQuiz(RoutingContext ctx) {
        try {
            UUID quizId = UUID.fromString(ctx.pathParam("id"));
            JsonObject body = ctx.body().asJsonObject();
            Quiz quiz = jsonToQuiz(body);
            quiz.setId(quizId);

            quizService.updateQuiz(quiz)
                    .onSuccess(updated -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(quizToJson(updated).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating quiz", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to update quiz")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid quiz data")
                    .encode());
        }
    }

    /**
     * DELETE /api/admin/quizzes/:id - Delete quiz
     */
    public void deleteQuiz(RoutingContext ctx) {
        try {
            UUID quizId = UUID.fromString(ctx.pathParam("id"));

            quizService.deleteQuiz(quizId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting quiz", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to delete quiz")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid quiz ID")
                    .encode());
        }
    }

    /**
     * POST /api/admin/questions - Create question
     */
    public void createQuestion(RoutingContext ctx) {
        try {
            JsonObject body = ctx.body().asJsonObject();
            Question question = jsonToQuestion(body);

            quizService.createQuestion(question)
                    .onSuccess(created -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(questionToJson(created).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating question", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to create question")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid question data")
                    .encode());
        }
    }

    /**
     * PUT /api/admin/questions/:id - Update question
     */
    public void updateQuestion(RoutingContext ctx) {
        try {
            UUID questionId = UUID.fromString(ctx.pathParam("id"));
            JsonObject body = ctx.body().asJsonObject();
            Question question = jsonToQuestion(body);
            question.setId(questionId);

            quizService.updateQuestion(question)
                    .onSuccess(updated -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(questionToJson(updated).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating question", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to update question")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid question data")
                    .encode());
        }
    }

    /**
     * DELETE /api/admin/questions/:id - Delete question
     */
    public void deleteQuestion(RoutingContext ctx) {
        try {
            UUID questionId = UUID.fromString(ctx.pathParam("id"));

            quizService.deleteQuestion(questionId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting question", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to delete question")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid question ID")
                    .encode());
        }
    }

    /**
     * POST /api/admin/answers - Create answer
     */
    public void createAnswer(RoutingContext ctx) {
        try {
            JsonObject body = ctx.body().asJsonObject();
            Answer answer = jsonToAnswer(body);

            quizService.createAnswer(answer)
                    .onSuccess(created -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(answerToJson(created).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating answer", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to create answer")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid answer data")
                    .encode());
        }
    }

    /**
     * PUT /api/admin/answers/:id - Update answer
     */
    public void updateAnswer(RoutingContext ctx) {
        try {
            UUID answerId = UUID.fromString(ctx.pathParam("id"));
            JsonObject body = ctx.body().asJsonObject();
            Answer answer = jsonToAnswer(body);
            answer.setId(answerId);

            quizService.updateAnswer(answer)
                    .onSuccess(updated -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(answerToJson(updated).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating answer", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to update answer")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid answer data")
                    .encode());
        }
    }

    /**
     * DELETE /api/admin/answers/:id - Delete answer
     */
    public void deleteAnswer(RoutingContext ctx) {
        try {
            UUID answerId = UUID.fromString(ctx.pathParam("id"));

            quizService.deleteAnswer(answerId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting answer", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to delete answer")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid answer ID")
                    .encode());
        }
    }

    // ==================== JSON Conversion Methods ====================

    private JsonObject quizToJson(Quiz quiz) {
        return new JsonObject()
                .put("id", quiz.getId().toString())
                .put("sectionId", quiz.getSectionId().toString())
                .put("title", quiz.getTitle())
                .put("description", quiz.getDescription())
                .put("passingScore", quiz.getPassingScore())
                .put("timeLimit", quiz.getTimeLimit())
                .put("maxAttempts", quiz.getMaxAttempts())
                .put("isActive", quiz.getIsActive())
                .put("createdAt", quiz.getCreatedAt().toString())
                .put("updatedAt", quiz.getUpdatedAt().toString());
    }

    private Quiz jsonToQuiz(JsonObject json) {
        Quiz quiz = new Quiz();
        if (json.containsKey("id")) {
            quiz.setId(UUID.fromString(json.getString("id")));
        }
        quiz.setSectionId(UUID.fromString(json.getString("sectionId")));
        quiz.setTitle(json.getString("title"));
        quiz.setDescription(json.getString("description"));
        quiz.setPassingScore(json.getInteger("passingScore"));
        quiz.setTimeLimit(json.getInteger("timeLimit"));
        quiz.setMaxAttempts(json.getInteger("maxAttempts"));
        if (json.containsKey("isActive")) {
            quiz.setIsActive(json.getBoolean("isActive"));
        }
        return quiz;
    }

    private JsonObject questionToJson(Question question) {
        return new JsonObject()
                .put("id", question.getId().toString())
                .put("quizId", question.getQuizId().toString())
                .put("questionText", question.getQuestionText())
                .put("questionType", question.getQuestionType().name())
                .put("points", question.getPoints())
                .put("orderIndex", question.getOrderIndex())
                .put("explanation", question.getExplanation())
                .put("createdAt", question.getCreatedAt().toString())
                .put("updatedAt", question.getUpdatedAt().toString());
    }

    private Question jsonToQuestion(JsonObject json) {
        Question question = new Question();
        if (json.containsKey("id")) {
            question.setId(UUID.fromString(json.getString("id")));
        }
        question.setQuizId(UUID.fromString(json.getString("quizId")));
        question.setQuestionText(json.getString("questionText"));
        question.setQuestionType(QuestionType.valueOf(json.getString("questionType")));
        question.setPoints(json.getInteger("points"));
        question.setOrderIndex(json.getInteger("orderIndex"));
        question.setExplanation(json.getString("explanation"));
        return question;
    }

    private JsonObject answerToJson(Answer answer) {
        return new JsonObject()
                .put("id", answer.getId().toString())
                .put("questionId", answer.getQuestionId().toString())
                .put("answerText", answer.getAnswerText())
                .put("isCorrect", answer.getIsCorrect())
                .put("orderIndex", answer.getOrderIndex())
                .put("createdAt", answer.getCreatedAt().toString())
                .put("updatedAt", answer.getUpdatedAt().toString());
    }

    private Answer jsonToAnswer(JsonObject json) {
        Answer answer = new Answer();
        if (json.containsKey("id")) {
            answer.setId(UUID.fromString(json.getString("id")));
        }
        answer.setQuestionId(UUID.fromString(json.getString("questionId")));
        answer.setAnswerText(json.getString("answerText"));
        answer.setIsCorrect(json.getBoolean("isCorrect"));
        answer.setOrderIndex(json.getInteger("orderIndex"));
        return answer;
    }

    private JsonObject attemptToJson(QuizAttempt attempt) {
        JsonObject json = new JsonObject()
                .put("id", attempt.getId().toString())
                .put("userId", attempt.getUserId().toString())
                .put("quizId", attempt.getQuizId().toString())
                .put("score", attempt.getScore())
                .put("totalPoints", attempt.getTotalPoints())
                .put("maxPoints", attempt.getMaxPoints())
                .put("passed", attempt.getPassed())
                .put("startedAt", attempt.getStartedAt().toString())
                .put("attemptNumber", attempt.getAttemptNumber());
        
        if (attempt.getCompletedAt() != null) {
            json.put("completedAt", attempt.getCompletedAt().toString());
        }
        
        return json;
    }

    private JsonObject userAnswerToJson(UserAnswer userAnswer) {
        JsonObject json = new JsonObject()
                .put("id", userAnswer.getId().toString())
                .put("attemptId", userAnswer.getAttemptId().toString())
                .put("questionId", userAnswer.getQuestionId().toString())
                .put("isCorrect", userAnswer.getIsCorrect())
                .put("pointsEarned", userAnswer.getPointsEarned())
                .put("answeredAt", userAnswer.getAnsweredAt().toString());
        
        if (userAnswer.getAnswerId() != null) {
            json.put("answerId", userAnswer.getAnswerId().toString());
        }
        if (userAnswer.getAnswerText() != null) {
            json.put("answerText", userAnswer.getAnswerText());
        }
        
        return json;
    }
}

// Made with Bob
