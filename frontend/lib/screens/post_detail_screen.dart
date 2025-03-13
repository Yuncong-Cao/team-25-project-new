// 帖子详情页，显示单个帖子的详细信息和操作按钮

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/swap_post.dart';
import '../providers/auth_provider.dart';
import '../widgets/rating_bar.dart';

class PostDetailScreen extends StatelessWidget {
  final SwapPost post;

  const PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); 

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            RatingBar(rating: post.rating),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement swap confirmation logic
              },
              child: Text('Confirm Swap'),
            ),
            SizedBox(height: 20),
            // 添加查看作者个人资料的按钮
            ElevatedButton(
              onPressed: () {
                // 从 AuthProvider 中获取作者的用户信息
                final author = authProvider.getUserById(post.authorId);
                if (author != null) {
                  Navigator.pushNamed(
                    context,
                    '/profile',
                    arguments: author,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Author not found')),
                  );
                }
              },
              child: Text('View Author Profile'),
            ),
          ],
        ),
      ),
    );
  }
}