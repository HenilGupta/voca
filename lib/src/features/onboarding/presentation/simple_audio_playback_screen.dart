import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/onboarding_provider.dart';

class SimpleAudioPlaybackScreen extends ConsumerStatefulWidget {
  final Map<String, String> audioFiles;
  final List<Duration> recordingDurations;
  final List<String> registrationFields;
  final Map<String, String> registrationData;

  const SimpleAudioPlaybackScreen({
    super.key,
    required this.audioFiles,
    required this.recordingDurations,
    required this.registrationFields,
    required this.registrationData,
  });

  @override
  ConsumerState<SimpleAudioPlaybackScreen> createState() => _SimpleAudioPlaybackScreenState();
}

class _SimpleAudioPlaybackScreenState extends ConsumerState<SimpleAudioPlaybackScreen> {
  String? _currentlyPlayingFile;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  String _currentPlayingField = '';

  void _playAudio(String fieldName, String audioFile) {
    setState(() {
      if (_currentlyPlayingFile == audioFile && _isPlaying) {
        _isPlaying = false;
        _currentlyPlayingFile = null;
        _currentPlayingField = '';
      } else {
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
    final duration = widget.recordingDurations[widget.registrationFields.indexOf(fieldName)];
    final totalSeconds = duration.inSeconds.toDouble();
    _currentPosition = 0.0;
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
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _finalSubmit() {
    ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          title: const Text(
            'Registration Complete',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Your voice registration has been submitted successfully!',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                context.go('/'); // Navigate to feed using GoRouter
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
        title: const Text('Audio Recordings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Go back to recording',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _finalSubmit,
            tooltip: 'Submit registration',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Play each recording to review your answers',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
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

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white54),
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
                                      color: isCurrentlyPlaying ? Colors.white : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
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
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Duration: ${_formatDuration(duration)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
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
                                  Semantics(
                                    label: isCurrentlyPlaying
                                        ? 'Pause $fieldName recording'
                                        : 'Play $fieldName recording',
                                    button: true,
                                    child: GestureDetector(
                                      onTap: () => _playAudio(fieldName, audioFile),
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isCurrentlyPlaying ? Colors.white70 : Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.black,
                                          size: 24,
                                        ),
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
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.white24,
                                            thumbColor: Colors.white,
                                          ),
                                          child: Slider(
                                            value: _currentPlayingField == fieldName
                                                ? _currentPosition.clamp(0.0, totalSeconds)
                                                : 0.0,
                                            min: 0.0,
                                            max: totalSeconds,
                                            onChanged: (value) => _seekAudio(value, fieldName),
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
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              Text(
                                                _formatDuration(duration),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white70,
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
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.audiotrack,
                                      size: 16,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        audioFile,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                          fontFamily: 'monospace',
                                        ),
                                        overflow: TextOverflow.ellipsis,
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
                  child: ElevatedButton.icon(
                    onPressed: _finalSubmit,
                    icon: const Icon(Icons.cloud_upload, size: 20),
                    label: const Text(
                      'Submit Registration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Back Button
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back to Recording',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

