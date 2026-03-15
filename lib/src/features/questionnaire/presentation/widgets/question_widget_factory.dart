import 'package:flutter/material.dart';

import '../../domain/question_model.dart';
import 'emoji_choice_widget.dart';
import 'multi_choice_widget.dart';
import 'single_choice_widget.dart';
import 'slider_question_widget.dart';
import 'text_question_widget.dart';

/// Factory that maps a [QuestionModel] to the correct input widget.
///
/// This indirection ensures that the questionnaire screen has no
/// knowledge of specific widget implementations — making it trivial
/// to add new question types or swap widgets without touching the
/// screen code.
class QuestionWidgetFactory {
  const QuestionWidgetFactory._();

  /// Builds the appropriate widget for the given [question].
  ///
  /// [currentAnswer] is the current stored answer (may be `null`).
  /// [onAnswerChanged] is called with the new value whenever the
  /// user interacts with the widget.
  static Widget build({
    required QuestionModel question,
    required dynamic currentAnswer,
    required ValueChanged<dynamic> onAnswerChanged,
  }) {
    switch (question.type) {
      case QuestionType.text:
        return TextQuestionWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          value: currentAnswer as String?,
          onChanged: onAnswerChanged,
        );

      case QuestionType.number:
        return TextQuestionWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          value: currentAnswer?.toString(),
          onChanged: (v) => onAnswerChanged(int.tryParse(v) ?? v),
        );

      case QuestionType.singleChoice:
        return SingleChoiceWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          value: currentAnswer as String?,
          onChanged: onAnswerChanged,
        );

      case QuestionType.multiChoice:
        return MultiChoiceWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          selectedValues:
              (currentAnswer as List<String>?) ?? const <String>[],
          onChanged: onAnswerChanged,
        );

      case QuestionType.pickN:
        return MultiChoiceWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          selectedValues:
              (currentAnswer as List<String>?) ?? const <String>[],
          onChanged: onAnswerChanged,
        );

      case QuestionType.slider:
        return SliderQuestionWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          value: currentAnswer as double?,
          onChanged: onAnswerChanged,
        );

      case QuestionType.scale:
        return SliderQuestionWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          value: (currentAnswer as num?)?.toDouble(),
          onChanged: (v) => onAnswerChanged(v.round()),
        );

      case QuestionType.emojiChoice:
        return EmojiChoiceWidget(
          key: ValueKey('q_${question.id}'),
          question: question,
          value: currentAnswer as String?,
          onChanged: onAnswerChanged,
        );
    }
  }
}
