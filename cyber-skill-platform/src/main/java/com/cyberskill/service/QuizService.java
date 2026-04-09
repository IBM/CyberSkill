package com.cyberskill.service;

import com.cyberskill.model.*;
import com.cyberskill.repository.QuizRepository;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.*;

/**
 * Service layer for Quiz business logic
 */
public class QuizService {
    private static final Logger logger = LoggerFactory.getLogger(QuizService.class);
    private final QuizRepository quizRepository;

    public QuizService(QuizRepository quizRepository) {
        this.quizRepository = quizRepository;
    }

    // ==================== Quiz Operations ====================

    public Future<Quiz> createQuiz(Quiz quiz) {
        return quizRepository.createQuiz(quiz);
    }

    public Future<Optional<Quiz>> getQuizById(UUID id) {
        return quizRepository.findQuizById(id);
    }

    public Future<List<Quiz>> getQuizzesBySectionId(UUID sectionId) {
        return quizRepository.findQuizzesBySectionId(sectionId);
    }

    public Future<Quiz> updateQuiz(Quiz quiz) {
        return quizRepository.updateQuiz(quiz);
    }

    public Future<Void> deleteQuiz(UUID id) {
        return quizRepository.deleteQuiz(id);
    }

    // ==================== Question Operations ====================

    public Future<Question> createQuestion(Question question) {
        return quizRepository.createQuestion(question);
    }

    public Future<Optional<Question>> getQuestionById(UUID id) {
        return quizRepository.findQuestionById(id);
    }

    public Future<List<Question>> getQuestionsByQuizId(UUID quizId) {
        return quizRepository.findQuestionsByQuizId(quizId);
    }

    public Future<Question> updateQuestion(Question question) {
        return quizRepository.updateQuestion(question);
    }

    public Future<Void> deleteQuestion(UUID id) {
        return quizRepository.deleteQuestion(id);
    }

    // ==================== Answer Operations ====================

    public Future<Answer> createAnswer(Answer answer) {
        return quizRepository.createAnswer(answer);
    }

    public Future<List<Answer>> getAnswersByQuestionId(UUID questionId) {
        return quizRepository.findAnswersByQuestionId(questionId);
    }

    public Future<Answer> updateAnswer(Answer answer) {
        return quizRepository.updateAnswer(answer);
    }

    public Future<Void> deleteAnswer(UUID id) {
        return quizRepository.deleteAnswer(id);
    }

    // ==================== Quiz Taking Operations ====================

