// Custom swap post card widget for displaying post summaries in a list

import 'package:flutter/material.dart';
import '../models/swap_post.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class SwapPostCard extends StatelessWidget {
  final SwapPost post;

  const SwapPostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'User ID: ${post.authorId}',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'View Author Profile',
              onPressed: () async {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
                try {
                  // Fetch author profile
                  final response =
                      await ApiService.getUserById(post.authorId);
                  final user = User.fromJson(response.data);
                  Navigator.of(context).pop(); // close loader
                  Navigator.of(context)
                      .pushNamed('/profile', arguments: user);
                } catch (error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to load profile: $error')),
                  );
                }
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/post-detail', arguments: post);
        },
      ),
    );
  }
}
