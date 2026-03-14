import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/routing/app_router.dart';
import 'src/shared/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: VocaApp()));
}

class VocaApp extends ConsumerWidget {
  const VocaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Voca',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) => AccessibilityTools(child: child),
    );
  }
}
