import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/sign_in_screen.dart';
import '../features/feed/presentation/feed_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/onboarding/presentation/simple_select_registration_type_screen.dart';
import '../features/onboarding/application/onboarding_provider.dart';
import '../features/questionnaire/presentation/questionnaire_screen.dart';
import '../features/questionnaire/application/questionnaire_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final onboardingState = ref.read(onboardingNotifierProvider);
      final isOnboardingCompleted = onboardingState.isCompleted;
      final questionnaireState = ref.read(questionnaireNotifierProvider);
      final isQuestionnaireCompleted = questionnaireState.isCompleted;
      final currentPath = state.fullPath!;

      // If user hasn't completed onboarding and isn't already on onboarding route
      if (!isOnboardingCompleted && !currentPath.startsWith('/onboarding') && currentPath != '/sign-in') {
        return '/onboarding';
      }

      // If onboarding is done but questionnaire is not, redirect to questionnaire
      if (isOnboardingCompleted &&
          !isQuestionnaireCompleted &&
          currentPath != '/questionnaire' &&
          currentPath != '/sign-in') {
        return '/questionnaire';
      }

      // If user completed onboarding but is on onboarding route, redirect to questionnaire
      if (isOnboardingCompleted && currentPath.startsWith('/onboarding')) {
        return isQuestionnaireCompleted ? '/' : '/questionnaire';
      }

      // If questionnaire completed and user is on questionnaire route, redirect to feed
      if (isQuestionnaireCompleted && currentPath == '/questionnaire') {
        return '/';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const SimpleSelectRegistrationTypeScreen(),
      ),
      GoRoute(
        path: '/questionnaire',
        name: 'questionnaire',
        builder: (context, state) => const QuestionnaireScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'feed',
        builder: (context, state) => const FeedScreen(),
      ),
      GoRoute(
        path: '/profile/:userId',
        name: 'profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return ProfileScreen(userId: userId);
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(
            child: Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
              semanticsLabel: 'Error: Page not found',
            ),
          ),
        ),
  );
});
