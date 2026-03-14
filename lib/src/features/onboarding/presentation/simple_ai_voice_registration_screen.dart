import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/onboarding_provider.dart';
import 'simple_audio_playback_screen.dart';

class SimpleAiVoiceRegistrationScreen extends ConsumerStatefulWidget {
  const SimpleAiVoiceRegistrationScreen({super.key});

  @override
  ConsumerState<SimpleAiVoiceRegistrationScreen> createState() => _SimpleAiVoiceRegistrationScreenState();
}

class _SimpleAiVoiceRegistrationScreenState extends ConsumerState<SimpleAiVoiceRegistrationScreen>
    with TickerProviderStateMixin {
  bool _isListening = false;
  bool _isProcessing = false;
  String _currentStep = 'Ready to start';
  String _voiceText = '';
  int _currentFieldIndex = 0;
  bool _allQuestionsCompleted = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  final List<String> _registrationFields = [
    'Full Name',
    'Email Address',
    'Phone Number',
    'Create Password',
  ];
  
  final Map<String, String> _registrationData = {};
  final Map<String, String> _audioFiles = {};
  final List<Duration> _recordingDurations = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _currentStep = 'Recording your ${_registrationFields[_currentFieldIndex]}...';
    });
    _pulseController.repeat(reverse: true);
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _isProcessing = true;
      _currentStep = 'Processing your recording...';
    });
    _pulseController.stop();
    
    // Simulate saving audio file
    String audioFileName = 'recording_${_currentFieldIndex + 1}_${DateTime.now().millisecondsSinceEpoch}.mp3';
    _audioFiles[_registrationFields[_currentFieldIndex]] = audioFileName;
    _recordingDurations.add(Duration(seconds: 3 + (_currentFieldIndex * 2)));

    // Simulate processing
    Future.delayed(const Duration(seconds: 1), () {
      _processVoiceInput();
    });
  }

  void _processVoiceInput() {
    String mockData = _getMockDataForField(_registrationFields[_currentFieldIndex]);
    
    setState(() {
      _isProcessing = false;
      _voiceText = mockData;
      _registrationData[_registrationFields[_currentFieldIndex]] = mockData;
      _currentStep = 'Captured: $mockData';
    });
    
    // Move to next field or complete all questions
    Future.delayed(const Duration(seconds: 1), () {
      if (_currentFieldIndex < _registrationFields.length - 1) {
        setState(() {
          _currentFieldIndex++;
          _currentStep = 'Ready for ${_registrationFields[_currentFieldIndex]}';
          _voiceText = '';
        });
      } else {
        setState(() {
          _allQuestionsCompleted = true;
          _currentStep = 'All recordings completed! Ready to submit.';
          _voiceText = '';
        });
      }
    });
  }

  String _getMockDataForField(String field) {
    switch (field) {
      case 'Full Name':
        return 'John Doe';
      case 'Email Address':
        return 'john.doe@example.com';
      case 'Phone Number':
        return '+1 (555) 123-4567';
      case 'Create Password':
        return '••••••••';
      default:
        return 'Sample Data';
    }
  }

  void _submitRecordings() {
    ref.read(onboardingNotifierProvider.notifier).updateAudioFiles(
      audioFiles: _audioFiles,
      recordingDurations: _recordingDurations,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimpleAudioPlaybackScreen(
          audioFiles: _audioFiles,
          recordingDurations: _recordingDurations,
          registrationFields: _registrationFields,
          registrationData: _registrationData,
        ),
      ),
    );
  }

  void _resetRegistration() {
    setState(() {
      _currentFieldIndex = 0;
      _registrationData.clear();
      _audioFiles.clear();
      _recordingDurations.clear();
      _currentStep = 'Ready to start';
      _voiceText = '';
      _isListening = false;
      _isProcessing = false;
      _allQuestionsCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Registration'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetRegistration,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight - 32.0,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.record_voice_over,
                    size: 50,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Voice-Powered Registration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Speak naturally and let AI handle the rest',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Progress Indicator
                  LinearProgressIndicator(
                    value: (_currentFieldIndex + 1) / _registrationFields.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _allQuestionsCompleted
                        ? 'Completed: ${_registrationFields.length}/${_registrationFields.length}'
                        : 'Step ${_currentFieldIndex + 1} of ${_registrationFields.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Current Step
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Current Field:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _allQuestionsCompleted
                              ? 'All Questions Completed'
                              : _currentFieldIndex < _registrationFields.length
                                  ? _registrationFields[_currentFieldIndex]
                                  : 'Complete',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Voice Animation and Status
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _isListening ? _pulseAnimation.value : 1.0,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: _isListening
                                        ? Colors.grey[800]
                                        : _isProcessing
                                          ? Colors.grey[600]
                                          : Colors.black,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_isListening
                                            ? Colors.grey[800]
                                            : _isProcessing
                                              ? Colors.grey[600]
                                              : Colors.black)!.withValues(alpha: 0.2),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isListening
                                        ? Icons.stop
                                        : _isProcessing
                                          ? Icons.psychology
                                          : _allQuestionsCompleted
                                            ? Icons.check_circle
                                            : Icons.mic,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              _currentStep,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_voiceText.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _voiceText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Action Button
                  if (!_allQuestionsCompleted)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing
                            ? null
                            : _isListening
                              ? _stopListening
                              : _startListening,
                        icon: Icon(
                          _isListening
                              ? Icons.stop
                              : _isProcessing
                                ? Icons.hourglass_empty
                                : Icons.mic,
                          size: 20,
                        ),
                        label: Text(
                          _isListening
                              ? 'Stop Recording'
                              : _isProcessing
                                ? 'Processing...'
                                : 'Start Recording',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isListening ? Colors.red[700] : Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    )
                  else
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _submitRecordings,
                        icon: const Icon(
                          Icons.cloud_upload,
                          size: 20,
                        ),
                        label: const Text(
                          'Submit All Recordings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Back button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back to Registration Type',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}