import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/feed_provider.dart';
import '../../../shared/widgets/accessible_button.dart';
import '../../../shared/widgets/accessible_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(feedNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voca'),
        centerTitle: true,
      ),
      body: profiles.isEmpty
          ? Center(
              child: Text(
                'No more profiles',
                style: Theme.of(context).textTheme.headlineSmall,
                semanticsLabel: 'No more profiles to show',
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Expanded(
                    child: AccessibleCard(
                      semanticLabel:
                          '${profiles.first.name}, age ${profiles.first.age}. ${profiles.first.bio}',
                      onTap: () => context.pushNamed(
                        'profile',
                        pathParameters: {'userId': profiles.first.id},
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Semantics(
                                  label: profiles.first.imageSemanticLabel,
                                  child: const Icon(
                                    Icons.person,
                                    size: 120,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${profiles.first.name}, ${profiles.first.age}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profiles.first.bio,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AccessibleButton(
                        label: 'Pass',
                        semanticHint: 'Skip this profile',
                        icon: Icons.close,
                        outlined: true,
                        onPressed: () {
                          ref.read(feedNotifierProvider.notifier).removeTop();
                        },
                      ),
                      AccessibleButton(
                        label: 'Like',
                        semanticHint: 'Like this profile',
                        icon: Icons.favorite,
                        onPressed: () {
                          ref.read(feedNotifierProvider.notifier).removeTop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
