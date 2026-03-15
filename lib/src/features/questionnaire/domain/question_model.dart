/// Defines the types of questions supported in the questionnaire.
///
/// Each type maps to a specific widget rendered by [QuestionWidgetFactory].
enum QuestionType {
  /// Free-form text input.
  text,

  /// Numeric input (e.g. age).
  number,

  /// Select exactly one option from a list.
  singleChoice,

  /// Select one or more options from a list.
  multiChoice,

  /// Select exactly [maxSelections] options from a list.
  pickN,

  /// Continuous slider between a min and max value.
  slider,

  /// Discrete scale (e.g. 1–10).
  scale,

  /// Emoji-based single choice.
  emojiChoice,
}

/// A single question in the questionnaire.
///
/// This model is designed to be API-driven in the future — questions
/// can be serialised from a JSON endpoint response.
class QuestionModel {
  /// Unique key used as the answer map key and API payload field.
  final String id;

  /// The question text displayed to the user.
  final String question;

  /// The type of input expected.
  final QuestionType type;

  /// Available options for choice-based questions.
  /// Ignored for [QuestionType.text], [QuestionType.number],
  /// [QuestionType.slider], and [QuestionType.scale].
  final List<String> options;

  /// Whether the question must be answered before proceeding.
  final bool isRequired;

  /// Minimum value for [QuestionType.slider] and [QuestionType.scale].
  final double? minValue;

  /// Maximum value for [QuestionType.slider] and [QuestionType.scale].
  final double? maxValue;

  /// Label shown at the start (left) of a slider.
  final String? minLabel;

  /// Label shown at the end (right) of a slider.
  final String? maxLabel;

  /// For [QuestionType.pickN] — the exact number of items the user must pick.
  final int? maxSelections;

  /// Hint text shown in text fields.
  final String? hint;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.type,
    this.options = const [],
    this.isRequired = true,
    this.minValue,
    this.maxValue,
    this.minLabel,
    this.maxLabel,
    this.maxSelections,
    this.hint,
  });

  /// Creates a [QuestionModel] from a JSON map.
  ///
  /// Designed for future API integration when questions are
  /// fetched from a remote endpoint.
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,
      type: QuestionType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => QuestionType.text,
      ),
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isRequired: json['is_required'] as bool? ?? true,
      minValue: (json['min_value'] as num?)?.toDouble(),
      maxValue: (json['max_value'] as num?)?.toDouble(),
      minLabel: json['min_label'] as String?,
      maxLabel: json['max_label'] as String?,
      maxSelections: json['max_selections'] as int?,
      hint: json['hint'] as String?,
    );
  }

  /// Serialises this question to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type.name,
      'options': options,
      'is_required': isRequired,
      if (minValue != null) 'min_value': minValue,
      if (maxValue != null) 'max_value': maxValue,
      if (minLabel != null) 'min_label': minLabel,
      if (maxLabel != null) 'max_label': maxLabel,
      if (maxSelections != null) 'max_selections': maxSelections,
      if (hint != null) 'hint': hint,
    };
  }
}
