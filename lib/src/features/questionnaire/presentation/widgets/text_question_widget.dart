import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/question_model.dart';

/// A text input widget for [QuestionType.text] questions.
///
/// Provides an accessible, single or multi-line text field with
/// semantic labeling and keyboard-friendly focus borders.
class TextQuestionWidget extends StatefulWidget {
  const TextQuestionWidget({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuestionModel question;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  State<TextQuestionWidget> createState() => _TextQuestionWidgetState();
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(TextQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value &&
        widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNumber = widget.question.type == QuestionType.number;

    return Semantics(
      label: widget.question.question,
      hint: widget.question.hint ?? 'Enter your answer',
      textField: true,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        maxLines: isNumber ? 1 : 3,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: widget.question.hint,
          counterText: '',
        ),
      ),
    );
  }
}
