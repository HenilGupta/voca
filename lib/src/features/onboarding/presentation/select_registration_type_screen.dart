import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/accessible_button.dart';
import '../application/onboarding_provider.dart';
import 'manual_registration_screen.dart';
import 'ai_voice_registration_screen.dart';

class SelectRegistrationTypeScreen extends ConsumerWidget {
  const SelectRegistrationTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration Type',
          semanticsLabel: 'Choose Registration Type',
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F5F5),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header section
            const Icon(
              Icons.app_registration,
              size: 80,
              color: Colors.black,
              semanticLabel: 'Registration icon',
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose Registration Type',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Choose your preferred registration method',
            ),
            const SizedBox(height: 16),
            Text(
              'Select how you would like to register',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Select your preferred registration method',
            ),
            const SizedBox(height: 48),
            
            // Manual Registration Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: AccessibleButton(
                onPressed: () {
                  onboardingNotifier.selectManualRegistration();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManualRegistrationScreen(),
                    ),
                  );
                },
                label: 'Manual Registration',
                semanticHint: 'Fill out forms with text input',
                icon: Icons.edit,
              ),
            ),
            const SizedBox(height: 20),
            
            // AI Voice Registration Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: AccessibleButton(
                onPressed: () {
                  onboardingNotifier.selectAiVoiceRegistration();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AiVoiceRegistrationScreen(),
                    ),
                  );
                },
                label: 'AI Voice Registration',
                semanticHint: 'Speak your information using AI voice recognition',
                icon: Icons.mic,
                outlined: true,
              ),
            ),
            const SizedBox(height: 40),
            
            // Footer text
            Text(
              'Choose the method that works best for you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Choose the registration method that works best for you',
            ),
          ],
        ),
      ),
    );
  }
}