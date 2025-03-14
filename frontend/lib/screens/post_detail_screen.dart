import 'package:flutter/material.dart';
import '../models/swap_post.dart';

class PostDetailScreen extends StatelessWidget {
  final SwapPost post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    final String authorName = post.owner.name.isNotEmpty ? post.owner.name : 'Unknown';

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Posted by: $authorName', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
