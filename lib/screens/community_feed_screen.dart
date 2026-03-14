import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/community_provider.dart';
import '../widgets/post_card.dart';
import '../l10n/app_localizations.dart';
import 'create_post_screen.dart';
import 'farmer_profile_screen.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FarmerProfileScreen(
                    userId: Provider.of<CommunityProvider>(context, listen: false).currentUserId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CommunityProvider>(
        builder: (context, communityProvider, child) {
          if (communityProvider.error != null) {
            return Center(
              child: Text(
                'Failed to load posts.\n${communityProvider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (communityProvider.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No posts yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to ask a question or share advice!',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // In a real app we might fetch new posts instead
            },
            child: ListView.builder(
              itemCount: communityProvider.posts.length,
              itemBuilder: (context, index) {
                final post = communityProvider.posts[index];
                return PostCard(post: post);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
