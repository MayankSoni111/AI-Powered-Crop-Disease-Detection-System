import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Add to pubspec if needed for image uploads, but for now we might use a mock URL or just store the path

import '../models/post.dart';
import '../models/comment.dart';
import '../models/user_profile.dart';

class CommunityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Posts ────────────────────────────────────────────────
  Stream<List<Post>> getPostsStream() {
    return _db
        .collection('community_posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> createPost(Post post, {File? imageFile}) async {
    String? imageUrl = post.imageUrl;

    // In a real app with Firebase Storage:
    // if (imageFile != null) {
    //   final ref = FirebaseStorage.instance.ref().child('post_images/${post.id}.jpg');
    //   await ref.putFile(imageFile);
    //   imageUrl = await ref.getDownloadURL();
    // }

    final postToSave = post.copyWith(imageUrl: imageUrl);

    await _db
        .collection('community_posts')
        .doc(post.id)
        .set(postToSave.toMap());
        
    // Update user profile post count
    await _incrementUserPostCount(post.authorId);
  }

  Future<void> toggleLikePost(String postId, String userId) async {
    final docRef = _db.collection('community_posts').doc(postId);
    
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final post = Post.fromMap(snapshot.data()!, snapshot.id);
      List<String> likes = List.from(post.likes);

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      transaction.update(docRef, {'likes': likes});
    });
  }

  // ─── Comments ─────────────────────────────────────────────
  Stream<List<Comment>> getCommentsStream(String postId) {
    return _db
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addComment(Comment comment) async {
    await _db
        .collection('community_posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.id)
        .set(comment.toMap());

    // Increment comment count in post
    final postRef = _db.collection('community_posts').doc(comment.postId);
    await postRef.update({
      'commentCount': FieldValue.increment(1),
    });
  }

  Future<void> toggleHelpfulComment(String postId, String commentId, String userId, String authorId) async {
    final commentRef = _db
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    bool newlyHelpful = false;

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(commentRef);
      if (!snapshot.exists) return;

      final comment = Comment.fromMap(snapshot.data()!, snapshot.id);
      List<String> helpfulVotes = List.from(comment.helpfulVotes);

      if (helpfulVotes.contains(userId)) {
        helpfulVotes.remove(userId);
        newlyHelpful = false;
      } else {
        helpfulVotes.add(userId);
        newlyHelpful = true;
      }

      transaction.update(commentRef, {'helpfulVotes': helpfulVotes});
    });

    if (newlyHelpful) {
      await _incrementUserHelpfulAnswers(authorId);
    } else {
      await _decrementUserHelpfulAnswers(authorId);
    }
  }

  // ─── User Profiles ────────────────────────────────────────
  Future<UserProfile?> getUserProfile(String uid) async {
    final snapshot = await _db.collection('farmer_profiles').doc(uid).get();
    if (snapshot.exists) {
      return UserProfile.fromMap(snapshot.data()!, snapshot.id);
    }
    return null;
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _db.collection('farmer_profiles').doc(profile.uid).set(profile.toMap());
  }

  Future<void> _incrementUserPostCount(String uid) async {
    final ref = _db.collection('farmer_profiles').doc(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.update({'postCount': FieldValue.increment(1)});
    }
  }

  Future<void> _incrementUserHelpfulAnswers(String uid) async {
    final ref = _db.collection('farmer_profiles').doc(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.update({'helpfulAnswers': FieldValue.increment(1)});
    }
  }

  Future<void> _decrementUserHelpfulAnswers(String uid) async {
    final ref = _db.collection('farmer_profiles').doc(uid);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.update({'helpfulAnswers': FieldValue.increment(-1)}); // assuming no less than 0 natively handled or via logic
    }
  }
}
