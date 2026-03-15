import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/app_logger.dart';
import '../domain/question_model.dart';
import '../domain/questionnaire_questions.dart';
import '../domain/questionnaire_state.dart';

/// Riverpod provider for the questionnaire notifier.
///
/// Used by the UI to access questionnaire state and operations.
final questionnaireNotifierProvider =
    StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>(
  (ref) => QuestionnaireNotifier(),
);

/// Manages the questionnaire flow: answers, navigation, validation, and
/// payload construction.
class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  QuestionnaireNotifier() : super(const QuestionnaireState());

  // ── Questions ───────────────────────────────────────────────

  /// The list of questions driving the UI.
  ///
  /// Currently uses the hard-coded [defaultQuestions]. In the future this
  /// can be replaced with questions fetched from an API endpoint.
  List<QuestionModel> get questions => defaultQuestions;

  /// Total number of questions.
  int get totalQuestions => questions.length;

  /// The currently displayed question.
  QuestionModel get currentQuestion => questions[state.currentIndex];

  /// Whether the user is on the last question.
  bool get isLastQuestion => state.currentIndex >= totalQuestions - 1;

  /// Whether the user is on the first question.
  bool get isFirstQuestion => state.currentIndex == 0;

  // ── Answer Management ───────────────────────────────────────

  /// Stores an answer for the given question [id].
  void setAnswer(String id, dynamic value) {
    final updatedAnswers = Map<String, dynamic>.from(state.answers)
      ..[id] = value;
    state = state.copyWith(
      answers: updatedAnswers,
      clearValidationError: true,
    );
  }

  /// Returns the current answer for a given question [id], or `null`.
  dynamic getAnswer(String id) => state.answers[id];

  // ── Navigation ──────────────────────────────────────────────

  /// Moves to the next question if validation passes.
  ///
  /// Returns `true` when the questionnaire is complete and should
  /// be submitted.
  bool nextQuestion() {
    if (!_validateCurrent()) return false;

    if (isLastQuestion) {
      AppLogger.log('QuestionnaireNotifier: Reached last question');
      return true; // Signal the UI to submit
    }

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      clearValidationError: true,
    );
    AppLogger.log(
      'QuestionnaireNotifier: Moved to question ${state.currentIndex + 1}/$totalQuestions',
    );
    return false;
  }

  /// Moves to the previous question.
  void previousQuestion() {
    if (isFirstQuestion) return;
    state = state.copyWith(
      currentIndex: state.currentIndex - 1,
      clearValidationError: true,
    );
  }

  // ── Validation ──────────────────────────────────────────────

  bool _validateCurrent() {
    final question = currentQuestion;
    final answer = getAnswer(question.id);

    // Optional questions always pass
    if (!question.isRequired) return true;

    switch (question.type) {
      case QuestionType.text:
        if (answer == null || (answer as String).trim().isEmpty) {
          state = state.copyWith(validationError: 'Please provide an answer');
          return false;
        }
      case QuestionType.number:
        if (answer == null) {
          state = state.copyWith(validationError: 'Please enter a number');
          return false;
        }
        final num? parsed =
            answer is int ? answer : int.tryParse(answer.toString());
        if (parsed == null || parsed <= 0) {
          state =
              state.copyWith(validationError: 'Please enter a valid number');
          return false;
        }
      case QuestionType.singleChoice:
      case QuestionType.emojiChoice:
        if (answer == null || (answer as String).isEmpty) {
          state = state.copyWith(validationError: 'Please select an option');
          return false;
        }
      case QuestionType.multiChoice:
        if (answer == null || (answer as List).isEmpty) {
          state = state.copyWith(
            validationError: 'Please select at least one option',
          );
          return false;
        }
      case QuestionType.pickN:
        final selections = answer as List<String>? ?? [];
        final required = question.maxSelections ?? 1;
        if (selections.length != required) {
          state = state.copyWith(
            validationError: 'Please pick exactly $required items',
          );
          return false;
        }
      case QuestionType.slider:
        // Slider always has a value (defaults to midpoint)
        break;
      case QuestionType.scale:
        if (answer == null) {
          state = state.copyWith(validationError: 'Please select a value');
          return false;
        }
    }

    state = state.copyWith(clearValidationError: true);
    return true;
  }

  // ── Submission ──────────────────────────────────────────────

  /// Builds the API payload and marks the questionnaire as complete.
  ///
  /// In the future this will POST to the backend. For now it logs
  /// the payload and flips [QuestionnaireState.isCompleted].
  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);

    final payload = state.toApiPayload();
    AppLogger.logData(
      'QuestionnaireNotifier: API payload → $payload',
    );

    // TODO: Replace with actual API call when the endpoint exists.
    // Example:
    // final apiClient = ref.read(apiClientProvider);
    // await apiClient.post('/questionnaire', data: payload);
    await Future<void>.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(
      isCompleted: true,
      isSubmitting: false,
    );
    AppLogger.log('QuestionnaireNotifier: Questionnaire completed');
  }

  /// Resets all state (useful for testing / re-taking).
  void reset() {
    state = const QuestionnaireState();
  }
}
