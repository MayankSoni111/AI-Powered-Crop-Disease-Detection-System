import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String cropType;
  final String description;
  final String? imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final int commentCount;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.cropType,
    required this.description,
    this.imageUrl,
    required this.timestamp,
    required this.likes,
    this.commentCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'cropType': cropType,
      'description': description,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'commentCount': commentCount,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map, String documentId) {
    return Post(
      id: documentId,
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? 'Unknown Farmer',
      cropType: map['cropType'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: List<String>.from(map['likes'] ?? []),
      commentCount: map['commentCount'] ?? 0,
    );
  }

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? cropType,
    String? description,
    String? imageUrl,
    DateTime? timestamp,
    List<String>? likes,
    int? commentCount,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      cropType: cropType ?? this.cropType,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
