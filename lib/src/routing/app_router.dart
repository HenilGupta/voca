import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/feed/presentation/feed_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/sign-in',
        name: 'signIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
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
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final isAuthRoute =
          state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';

      if (!isAuth && !isAuthRoute) {
        return '/sign-in';
      }

      if (isAuth && isAuthRoute) {
        return '/';
      }

      return null;
    },
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
}
