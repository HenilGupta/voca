/// Full user profile model.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.imageUrl,
    required this.imageSemanticLabel,
    this.interests = const [],
  });

  final String id;
  final String name;
  final int age;
  final String bio;
  final String imageUrl;
  final String imageSemanticLabel;
  final List<String> interests;
}
