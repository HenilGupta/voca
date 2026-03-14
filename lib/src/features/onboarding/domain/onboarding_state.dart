/// Represents the different stages of the onboarding process
enum OnboardingStep {
  selectRegistrationType,
  manualRegistration,
  aiVoiceRegistration,
  audioPlayback,
  completed,
}

/// Model for onboarding state management
class OnboardingState {
  final OnboardingStep currentStep;
  final Map<String, dynamic> registrationData;
  final Map<String, String> audioFiles;
  final List<Duration> recordingDurations;
  final bool isCompleted;

  const OnboardingState({
    this.currentStep = OnboardingStep.selectRegistrationType,
    this.registrationData = const {},
    this.audioFiles = const {},
    this.recordingDurations = const [],
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    Map<String, dynamic>? registrationData,
    Map<String, String>? audioFiles,
    List<Duration>? recordingDurations,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      registrationData: registrationData ?? this.registrationData,
      audioFiles: audioFiles ?? this.audioFiles,
      recordingDurations: recordingDurations ?? this.recordingDurations,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingState &&
        other.currentStep == currentStep &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return Object.hash(currentStep, isCompleted);
  }
}