import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/questionnaire_provider.dart';
import 'widgets/question_widget_factory.dart';

/// The main questionnaire screen.
///
/// Displays one question at a time with forward/back navigation,
/// a progress indicator, and a final submission step.
///
/// Follows the app's strict B&W theme and WCAG 2.1 AA accessibility
/// guidelines.
class QuestionnaireScreen extends ConsumerWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questionnaireNotifierProvider);
    final notifier = ref.read(questionnaireNotifierProvider.notifier);
    final question = notifier.currentQuestion;
    final totalQuestions = notifier.totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About You'),
        centerTitle: true,
        leading: notifier.isFirstQuestion
            ? null
            : Semantics(
                label: 'Go back to previous question',
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Previous question',
                  onPressed: notifier.previousQuestion,
                ),
              ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress bar ─────────────────────────────────
            Semantics(
              label:
                  'Question ${state.currentIndex + 1} of $totalQuestions',
              child: LinearProgressIndicator(
                value: state.progress(totalQuestions),
                backgroundColor: Colors.white12,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 4,
              ),
            ),

            // ── Question content ─────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: FocusTraversalGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Step counter
                      Semantics(
                        header: true,
                        child: Text(
                          'Question ${state.currentIndex + 1} of $totalQuestions',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Question text
                      Semantics(
                        header: true,
                        child: Text(
                          question.question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Dynamic question widget
                      QuestionWidgetFactory.build(
                        question: question,
                        currentAnswer: notifier.getAnswer(question.id),
                        onAnswerChanged: (value) =>
                            notifier.setAnswer(question.id, value),
                      ),

                      // Validation error
                      if (state.validationError != null) ...[
                        const SizedBox(height: 16),
                        Semantics(
                          liveRegion: true,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    state.validationError!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom navigation buttons ────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white12),
                ),
              ),
              child: Row(
                children: [
                  // Back button
                  if (!notifier.isFirstQuestion)
                    Expanded(
                      child: Semantics(
                        label: 'Previous question',
                        button: true,
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: notifier.previousQuestion,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (!notifier.isFirstQuestion) const SizedBox(width: 16),

                  // Next / Submit button
                  Expanded(
                    flex: notifier.isFirstQuestion ? 1 : 1,
                    child: Semantics(
                      label: notifier.isLastQuestion
                          ? 'Submit questionnaire'
                          : 'Next question',
                      button: true,
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () => _handleNext(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.white54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  notifier.isLastQuestion
                                      ? 'Submit'
                                      : 'Next',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  // Skip button (for optional questions)
                  if (!question.isRequired) ...[
                    const SizedBox(width: 12),
                    Semantics(
                      label: 'Skip this question',
                      button: true,
                      child: SizedBox(
                        height: 52,
                        child: TextButton(
                          onPressed: () {
                            if (notifier.isLastQuestion) {
                              _handleSubmit(context, ref);
                            } else {
                              notifier.setAnswer(question.id, '');
                              // Manually advance
                              notifier.nextQuestion();
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white54,
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(questionnaireNotifierProvider.notifier);
    final shouldSubmit = notifier.nextQuestion();
    if (shouldSubmit) {
      _handleSubmit(context, ref);
    }
  }

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(questionnaireNotifierProvider.notifier);
    await notifier.submit();
    if (context.mounted) {
      context.go('/');
    }
  }
}
