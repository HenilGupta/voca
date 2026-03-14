import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/accessible_button.dart';
import '../../../shared/widgets/accessible_tappable.dart';
import '../application/onboarding_provider.dart';

class AudioPlaybackScreen extends ConsumerStatefulWidget {
  final Map<String, String> audioFiles;
  final List<Duration> recordingDurations;
  final List<String> registrationFields;
  final Map<String, String> registrationData;

  const AudioPlaybackScreen({
    super.key,
    required this.audioFiles,
    required this.recordingDurations,
    required this.registrationFields,
    required this.registrationData,
  });

  @override
  ConsumerState<AudioPlaybackScreen> createState() => _AudioPlaybackScreenState();
}

class _AudioPlaybackScreenState extends ConsumerState<AudioPlaybackScreen> {
  String? _currentlyPlayingFile;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  String _currentPlayingField = '';

  void _playAudio(String fieldName, String audioFile) {
    setState(() {
      if (_currentlyPlayingFile == audioFile && _isPlaying) {
        // Pause current audio
        _isPlaying = false;
        _currentlyPlayingFile = null;
        _currentPlayingField = '';
      } else {
        // Play new audio
        _currentlyPlayingFile = audioFile;
        _currentPlayingField = fieldName;
        _isPlaying = true;
        _currentPosition = 0.0;
      }
    });

    if (_isPlaying) {
      _simulateAudioPlayback(fieldName);
    }
  }

  void _simulateAudioPlayback(String fieldName) {
    // Simulate audio playback progress
    final duration = widget.recordingDurations[widget.registrationFields.indexOf(fieldName)];
    final totalSeconds = duration.inSeconds.toDouble();
    
    // Reset position
    _currentPosition = 0.0;
    
    // Simulate playback progress
    _updateProgress(totalSeconds);
  }

  void _updateProgress(double totalSeconds) {
    if (!_isPlaying) return;
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isPlaying && _currentPosition < totalSeconds) {
        setState(() {
          _currentPosition += 0.1;
        });
        _updateProgress(totalSeconds);
      } else if (_isPlaying && _currentPosition >= totalSeconds) {
        // Audio finished playing
        setState(() {
          _isPlaying = false;
          _currentlyPlayingFile = null;
          _currentPlayingField = '';
          _currentPosition = 0.0;
        });
      }
    });
  }

  void _seekAudio(double value, String fieldName) {
    setState(() {
      _currentPosition = value;
    });
    // TODO: Implement actual audio seeking here
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _finalSubmit() {
    // Complete onboarding
    ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Registration Complete',
            semanticsLabel: 'Registration completed successfully',
          ),
          content: const Text(
            'Your voice registration has been submitted successfully!',
            semanticsLabel: 'Your voice registration has been submitted successfully',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to AI voice screen
                Navigator.of(context).pop(); // Go back to selection screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Audio Recordings',
          semanticsLabel: 'Review your audio recordings',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          AccessibleTappable(
            semanticLabel: 'Submit registration',
            onTap: _finalSubmit,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Review Your Recordings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                semanticsLabel: 'Review your voice recordings',
              ),
              const SizedBox(height: 8),
              Text(
                'Play each recording to review your answers',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                semanticsLabel: 'Play each recording to review your answers',
              ),
              const SizedBox(height: 24),
              
              // Audio Files List
              Expanded(
                child: ListView.builder(
                  itemCount: widget.registrationFields.length,
                  itemBuilder: (context, index) {
                    final fieldName = widget.registrationFields[index];
                    final audioFile = widget.audioFiles[fieldName] ?? '';
                    final duration = index < widget.recordingDurations.length 
                        ? widget.recordingDurations[index] 
                        : const Duration(seconds: 5);
                    final isCurrentlyPlaying = _currentlyPlayingFile == audioFile && _isPlaying;
                    final totalSeconds = duration.inSeconds.toDouble();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question Title
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isCurrentlyPlaying ? Colors.green[600] : Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      semanticsLabel: 'Question ${index + 1}',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fieldName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        semanticsLabel: 'Field: $fieldName',
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Duration: ${_formatDuration(duration)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        semanticsLabel: 'Recording duration: ${_formatDuration(duration)}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Audio Controls
                            Row(
                              children: [
                                // Play/Pause Button
                                AccessibleTappable(
                                  semanticLabel: isCurrentlyPlaying 
                                      ? 'Pause $fieldName recording' 
                                      : 'Play $fieldName recording',
                                  onTap: () => _playAudio(fieldName, audioFile),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isCurrentlyPlaying ? Colors.red[600] : Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // Progress Bar
                                Expanded(
                                  child: Column(
                                    children: [
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 6,
                                          ),
                                          trackHeight: 4,
                                          activeTrackColor: Colors.black,
                                          inactiveTrackColor: Colors.grey[300],
                                          thumbColor: Colors.black,
                                        ),
                                        child: Slider(
                                          value: _currentPlayingField == fieldName 
                                              ? _currentPosition.clamp(0.0, totalSeconds)
                                              : 0.0,
                                          min: 0.0,
                                          max: totalSeconds,
                                          onChanged: (value) => _seekAudio(value, fieldName),
                                          semanticFormatterCallback: (value) {
                                            final currentTime = Duration(seconds: value.toInt());
                                            return '${_formatDuration(currentTime)} of ${_formatDuration(duration)}';
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(Duration(
                                                seconds: _currentPlayingField == fieldName 
                                                    ? _currentPosition.toInt()
                                                    : 0,
                                              )),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              _formatDuration(duration),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            // Audio File Info
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.audiotrack,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      audioFile,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontFamily: 'monospace',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      semanticsLabel: 'Audio file: $audioFile',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Submit Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: AccessibleButton(
                  onPressed: _finalSubmit,
                  label: 'Submit Registration',
                  semanticHint: 'Submit voice registration and complete onboarding',
                  icon: Icons.cloud_upload,
                ),
              ),
              const SizedBox(height: 8),
              
              // Back Button
              Center(
                child: AccessibleTappable(
                  semanticLabel: 'Go back to voice registration',
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Back to Recording',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}