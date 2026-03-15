import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/question_model.dart';

/// An emoji-based single-choice widget for [QuestionType.emojiChoice].
///
/// Renders large tappable cards with emoji + label. Designed for
/// screen-reader accessibility — the full label text is announced,
/// not just the emoji.
class EmojiChoiceWidget extends StatelessWidget {
  const EmojiChoiceWidget({
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

          // Split emoji from text (expects format "😌 Quiet spaces")
          final emoji = option.characters.first;
          final label =
              option.substring(emoji.length).trim();

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Semantics(
              label: label,
              hint: isSelected ? 'Selected' : 'Double tap to select',
              selected: isSelected,
              button: true,
              child: Material(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.white,
                    width: isSelected ? 3 : 2,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onChanged(option);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 64),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          ExcludeSemantics(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.black,
                              size: 22,
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
