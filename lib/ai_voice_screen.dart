import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Data Models
// ---------------------------------------------------------------------------

class AIQuestion {
  const AIQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  final int id;
  final String question;
  final List<String> options;
}

const List<AIQuestion> _aiQuestions = [
  AIQuestion(
    id: 1,
    question: 'What is your hobby?',
    options: ['Traveling', 'Reading', 'Gaming', 'Sports'],
  ),
  AIQuestion(
    id: 2,
    question: 'Which type of weather do you like?',
    options: ['Sunny', 'Cloudy', 'Rainy', 'Snowy'],
  ),
];

// ---------------------------------------------------------------------------
// AI Voice Interaction Screen
// ---------------------------------------------------------------------------

class AIVoiceScreen extends StatefulWidget {
  const AIVoiceScreen({super.key});

  @override
  State<AIVoiceScreen> createState() => _AIVoiceScreenState();
}

class _AIVoiceScreenState extends State<AIVoiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartbeatController;
  int _currentQuestionIndex = 0;
  List<String> _userAnswers = [];
  bool _isRecording = false;
  String _currentAnswer = '';
  bool _showNextButton = false;

  @override
  void initState() {
    super.initState();
    // Heartbeat pattern: 3 fast beats (0.1s each) + 2 slow beats (0.3s each) = 1.2s total
    // Then pause and repeat
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Total cycle time
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    super.dispose();
  }

  double _getHeartbeatScale(double animationValue) {
    // 1500ms total cycle
    // 0-100ms: fast beat 1 (0-0.067)
    // 100-200ms: rest (0.067-0.133)
    // 200-300ms: fast beat 2 (0.133-0.2)
    // 300-400ms: rest (0.2-0.267)
    // 400-500ms: fast beat 3 (0.267-0.333)
    // 500-600ms: rest (0.333-0.4)
    // 600-900ms: slow beat 1 (0.4-0.6)
    // 900-1000ms: rest (0.6-0.667)
    // 1000-1300ms: slow beat 2 (0.667-0.867)
    // 1300-1500ms: rest (0.867-1.0)

    if (animationValue < 0.067) {
      // Fast beat 1
      return 1.0 + (animationValue / 0.067) * 0.3;
    } else if (animationValue < 0.133) {
      // Rest
      return 1.0;
    } else if (animationValue < 0.2) {
      // Fast beat 2
      return 1.0 + ((animationValue - 0.133) / 0.067) * 0.3;
    } else if (animationValue < 0.267) {
      // Rest
      return 1.0;
    } else if (animationValue < 0.333) {
      // Fast beat 3
      return 1.0 + ((animationValue - 0.267) / 0.067) * 0.3;
    } else if (animationValue < 0.4) {
      // Rest
      return 1.0;
    } else if (animationValue < 0.6) {
      // Slow beat 1
      return 1.0 + ((animationValue - 0.4) / 0.2) * 0.4;
    } else if (animationValue < 0.667) {
      // Rest
      return 1.0;
    } else if (animationValue < 0.867) {
      // Slow beat 2
      return 1.0 + ((animationValue - 0.667) / 0.2) * 0.4;
    } else {
      // Rest
      return 1.0;
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _currentAnswer = '';
      _showNextButton = false;
    });
    _heartbeatController.repeat();
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _currentAnswer = 'Traveling'; // Simulated speech-to-text result
      _showNextButton = true;
    });
    _heartbeatController.stop();
  }

  void _onNextQuestion() {
    if (_currentAnswer.isEmpty) {
      _showError('Please record your answer');
      return;
    }

    setState(() {
      _userAnswers.add(_currentAnswer);
      _currentAnswer = '';
      _currentQuestionIndex += 1;
      _showNextButton = false;
    });
  }

  void _proceedToSignup() {
    if (_userAnswers.length < _aiQuestions.length) {
      _showError('Please answer all questions first');
      return;
    }

    // Navigate to signup screen
    context.goNamed('signup');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF4566),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = _currentQuestionIndex >= _aiQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131C),
        elevation: 0,
        title: const Text(
          'Get to Know You',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: isLastQuestion
          ? _AllAnswersCompletedScreen(onProceed: _proceedToSignup)
          : _QuestionScreen(
              question: _aiQuestions[_currentQuestionIndex],
              questionNumber: _currentQuestionIndex + 1,
              totalQuestions: _aiQuestions.length,
              currentAnswer: _currentAnswer,
              isRecording: _isRecording,
              showNextButton: _showNextButton,
              onStartRecording: _startRecording,
              onStopRecording: _stopRecording,
              onNextQuestion: _onNextQuestion,
              heartbeatController: _heartbeatController,
              getHeartbeatScale: _getHeartbeatScale,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Question Screen
// ---------------------------------------------------------------------------

class _QuestionScreen extends StatelessWidget {
  const _QuestionScreen({
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.currentAnswer,
    required this.isRecording,
    required this.showNextButton,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onNextQuestion,
    required this.heartbeatController,
    required this.getHeartbeatScale,
  });

  final AIQuestion question;
  final int questionNumber;
  final int totalQuestions;
  final String currentAnswer;
  final bool isRecording;
  final bool showNextButton;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onNextQuestion;
  final AnimationController heartbeatController;
  final double Function(double) getHeartbeatScale;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        // Progress indicator
        _ProgressIndicator(
          current: questionNumber,
          total: totalQuestions,
        ),

        const SizedBox(height: 50),

        // AI Avatar / Status
        Center(
          child: Column(
            children: [
              // AI Avatar with heartbeat animation
              AnimatedBuilder(
                animation: heartbeatController,
                builder: (context, child) {
                  final scale = getHeartbeatScale(heartbeatController.value);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B2FFF).withOpacity(0.6),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // AI Status text
              Text(
                'Voca AI',
                style: const TextStyle(
                  color: Color(0xFFCBA6FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Question text
        Text(
          question.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          isRecording ? 'Recording... Speak now!' : 'Tap to record your answer',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isRecording
                ? const Color(0xFF34D66E)
                : Colors.white.withOpacity(0.5),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 60),

        // Record Button (Large)
        Center(
          child: GestureDetector(
            onLongPressStart: (_) => onStartRecording(),
            onLongPressEnd: (_) => onStopRecording(),
            child: AnimatedBuilder(
              animation: heartbeatController,
              builder: (context, child) {
                final scale = isRecording ? 1.0 + (heartbeatController.value * 0.15) : 1.0;
                final opacity = isRecording ? 0.3 + (heartbeatController.value * 0.4) : 0.2;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulsing ring
                    if (isRecording)
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF9B4DFF).withOpacity(opacity),
                            width: 2,
                          ),
                        ),
                      ),

                    // Main record button
                    Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isRecording
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFEE5A5A),
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFF9B4DFF),
                                    Color(0xFF5E17EB),
                                  ],
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: (isRecording
                                      ? const Color(0xFFFF6B6B)
                                      : const Color(0xFF7B2FFF))
                                  .withOpacity(0.6),
                              blurRadius: 32,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Recorded answer display
        if (currentAnswer.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2D1F4E)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your answer:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentAnswer,
                  style: const TextStyle(
                    color: Color(0xFFCBA6FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 40),

        // Next button (shows after recording)
        if (showNextButton)
          GestureDetector(
            onTap: onNextQuestion,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FFF).withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next Question',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),

        const SizedBox(height: 32),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// All Answers Completed Screen
// ---------------------------------------------------------------------------

class _AllAnswersCompletedScreen extends StatelessWidget {
  const _AllAnswersCompletedScreen({required this.onProceed});

  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        const SizedBox(height: 60),

        // Success icon
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B2FFF).withOpacity(0.6),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Success message
        const Text(
          'Great Job! 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'We learned a lot about you. Now let\'s get you set up!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 60),

        // Proceed button
        GestureDetector(
          onTap: onProceed,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B2FFF).withOpacity(0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_rounded, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  'Add Your Email & Phone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Progress Indicator
// ---------------------------------------------------------------------------

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question $current of $total',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '${(current / total * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Color(0xFFCBA6FF),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            backgroundColor: const Color(0xFF2D1F4E),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF9B4DFF),
            ),
          ),
        ),
      ],
    );
  }
}


