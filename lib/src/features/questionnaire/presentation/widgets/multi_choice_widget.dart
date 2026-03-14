import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/question_model.dart';

/// A multi-choice widget for [QuestionType.multiChoice] and
/// [QuestionType.pickN] questions.
///
/// Renders toggleable chips. For [QuestionType.pickN] the maximum
/// selectable items is capped at [QuestionModel.maxSelections].
class MultiChoiceWidget extends StatelessWidget {
  const MultiChoiceWidget({
    super.key,
    required this.question,
    required this.selectedValues,
    required this.onChanged,
  });

  final QuestionModel question;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final maxSelections = question.maxSelections;

    return FocusTraversalGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (maxSelections != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  '${selectedValues.length} of $maxSelections selected',
                  style: TextStyle(
                    color: selectedValues.length == maxSelections
                        ? Colors.white
                        : Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: question.options.map((option) {
              final isSelected = selectedValues.contains(option);
              final isDisabled = !isSelected &&
                  maxSelections != null &&
                  selectedValues.length >= maxSelections;

              return Semantics(
                label: option,
                hint: isSelected
                    ? 'Selected. Double tap to deselect'
                    : isDisabled
                        ? 'Maximum selections reached'
                        : 'Double tap to select',
                selected: isSelected,
                enabled: !isDisabled,
                button: true,
                child: Opacity(
                  opacity: isDisabled ? 0.4 : 1.0,
                  child: Material(
                    color: isSelected ? Colors.white : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    child: InkWell(
                      onTap: isDisabled
                          ? null
                          : () {
                              HapticFeedback.mediumImpact();
                              final updated =
                                  List<String>.from(selectedValues);
                              if (isSelected) {
                                updated.remove(option);
                              } else {
                                updated.add(option);
                              }
                              onChanged(updated);
                            },
                      borderRadius: BorderRadius.circular(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                option,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
