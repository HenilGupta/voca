import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/question_model.dart';

/// A slider widget for [QuestionType.slider] questions.
///
/// Renders a continuous slider between [QuestionModel.minValue] and
/// [QuestionModel.maxValue] with optional min/max labels.
///
/// Also handles [QuestionType.scale] by using discrete divisions.
class SliderQuestionWidget extends StatelessWidget {
  const SliderQuestionWidget({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuestionModel question;
  final double? value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final min = question.minValue ?? 0.0;
    final max = question.maxValue ?? 1.0;
    final isScale = question.type == QuestionType.scale;
    final divisions = isScale ? (max - min).toInt() : null;
    final currentValue = (value ?? ((min + max) / 2)).clamp(min, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current value display
        Semantics(
          liveRegion: true,
          child: Center(
            child: Text(
              isScale
                  ? currentValue.toInt().toString()
                  : currentValue.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Slider
        Semantics(
          label:
              '${question.question}. Current value: ${isScale ? currentValue.toInt() : currentValue.toStringAsFixed(2)}',
          hint: 'Swipe left or right to adjust',
          slider: true,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 14,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 24,
              ),
              valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: currentValue,
              min: min,
              max: max,
              divisions: divisions,
              label: isScale
                  ? currentValue.toInt().toString()
                  : currentValue.toStringAsFixed(2),
              onChanged: (v) {
                HapticFeedback.selectionClick();
                onChanged(v);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Min / Max labels
        if (question.minLabel != null || question.maxLabel != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (question.minLabel != null)
                  Flexible(
                    child: Text(
                      question.minLabel!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                if (question.maxLabel != null)
                  Flexible(
                    child: Text(
                      question.maxLabel!,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
