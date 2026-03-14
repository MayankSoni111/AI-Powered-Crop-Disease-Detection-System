import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';
import '../models/comment.dart';
import '../models/user_profile.dart';
import '../services/community_service.dart';

class CommunityProvider with ChangeNotifier {
  final CommunityService _communityService = CommunityService();

  // Current User Context (Mocked for now since auth might not be fully wired)
  String _currentUserId = 'user_123';
  String _currentUserName = 'Farmer John';
  
  String get currentUserId => _currentUserId;
  String get currentUserName => _currentUserName;

  void setCurrentUser(String id, String name) {
    _currentUserId = id;
    _currentUserName = name;
    notifyListeners();
  }

  // State
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CommunityProvider() {
    _listenToPosts();
  }

  void _listenToPosts() {
    _communityService.getPostsStream().listen(
      (posts) {
        _posts = posts;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> fetchPostsLocallyForDemo() async {
    // If no firebase, populate mock
  }

  Future<void> createPost({
    required String cropType,
    required String description,
    File? imageFile,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final post = Post(
        id: const Uuid().v4(),
        authorId: _currentUserId,
        authorName: _currentUserName,
        cropType: cropType,
        description: description,
        timestamp: DateTime.now(),
        likes: [],
      );

      await _communityService.createPost(post, imageFile: imageFile);
      _error = null;
    } catch (e) {
      _error = 'Failed to create post: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId) async {
    try {
      await _communityService.toggleLikePost(postId, _currentUserId);
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  Stream<List<Comment>> getComments(String postId) {
    return _communityService.getCommentsStream(postId);
  }

  Future<void> addComment(String postId, String text) async {
    try {
      final comment = Comment(
        id: const Uuid().v4(),
        postId: postId,
        authorId: _currentUserId,
        authorName: _currentUserName,
        text: text,
        timestamp: DateTime.now(),
        helpfulVotes: [],
      );
      await _communityService.addComment(comment);
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }

  Future<void> toggleHelpfulComment(String postId, String commentId, String authorId) async {
    try {
      await _communityService.toggleHelpfulComment(postId, commentId, _currentUserId, authorId);
    } catch (e) {
      debugPrint('Error voting comment helpful: $e');
    }
  }

  Future<UserProfile?> getUserProfile(String uid) {
    return _communityService.getUserProfile(uid);
  }
}
