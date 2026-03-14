import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user_profile.dart';

final userProfileProvider = FutureProvider.family<UserProfile, String>((ref, userId) async {
  // Simulate network fetch – replace with real API call.
  await Future.delayed(const Duration(milliseconds: 300));

  return UserProfile(
    id: userId,
    name: 'Sarah',
    age: 24,
    bio: 'Loves hiking, coffee, and meaningful conversations.',
    imageUrl: 'assets/images/placeholder.png',
    imageSemanticLabel: 'Photo of Sarah, smiling in a park',
    interests: ['Hiking', 'Coffee', 'Reading'],
  );
});
