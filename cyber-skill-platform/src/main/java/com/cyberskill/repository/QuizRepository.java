package com.cyberskill.repository;

import com.cyberskill.model.*;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository for Quiz database operations
 */
public class QuizRepository {
    private static final Logger logger = LoggerFactory.getLogger(QuizRepository.class);
    private final PgPool pool;

    public QuizRepository(PgPool pool) {
        this.pool = pool;
    }

    // ==================== Quiz CRUD Operations ====================

    public Future<Quiz> createQuiz(Quiz quiz) {
        Promise<Quiz> promise = Promise.promise();
        String sql = "INSERT INTO quizzes (id, section_id, title, description, passing_score, " +
                "time_limit, max_attempts, is_active, created_at, updated_at) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        quiz.getId(),
                        quiz.getSectionId(),
                        quiz.getTitle(),
                        quiz.getDescription(),
                        quiz.getPassingScore(),
                        quiz.getTimeLimit(),
                        quiz.getMaxAttempts(),
                        quiz.getIsActive(),
                        quiz.getCreatedAt(),
                        quiz.getUpdatedAt()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToQuiz(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to create quiz");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error creating quiz", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<Quiz>> findQuizById(UUID id) {
        Promise<Optional<Quiz>> promise = Promise.promise();
        String sql = "SELECT * FROM quizzes WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToQuiz(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding quiz by id", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<Quiz>> findQuizzesBySectionId(UUID sectionId) {
        Promise<List<Quiz>> promise = Promise.promise();
        String sql = "SELECT * FROM quizzes WHERE section_id = $1 AND is_active = true ORDER BY created_at";

        pool.preparedQuery(sql)
                .execute(Tuple.of(sectionId))
                .onSuccess(rows -> {
                    List<Quiz> quizzes = new ArrayList<>();
                    rows.forEach(row -> quizzes.add(mapRowToQuiz(row)));
                    promise.complete(quizzes);
                })
                .onFailure(err -> {
                    logger.error("Error finding quizzes by section", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Quiz> updateQuiz(Quiz quiz) {
        Promise<Quiz> promise = Promise.promise();
        quiz.setUpdatedAt(LocalDateTime.now());
        String sql = "UPDATE quizzes SET title = $1, description = $2, passing_score = $3, " +
                "time_limit = $4, max_attempts = $5, is_active = $6, updated_at = $7 " +
                "WHERE id = $8 RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        quiz.getTitle(),
                        quiz.getDescription(),
                        quiz.getPassingScore(),
                        quiz.getTimeLimit(),
                        quiz.getMaxAttempts(),
                        quiz.getIsActive(),
                        quiz.getUpdatedAt(),
                        quiz.getId()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToQuiz(rows.iterator().next()));
                    } else {
                        promise.fail("Quiz not found");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error updating quiz", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Void> deleteQuiz(UUID id) {
        Promise<Void> promise = Promise.promise();
        String sql = "DELETE FROM quizzes WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error deleting quiz", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    // ==================== Question CRUD Operations ====================

    public Future<Question> createQuestion(Question question) {
        Promise<Question> promise = Promise.promise();
        String sql = "INSERT INTO questions (id, quiz_id, question_text, question_type, points, " +
                "order_index, explanation, created_at, updated_at) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        question.getId(),
                        question.getQuizId(),
                        question.getQuestionText(),
                        question.getQuestionType().name(),
                        question.getPoints(),
                        question.getOrderIndex(),
                        question.getExplanation(),
                        question.getCreatedAt(),
                        question.getUpdatedAt()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToQuestion(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to create question");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error creating question", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<Question>> findQuestionById(UUID id) {
        Promise<Optional<Question>> promise = Promise.promise();
        String sql = "SELECT * FROM questions WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToQuestion(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding question by id", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<Question>> findQuestionsByQuizId(UUID quizId) {
        Promise<List<Question>> promise = Promise.promise();
        String sql = "SELECT * FROM questions WHERE quiz_id = $1 ORDER BY order_index";

        pool.preparedQuery(sql)
                .execute(Tuple.of(quizId))
                .onSuccess(rows -> {
                    List<Question> questions = new ArrayList<>();
                    rows.forEach(row -> questions.add(mapRowToQuestion(row)));
                    promise.complete(questions);
                })
                .onFailure(err -> {
                    logger.error("Error finding questions by quiz", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Question> updateQuestion(Question question) {
        Promise<Question> promise = Promise.promise();
        question.setUpdatedAt(LocalDateTime.now());
        String sql = "UPDATE questions SET question_text = $1, question_type = $2, points = $3, " +
                "order_index = $4, explanation = $5, updated_at = $6 WHERE id = $7 RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        question.getQuestionText(),
                        question.getQuestionType().name(),
                        question.getPoints(),
                        question.getOrderIndex(),
                        question.getExplanation(),
                        question.getUpdatedAt(),
                        question.getId()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToQuestion(rows.iterator().next()));
                    } else {
                        promise.fail("Question not found");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error updating question", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Void> deleteQuestion(UUID id) {
        Promise<Void> promise = Promise.promise();
        String sql = "DELETE FROM questions WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error deleting question", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    // ==================== Answer CRUD Operations ====================

    public Future<Answer> createAnswer(Answer answer) {
        Promise<Answer> promise = Promise.promise();
        String sql = "INSERT INTO answers (id, question_id, answer_text, is_correct, " +
                "order_index, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        answer.getId(),
                        answer.getQuestionId(),
                        answer.getAnswerText(),
                        answer.getIsCorrect(),
                        answer.getOrderIndex(),
                        answer.getCreatedAt(),
                        answer.getUpdatedAt()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToAnswer(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to create answer");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error creating answer", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<Answer>> findAnswersByQuestionId(UUID questionId) {
        Promise<List<Answer>> promise = Promise.promise();
        String sql = "SELECT * FROM answers WHERE question_id = $1 ORDER BY order_index";

        pool.preparedQuery(sql)
                .execute(Tuple.of(questionId))
                .onSuccess(rows -> {
                    List<Answer> answers = new ArrayList<>();
                    rows.forEach(row -> answers.add(mapRowToAnswer(row)));
                    promise.complete(answers);
                })
                .onFailure(err -> {
                    logger.error("Error finding answers by question", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Answer> updateAnswer(Answer answer) {
        Promise<Answer> promise = Promise.promise();
        answer.setUpdatedAt(LocalDateTime.now());
        String sql = "UPDATE answers SET answer_text = $1, is_correct = $2, order_index = $3, " +
                "updated_at = $4 WHERE id = $5 RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        answer.getAnswerText(),
                        answer.getIsCorrect(),
                        answer.getOrderIndex(),
                        answer.getUpdatedAt(),
                        answer.getId()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToAnswer(rows.iterator().next()));
                    } else {
                        promise.fail("Answer not found");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error updating answer", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Void> deleteAnswer(UUID id) {
        Promise<Void> promise = Promise.promise();
        String sql = "DELETE FROM answers WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error deleting answer", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    // ==================== Quiz Attempt Operations ====================

    public Future<QuizAttempt> createQuizAttempt(QuizAttempt attempt) {
        Promise<QuizAttempt> promise = Promise.promise();
        String sql = "INSERT INTO quiz_attempts (id, user_id, quiz_id, score, total_points, " +
                "max_points, passed, started_at, completed_at, attempt_number) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        attempt.getId(),
                        attempt.getUserId(),
                        attempt.getQuizId(),
                        attempt.getScore(),
                        attempt.getTotalPoints(),
                        attempt.getMaxPoints(),
                        attempt.getPassed(),
                        attempt.getStartedAt(),
                        attempt.getCompletedAt(),
                        attempt.getAttemptNumber()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToQuizAttempt(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to create quiz attempt");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error creating quiz attempt", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<QuizAttempt>> findQuizAttemptById(UUID id) {
        Promise<Optional<QuizAttempt>> promise = Promise.promise();
        String sql = "SELECT * FROM quiz_attempts WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToQuizAttempt(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding quiz attempt by id", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<QuizAttempt>> findQuizAttemptsByUserAndQuiz(UUID userId, UUID quizId) {
        Promise<List<QuizAttempt>> promise = Promise.promise();
        String sql = "SELECT * FROM quiz_attempts WHERE user_id = $1 AND quiz_id = $2 " +
                "ORDER BY attempt_number DESC";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, quizId))
                .onSuccess(rows -> {
                    List<QuizAttempt> attempts = new ArrayList<>();
                    rows.forEach(row -> attempts.add(mapRowToQuizAttempt(row)));
                    promise.complete(attempts);
                })
                .onFailure(err -> {
                    logger.error("Error finding quiz attempts", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Integer> countUserAttempts(UUID userId, UUID quizId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM quiz_attempts WHERE user_id = $1 AND quiz_id = $2";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, quizId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting user attempts", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<QuizAttempt> updateQuizAttempt(QuizAttempt attempt) {
        Promise<QuizAttempt> promise = Promise.promise();
        String sql = "UPDATE quiz_attempts SET score = $1, total_points = $2, max_points = $3, " +
                "passed = $4, completed_at = $5 WHERE id = $6 RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        attempt.getScore(),
                        attempt.getTotalPoints(),
                        attempt.getMaxPoints(),
                        attempt.getPassed(),
                        attempt.getCompletedAt(),
                        attempt.getId()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToQuizAttempt(rows.iterator().next()));
                    } else {
                        promise.fail("Quiz attempt not found");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error updating quiz attempt", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    // ==================== User Answer Operations ====================

    public Future<UserAnswer> createUserAnswer(UserAnswer userAnswer) {
        Promise<UserAnswer> promise = Promise.promise();
        String sql = "INSERT INTO user_answers (id, attempt_id, question_id, answer_id, " +
                "answer_text, is_correct, points_earned, answered_at) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        userAnswer.getId(),
                        userAnswer.getAttemptId(),
                        userAnswer.getQuestionId(),
                        userAnswer.getAnswerId(),
                        userAnswer.getAnswerText(),
                        userAnswer.getIsCorrect(),
                        userAnswer.getPointsEarned(),
                        userAnswer.getAnsweredAt()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToUserAnswer(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to create user answer");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error creating user answer", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<UserAnswer>> findUserAnswersByAttemptId(UUID attemptId) {
        Promise<List<UserAnswer>> promise = Promise.promise();
        String sql = "SELECT * FROM user_answers WHERE attempt_id = $1 ORDER BY answered_at";

        pool.preparedQuery(sql)
                .execute(Tuple.of(attemptId))
                .onSuccess(rows -> {
                    List<UserAnswer> userAnswers = new ArrayList<>();
                    rows.forEach(row -> userAnswers.add(mapRowToUserAnswer(row)));
                    promise.complete(userAnswers);
                })
                .onFailure(err -> {
                    logger.error("Error finding user answers by attempt", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count all quiz attempts across all users
     */
    public Future<Integer> countAllAttempts() {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM quiz_attempts";

        pool.query(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting all attempts", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get average score across all quiz attempts
     */
    public Future<Double> getAverageScore() {
        Promise<Double> promise = Promise.promise();
        String sql = "SELECT AVG(score) as avg_score FROM quiz_attempts WHERE completed_at IS NOT NULL";

        pool.query(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        Double avgScore = rows.iterator().next().getDouble("avg_score");
                        promise.complete(avgScore != null ? avgScore : 0.0);
                    } else {
                        promise.complete(0.0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error getting average score", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get pass rate (percentage of passed attempts)
     */
    public Future<Double> getPassRate() {
        Promise<Double> promise = Promise.promise();
        String sql = "SELECT " +
                "CASE WHEN COUNT(*) > 0 THEN " +
                "(SUM(CASE WHEN passed THEN 1 ELSE 0 END)::float / COUNT(*)::float) * 100 " +
                "ELSE 0 END as pass_rate " +
                "FROM quiz_attempts WHERE completed_at IS NOT NULL";

        pool.query(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        Double passRate = rows.iterator().next().getDouble("pass_rate");
                        promise.complete(passRate != null ? passRate : 0.0);
                    } else {
                        promise.complete(0.0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error getting pass rate", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    // ==================== Mapping Methods ====================

    private Quiz mapRowToQuiz(Row row) {
        Quiz quiz = new Quiz();
        quiz.setId(row.getUUID("id"));
        quiz.setSectionId(row.getUUID("section_id"));
        quiz.setTitle(row.getString("title"));
        quiz.setDescription(row.getString("description"));
        quiz.setPassingScore(row.getInteger("passing_score"));
        quiz.setTimeLimit(row.getInteger("time_limit"));
        quiz.setMaxAttempts(row.getInteger("max_attempts"));
        quiz.setIsActive(row.getBoolean("is_active"));
        quiz.setCreatedAt(row.getLocalDateTime("created_at"));
        quiz.setUpdatedAt(row.getLocalDateTime("updated_at"));
        
        // Handle JSONB fields (V4 migration adds these)
        try {
            String contentSource = row.getString("content_source");
            if (contentSource != null) {
                quiz.setContentSource(contentSource);
            }
            
            Object quizJsonObj = row.getValue("quiz_json");
            if (quizJsonObj != null) {
                quiz.setQuizJson(new io.vertx.core.json.JsonObject(quizJsonObj.toString()));
            }
            
            Object metadataObj = row.getValue("metadata");
            if (metadataObj != null) {
                quiz.setMetadata(new io.vertx.core.json.JsonObject(metadataObj.toString()));
            }
        } catch (Exception e) {
            // Columns don't exist yet (pre-V4 migration), ignore
            logger.debug("JSONB columns not available yet: " + e.getMessage());
        }
        
        return quiz;
    }

    private Question mapRowToQuestion(Row row) {
        Question question = new Question();
        question.setId(row.getUUID("id"));
        question.setQuizId(row.getUUID("quiz_id"));
        question.setQuestionText(row.getString("question_text"));
        question.setQuestionType(QuestionType.valueOf(row.getString("question_type")));
        question.setPoints(row.getInteger("points"));
        question.setOrderIndex(row.getInteger("order_index"));
        question.setExplanation(row.getString("explanation"));
        question.setCreatedAt(row.getLocalDateTime("created_at"));
        question.setUpdatedAt(row.getLocalDateTime("updated_at"));
        return question;
    }

    private Answer mapRowToAnswer(Row row) {
        Answer answer = new Answer();
        answer.setId(row.getUUID("id"));
        answer.setQuestionId(row.getUUID("question_id"));
        answer.setAnswerText(row.getString("answer_text"));
        answer.setIsCorrect(row.getBoolean("is_correct"));
        answer.setOrderIndex(row.getInteger("order_index"));
        answer.setCreatedAt(row.getLocalDateTime("created_at"));
        answer.setUpdatedAt(row.getLocalDateTime("updated_at"));
        return answer;
    }

    private QuizAttempt mapRowToQuizAttempt(Row row) {
        QuizAttempt attempt = new QuizAttempt();
        attempt.setId(row.getUUID("id"));
        attempt.setUserId(row.getUUID("user_id"));
        attempt.setQuizId(row.getUUID("quiz_id"));
        attempt.setScore(row.getInteger("score"));
        attempt.setTotalPoints(row.getInteger("total_points"));
        attempt.setMaxPoints(row.getInteger("max_points"));
        attempt.setPassed(row.getBoolean("passed"));
        attempt.setStartedAt(row.getLocalDateTime("started_at"));
        attempt.setCompletedAt(row.getLocalDateTime("completed_at"));
        attempt.setAttemptNumber(row.getInteger("attempt_number"));
        return attempt;
    }

    private UserAnswer mapRowToUserAnswer(Row row) {
        UserAnswer userAnswer = new UserAnswer();
        userAnswer.setId(row.getUUID("id"));
        userAnswer.setAttemptId(row.getUUID("attempt_id"));
        userAnswer.setQuestionId(row.getUUID("question_id"));
        userAnswer.setAnswerId(row.getUUID("answer_id"));
        userAnswer.setAnswerText(row.getString("answer_text"));
        userAnswer.setIsCorrect(row.getBoolean("is_correct"));
        userAnswer.setPointsEarned(row.getInteger("points_earned"));
        userAnswer.setAnsweredAt(row.getLocalDateTime("answered_at"));
        return userAnswer;
    }
}

// Made with Bob
