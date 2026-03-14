/// A profile model representing a user in the dating app feed.
/// 
/// This model contains essential information displayed on profile cards
/// and includes accessibility-friendly semantic labels for images.
class Profile {
  final String id;
  final String name;
  final int age;
  final String bio;
  final String? imageUrl;
  final String imageSemanticLabel;
  final List<String> interests;

  const Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    this.imageUrl,
    required this.imageSemanticLabel,
    this.interests = const [],
  });

  /// Creates a Profile instance from a JSON map.
  /// 
  /// Handles potential null values and provides default fallbacks
  /// to ensure accessibility compliance.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      age: json['age'] is int ? json['age'] : int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      bio: json['bio']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      imageSemanticLabel: json['imageSemanticLabel']?.toString() ?? 
                         'Photo of ${json['name'] ?? 'person'}',
      interests: json['interests'] is List 
          ? (json['interests'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }

  /// Converts the Profile instance to a JSON map.
  /// 
  /// Useful for API requests and local storage serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'bio': bio,
      'imageUrl': imageUrl,
      'imageSemanticLabel': imageSemanticLabel,
      'interests': interests,
    };
  }

  /// Creates a copy of this Profile with optionally updated values.
  /// 
  /// Useful for state management and creating modified versions
  /// of existing profiles.
  Profile copyWith({
    String? id,
    String? name,
    int? age,
    String? bio,
    String? imageUrl,
    String? imageSemanticLabel,
    List<String>? interests,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      imageSemanticLabel: imageSemanticLabel ?? this.imageSemanticLabel,
      interests: interests ?? this.interests,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile &&
           other.id == id &&
           other.name == name &&
           other.age == age &&
           other.bio == bio &&
           other.imageUrl == imageUrl &&
           other.imageSemanticLabel == imageSemanticLabel &&
           _listEquals(other.interests, interests);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      age,
      bio,
      imageUrl,
      imageSemanticLabel,
      Object.hashAll(interests),
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, age: $age, bio: $bio, imageUrl: $imageUrl, imageSemanticLabel: $imageSemanticLabel, interests: $interests)';
  }

  /// Helper method to compare two lists for equality.
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}