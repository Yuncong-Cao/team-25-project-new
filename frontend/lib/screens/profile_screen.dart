// 用户个人资料页，显示用户信息和评分

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/swap_post.dart';
import '../providers/swap_post_provider.dart';
import '../widgets/rating_bar.dart';
import '../widgets/swap_post_card.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final swapPostProvider = Provider.of<SwapPostProvider>(context);
    final userPosts = swapPostProvider.posts.where((post) => post.authorId == user.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户基本信息部分
            _buildUserInfoSection(context),
            SizedBox(height: 24),
            
            // 用户帖子历史部分
            _buildUserPostsSection(context, userPosts),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 8),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Rating: ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            RatingBar(rating: user.rating),
          ],
        ),
        Divider(height: 32),
      ],
    );
  }

  Widget _buildUserPostsSection(BuildContext context, List<SwapPost> posts) {
    // 新增排序逻辑：按创建时间降序排列（最新帖子在前）
    final sortedPosts = [...posts]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Posts (${sortedPosts.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        
        if (sortedPosts.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No posts yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
          )
        else
          ...sortedPosts.map((post) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SwapPostCard(post: post),
              )),
      ],
    );
  }
}
