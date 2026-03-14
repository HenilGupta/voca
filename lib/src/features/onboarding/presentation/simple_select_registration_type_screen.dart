import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/onboarding_provider.dart';
import 'simple_manual_registration_screen.dart';
import 'simple_ai_voice_registration_screen.dart';

class SimpleSelectRegistrationTypeScreen extends ConsumerWidget {
  const SimpleSelectRegistrationTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Type'),
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
            ),
            const SizedBox(height: 16),
            Text(
              'Select how you would like to register',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
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
                      builder: (context) => const SimpleManualRegistrationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, size: 24),
                label: const Text(
                  'Manual Registration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                  elevation: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // AI Voice Registration Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  onboardingNotifier.selectAiVoiceRegistration();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleAiVoiceRegistrationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.mic, size: 24),
                label: const Text(
                  'AI Voice Registration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                  elevation: 3,
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}