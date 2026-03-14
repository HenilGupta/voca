import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/onboarding_provider.dart';
import 'manual_registration_screen.dart';
import 'simple_ai_voice_registration_screen.dart';

class SimpleSelectRegistrationTypeScreen extends ConsumerWidget {
  const SimpleSelectRegistrationTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Registration Type'), centerTitle: true),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header section
            Semantics(
              label: 'Registration icon',
              child: const Icon(
                Icons.app_registration,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose Registration Type',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Select how you would like to register',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Manual Registration Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  onboardingNotifier.selectManualRegistration();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManualRegistrationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, size: 24),
                label: const Text(
                  'Manual Registration',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // AI Voice Registration Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton.icon(
                onPressed: () {
                  onboardingNotifier.selectAiVoiceRegistration();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const SimpleAiVoiceRegistrationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.mic, size: 24),
                label: const Text(
                  'AI Voice Registration',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Footer text
            const Text(
              'Choose the method that works best for you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
