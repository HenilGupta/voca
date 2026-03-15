import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/question_model.dart';

/// A single-choice widget for [QuestionType.singleChoice] questions.
///
/// Renders a vertical list of tappable option chips. The selected
/// option is highlighted with white-on-black / black-on-white contrast.
/// All items meet the 48×48 minimum tap-target requirement.
class SingleChoiceWidget extends StatelessWidget {
  const SingleChoiceWidget({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuestionModel question;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: question.options.map((option) {
          final isSelected = value == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Semantics(
              label: option,
              hint: isSelected ? 'Selected' : 'Double tap to select',
              selected: isSelected,
              button: true,
              child: Material(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onChanged(option);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 52),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected ? Colors.black : Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.black : Colors.white,
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
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
    );
  }
}
