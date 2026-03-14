import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime timestamp;
  final List<String> helpfulVotes;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.timestamp,
    required this.helpfulVotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'helpfulVotes': helpfulVotes,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map, String documentId) {
    return Comment(
      id: documentId,
      postId: map['postId'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? 'Unknown Farmer',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      helpfulVotes: List<String>.from(map['helpfulVotes'] ?? []),
    );
  }
}
