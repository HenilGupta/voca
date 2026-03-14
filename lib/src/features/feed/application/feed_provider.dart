import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/feed_profile.dart';

part 'feed_provider.g.dart';

@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  List<FeedProfile> build() {
    // Seed data – replace with API call.
    return const [
      FeedProfile(
        id: '1',
        name: 'Sarah',
        age: 24,
        bio: 'Loves hiking and coffee ☕',
        imageUrl: 'assets/images/placeholder.png',
        imageSemanticLabel: 'Photo of Sarah, smiling in a park',
      ),
      FeedProfile(
        id: '2',
        name: 'Alex',
        age: 27,
        bio: 'Musician and dog lover 🎸',
        imageUrl: 'assets/images/placeholder.png',
        imageSemanticLabel: 'Photo of Alex, playing guitar outdoors',
      ),
    ];
  }

  void removeTop() {
    if (state.isNotEmpty) {
      state = [...state.sublist(1)];
    }
  }
}
