class UserProfile {
  final String uid;
  final String name;
  final String? location;
  final List<String> cropsGrown;
  final int postCount;
  final int helpfulAnswers;

  UserProfile({
    required this.uid,
    required this.name,
    this.location,
    required this.cropsGrown,
    this.postCount = 0,
    this.helpfulAnswers = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'location': location,
      'cropsGrown': cropsGrown,
      'postCount': postCount,
      'helpfulAnswers': helpfulAnswers,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return UserProfile(
      uid: documentId,
      name: map['name'] ?? 'Unknown Farmer',
      location: map['location'],
      cropsGrown: List<String>.from(map['cropsGrown'] ?? []),
      postCount: map['postCount'] ?? 0,
      helpfulAnswers: map['helpfulAnswers'] ?? 0,
    );
  }
}
