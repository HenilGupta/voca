import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/onboarding_state.dart';

/// Provider to manage onboarding completion state
final onboardingNotifierProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  /// Navigate to the next step in onboarding
  void nextStep() {
    final currentStep = state.currentStep;
    OnboardingStep? nextStep;

    switch (currentStep) {
      case OnboardingStep.selectRegistrationType:
        // This will be set by the registration type selection
        break;
      case OnboardingStep.manualRegistration:
        nextStep = OnboardingStep.completed;
        break;
      case OnboardingStep.aiVoiceRegistration:
        nextStep = OnboardingStep.audioPlayback;
        break;
      case OnboardingStep.audioPlayback:
        nextStep = OnboardingStep.completed;
        break;
      case OnboardingStep.completed:
        return; // Already completed
    }

    if (nextStep != null) {
      state = state.copyWith(
        currentStep: nextStep,
        isCompleted: nextStep == OnboardingStep.completed,
      );
    }
  }

  /// Set manual registration flow
  void selectManualRegistration() {
    state = state.copyWith(currentStep: OnboardingStep.manualRegistration);
  }

  /// Set AI voice registration flow
  void selectAiVoiceRegistration() {
    state = state.copyWith(currentStep: OnboardingStep.aiVoiceRegistration);
  }

  /// Update registration data
  void updateRegistrationData(Map<String, dynamic> data) {
    final updatedData = Map<String, dynamic>.from(state.registrationData)
      ..addAll(data);
    state = state.copyWith(registrationData: updatedData);
  }

  /// Update audio files data
  void updateAudioFiles({
    required Map<String, String> audioFiles,
    required List<Duration> recordingDurations,
  }) {
    state = state.copyWith(
      audioFiles: audioFiles,
      recordingDurations: recordingDurations,
    );
  }

  /// Complete onboarding process
  void completeOnboarding() {
    state = state.copyWith(
      currentStep: OnboardingStep.completed,
      isCompleted: true,
    );
    // In real app: Save completion status to SharedPreferences/Secure Storage
  }

  /// Reset onboarding (for testing purposes)
  void resetOnboarding() {
    state = const OnboardingState();
  }

  /// Check if onboarding is completed
  bool get isOnboardingCompleted => state.isCompleted;
}