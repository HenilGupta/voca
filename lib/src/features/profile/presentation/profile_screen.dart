import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/profile_provider.dart';
import '../../../shared/widgets/accessible_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider(userId: userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, _) => Center(
          child: Text(
            'Failed to load profile',
            semanticsLabel: 'Error loading profile',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile image placeholder
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Semantics(
                    label: profile.imageSemanticLabel,
                    child: const Icon(Icons.person, size: 120),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${profile.name}, ${profile.age}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                profile.bio,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Interests',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.interests
                    .map(
                      (interest) => Chip(
                        label: Text(interest),
                        backgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 32),
              AccessibleButton(
                label: 'Send Message',
                semanticHint: 'Send a message to ${profile.name}',
                icon: Icons.chat_bubble_outline,
                onPressed: () {
                  // TODO: implement messaging
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