    /**
     * Start a new quiz attempt for a user
     */
    public Future<QuizAttempt> startQuizAttempt(UUID userId, UUID quizId) {
        Promise<QuizAttempt> promise = Promise.promise();

        // First, get the quiz to check max attempts
        quizRepository.findQuizById(quizId)
                .compose(quizOpt -> {
                    if (quizOpt.isEmpty()) {
                        return Future.failedFuture("Quiz not found");
                    }

                    Quiz quiz = quizOpt.get();

                    // Check if quiz is active
                    if (!quiz.getIsActive()) {
                        return Future.failedFuture("Quiz is not active");
                    }

                    // Count existing attempts
                    return quizRepository.countUserAttempts(userId, quizId)
                            .compose(attemptCount -> {
                                // Check max attempts
                                if (quiz.getMaxAttempts() != null && attemptCount >= quiz.getMaxAttempts()) {
                                    return Future.failedFuture("Maximum attempts reached");
                                }

                                // Create new attempt
                                QuizAttempt attempt = new QuizAttempt(userId, quizId, attemptCount + 1);
                                return quizRepository.createQuizAttempt(attempt);
                            });
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Submit an answer for a question in a quiz attempt
     */
    public Future<UserAnswer> submitAnswer(UUID attemptId, UUID questionId, UUID answerId) {
        Promise<UserAnswer> promise = Promise.promise();

        // Get the answer to check if it's correct
        quizRepository.findAnswersByQuestionId(questionId)
                .compose(answers -> {
                    // Find the selected answer
                    Optional<Answer> selectedAnswer = answers.stream()
                            .filter(a -> a.getId().equals(answerId))
                            .findFirst();

                    if (selectedAnswer.isEmpty()) {
                        return Future.failedFuture("Answer not found");
                    }

                    // Get the question to determine points
                    return quizRepository.findQuestionById(questionId)
                            .compose(questionOpt -> {
                                if (questionOpt.isEmpty()) {
                                    return Future.failedFuture("Question not found");
                                }

                                Question question = questionOpt.get();
                                Answer answer = selectedAnswer.get();

                                // Create user answer
                                UserAnswer userAnswer = new UserAnswer(attemptId, questionId, answerId);
                                userAnswer.setIsCorrect(answer.getIsCorrect());
                                userAnswer.setPointsEarned(answer.getIsCorrect() ? question.getPoints() : 0);

                                return quizRepository.createUserAnswer(userAnswer);
                            });
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Complete a quiz attempt and calculate the score
     */
    public Future<QuizAttempt> completeQuizAttempt(UUID attemptId) {
        Promise<QuizAttempt> promise = Promise.promise();

        // Get the attempt
        quizRepository.findQuizAttemptById(attemptId)
                .compose(attemptOpt -> {
                    if (attemptOpt.isEmpty()) {
                        return Future.failedFuture("Quiz attempt not found");
                    }

                    QuizAttempt attempt = attemptOpt.get();

                    // Get all user answers for this attempt
                    return quizRepository.findUserAnswersByAttemptId(attemptId)
                            .compose(userAnswers -> {
                                // Calculate total points earned
                                int totalPoints = userAnswers.stream()
                                        .mapToInt(UserAnswer::getPointsEarned)
                                        .sum();

                                // Get all questions for the quiz to calculate max points
                                return quizRepository.findQuestionsByQuizId(attempt.getQuizId())
                                        .compose(questions -> {
                                            int maxPoints = questions.stream()
                                                    .mapToInt(Question::getPoints)
                                                    .sum();

                                            // Calculate percentage score
                                            int score = maxPoints > 0 ? (totalPoints * 100) / maxPoints : 0;

                                            // Get quiz to check passing score
                                            return quizRepository.findQuizById(attempt.getQuizId())
                                                    .compose(quizOpt -> {
                                                        if (quizOpt.isEmpty()) {
                                                            return Future.failedFuture("Quiz not found");
                                                        }

                                                        Quiz quiz = quizOpt.get();
                                                        boolean passed = score >= quiz.getPassingScore();

                                                        // Update attempt with results
                                                        attempt.setScore(score);
                                                        attempt.setTotalPoints(totalPoints);
                                                        attempt.setMaxPoints(maxPoints);
                                                        attempt.setPassed(passed);
                                                        attempt.setCompletedAt(LocalDateTime.now());

                                                        return quizRepository.updateQuizAttempt(attempt);
                                                    });
                                        });
                            });
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get quiz attempt with all questions, answers, and user responses
     */
    public Future<Map<String, Object>> getQuizAttemptDetails(UUID attemptId) {
        Promise<Map<String, Object>> promise = Promise.promise();

        quizRepository.findQuizAttemptById(attemptId)
                .compose(attemptOpt -> {
                    if (attemptOpt.isEmpty()) {
                        return Future.failedFuture("Quiz attempt not found");
                    }

                    QuizAttempt attempt = attemptOpt.get();

                    // Get quiz details
                    return quizRepository.findQuizById(attempt.getQuizId())
                            .compose(quizOpt -> {
                                if (quizOpt.isEmpty()) {
                                    return Future.failedFuture("Quiz not found");
                                }

                                Quiz quiz = quizOpt.get();

                                // Get all questions
                                return quizRepository.findQuestionsByQuizId(quiz.getId())
                                        .compose(questions -> {
                                            // Get user answers
                                            return quizRepository.findUserAnswersByAttemptId(attemptId)
                                                    .compose(userAnswers -> {
                                                        // Build response
                                                        Map<String, Object> result = new HashMap<>();
                                                        result.put("attempt", attempt);
                                                        result.put("quiz", quiz);
                                                        result.put("questions", questions);
                                                        result.put("userAnswers", userAnswers);

                                                        return Future.succeededFuture(result);
                                                    });
                                        });
                            });
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get user's quiz history for a specific quiz
     */
    public Future<List<QuizAttempt>> getUserQuizHistory(UUID userId, UUID quizId) {
        return quizRepository.findQuizAttemptsByUserAndQuiz(userId, quizId);
    }

    /**
     * Check if user can take the quiz (hasn't exceeded max attempts)
     */
    public Future<Boolean> canUserTakeQuiz(UUID userId, UUID quizId) {
        Promise<Boolean> promise = Promise.promise();

        quizRepository.findQuizById(quizId)
                .compose(quizOpt -> {
                    if (quizOpt.isEmpty()) {
                        return Future.failedFuture("Quiz not found");
                    }

                    Quiz quiz = quizOpt.get();

                    // If no max attempts, user can always take it
                    if (quiz.getMaxAttempts() == null) {
                        return Future.succeededFuture(true);
                    }

                    // Check attempt count
                    return quizRepository.countUserAttempts(userId, quizId)
                            .map(count -> count < quiz.getMaxAttempts());
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get quiz with all questions and answers (for taking the quiz)
     * Note: This should NOT include which answers are correct
     */
    public Future<Map<String, Object>> getQuizForTaking(UUID quizId) {
        Promise<Map<String, Object>> promise = Promise.promise();

        quizRepository.findQuizById(quizId)
                .compose(quizOpt -> {
                    if (quizOpt.isEmpty()) {
                        return Future.failedFuture("Quiz not found");
                    }

                    Quiz quiz = quizOpt.get();

                    // Get all questions
                    return quizRepository.findQuestionsByQuizId(quizId)
                            .compose(questions -> {
                                // Get answers for all questions
                                List<Future<List<Answer>>> answerFutures = new ArrayList<>();
                                for (Question question : questions) {
                                    answerFutures.add(quizRepository.findAnswersByQuestionId(question.getId()));
                                }

                                return Future.all(answerFutures)
                                        .map(compositeFuture -> {
                                            Map<String, Object> result = new HashMap<>();
                                            result.put("quiz", quiz);
                                            result.put("questions", questions);

                                            // Build question-answer map
                                            Map<UUID, List<Answer>> questionAnswers = new HashMap<>();
                                            for (int i = 0; i < questions.size(); i++) {
                                                List<Answer> answers = compositeFuture.resultAt(i);
                                                questionAnswers.put(questions.get(i).getId(), answers);
                                            }
                                            result.put("answers", questionAnswers);

                                            return result;
                                        });
                            });
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }
}

// Made with Bob
