import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../login_screen.dart';
import '../../ai_voice_screen.dart';
import '../../signup_screen.dart';
import '../../registration_screen.dart';
import '../../dating_screen.dart';
import '../../chat_screen.dart';
import '../../profile_info_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/ai-voice',
        name: 'ai-voice',
        builder: (context, state) => const AIVoiceScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const DatingScreen(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) {
          final name = state.uri.queryParameters['name'] ?? 'Match';
          final photo = state.uri.queryParameters['photo'] ?? '';
          final age = int.tryParse(state.uri.queryParameters['age'] ?? '') ?? 25;
          final bio = state.uri.queryParameters['bio'] ?? '';
          final interestsRaw = state.uri.queryParameters['interests'] ?? '';
          final interests = interestsRaw.isEmpty ? <String>[] : interestsRaw.split('|');
          final voice = state.uri.queryParameters['voice'] ?? '0:12';

          return ChatScreen(
            matchName: name,
            matchPhotoUrl: photo,
            matchAge: age,
            matchBio: bio,
            matchInterests: interests,
            voiceDuration: voice,
          );
        },
      ),
      GoRoute(
        path: '/profile-info',
        name: 'profile-info',
        builder: (context, state) {
          final name = state.uri.queryParameters['name'] ?? 'Match';
          final photo = state.uri.queryParameters['photo'] ?? '';
          final age = int.tryParse(state.uri.queryParameters['age'] ?? '') ?? 25;
          final bio = state.uri.queryParameters['bio'] ?? '';
          final interestsRaw = state.uri.queryParameters['interests'] ?? '';
          final interests = interestsRaw.isEmpty ? <String>[] : interestsRaw.split('|');
          final voice = state.uri.queryParameters['voice'] ?? '0:12';

          return ProfileInfoScreen(
            name: name,
            photoUrl: photo,
            age: age,
            bio: bio,
            interests: interests,
            voiceDuration: voice,
          );
        },
      ),
    ],
  );
});
