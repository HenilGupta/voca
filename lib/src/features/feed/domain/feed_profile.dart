/// A profile card model as shown in the feed.
class FeedProfile {
  const FeedProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.imageUrl,
    required this.imageSemanticLabel,
  });

  final String id;
  final String name;
  final int age;
  final String bio;
  final String imageUrl;

  /// Descriptive label for screen readers (e.g. "Photo of Sarah, smiling in a park").
  final String imageSemanticLabel;
}
