/// Immutable state for the questionnaire flow.
///
/// Tracks the current question index, all answers collected so far,
/// and any per-field validation errors.
class QuestionnaireState {
  /// Index of the currently displayed question.
  final int currentIndex;

  /// Map of question id → answer value.
  ///
  /// Value types:
  /// - [String] for text / singleChoice / emojiChoice
  /// - [int] for number
  /// - [double] for slider
  /// - [num] for scale
  /// - [List<String>] for multiChoice / pickN
  final Map<String, dynamic> answers;

  /// Per-field validation error messages. Null means no error.
  final String? validationError;

  /// Whether the questionnaire has been submitted.
  final bool isCompleted;

  /// Whether a submission is in progress (future API call).
  final bool isSubmitting;

  const QuestionnaireState({
    this.currentIndex = 0,
    this.answers = const {},
    this.validationError,
    this.isCompleted = false,
    this.isSubmitting = false,
  });

  QuestionnaireState copyWith({
    int? currentIndex,
    Map<String, dynamic>? answers,
    String? validationError,
    bool clearValidationError = false,
    bool? isCompleted,
    bool? isSubmitting,
  }) {
    return QuestionnaireState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      validationError:
          clearValidationError ? null : (validationError ?? this.validationError),
      isCompleted: isCompleted ?? this.isCompleted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  /// The fraction of questions answered (0.0 – 1.0).
  double progress(int totalQuestions) {
    if (totalQuestions == 0) return 0;
    return (currentIndex + 1) / totalQuestions;
  }

  /// Builds the payload matching the API contract.
  ///
  /// Missing answers default to sensible zero-values so the
  /// payload is always structurally complete.
  Map<String, dynamic> toApiPayload() {
    return {
      'about': answers['about'] ?? '',
      'age': answers['age'] ?? 0,
      'location': answers['location'] ?? '',
      'occupation': answers['occupation'] ?? '',
      'relationship_goal': answers['relationship_goal'] ?? '',
      'partner_trait': answers['partner_trait'] ?? '',
      'children_preference': answers['children_preference'] ?? '',
      'religion_importance': answers['religion_importance'] ?? 1,
      'activities': answers['activities'] ?? <String>[],
      'music_vibe': answers['music_vibe'] ?? '',
      'cuisine_description': answers['cuisine_description'] ?? '',
      'social_frequency': answers['social_frequency'] ?? '',
      'party_reaction': answers['party_reaction'] ?? '',
      'energy_preference': answers['energy_preference'] ?? '',
      'social_slider': answers['social_slider'] ?? 0.5,
      'crowd_energy': answers['crowd_energy'] ?? '',
      'conversation_style': answers['conversation_style'] ?? <String>[],
      'religious_preferences': answers['religious_preferences'] ?? '',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionnaireState &&
        other.currentIndex == currentIndex &&
        other.isCompleted == isCompleted &&
        other.isSubmitting == isSubmitting &&
        other.validationError == validationError;
  }

  @override
  int get hashCode {
    return Object.hash(currentIndex, isCompleted, isSubmitting, validationError);
  }
}
