import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/comment.dart';
import '../providers/community_provider.dart';
import '../screens/farmer_profile_screen.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final String postAuthorId;

  const CommentTile({
    super.key,
    required this.comment,
    required this.postAuthorId,
  });

  @override
  Widget build(BuildContext context) {
    final communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    final currentUserId = communityProvider.currentUserId;
    final isHelpful = comment.helpfulVotes.contains(currentUserId);
    final theme = Theme.of(context);

    // Only allow marking as helpful if the current user is the post author,
    // or allow anyone (as a simple like). Here, let's treat it as a general "Helpful" vote.
    // In some systems, only the OP can mark it "Accepted". 
    // We will let anyone upvote it as helpful for now.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FarmerProfileScreen(userId: comment.authorId),
                ),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.tertiaryContainer,
              child: Text(
                comment.authorName.isNotEmpty ? comment.authorName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              comment.authorName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (comment.authorId == postAuthorId)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('OP', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(comment.text, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: Row(
                    children: [
                      Text(
                        DateFormat.yMMMd().add_jm().format(comment.timestamp),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          communityProvider.toggleHelpfulComment(
                            comment.postId,
                            comment.id,
                            comment.authorId,
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              isHelpful ? Icons.star : Icons.star_border,
                              size: 16,
                              color: isHelpful ? Colors.orange : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Helpful (${comment.helpfulVotes.length})',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isHelpful ? FontWeight.bold : FontWeight.normal,
                                color: isHelpful ? Colors.orange : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
