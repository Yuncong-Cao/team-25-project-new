// Post detail page, displays detailed information and action buttons for a single post

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/swap_post.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
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
            RatingBar(
              initialRating: post.rating,
              isReadOnly: false,
              onRatingSelected: (rating) async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final token = authProvider.token;
                if (token != null) {
                  try {
                    await ApiService.postRating(post.id, rating, token);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rating submitted!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to submit rating')),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement swap confirmation logic
              },
              child: Text('Confirm Swap'),
            ),
            SizedBox(height: 20),
            // 所有人都可以查看帖主的个人资料
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );
                  try {
                    final response = await ApiService.getUserById(post.authorId);
                    final user = User.fromJson(response.data);
                    Navigator.of(context).pop(); // close loader
                    Navigator.pushNamed(
                      context,
                      '/profile',
                      arguments: user,
                    );
                  } catch (error) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to load author profile: $error')),
                    );
                  }
                },
                child: const Text('View Author Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
