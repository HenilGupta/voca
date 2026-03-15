import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../dating_screen.dart';
import '../../chat_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/profile',
    routes: [
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
          return ChatScreen(matchName: name, matchPhotoUrl: photo);
        },
      ),
    ],
  );
});
