// 自定义的课程交换帖子卡片组件，用于在列表中展示帖子摘要

import 'package:flutter/material.dart';
import '../models/swap_post.dart';

class SwapPostCard extends StatelessWidget {
  final SwapPost post;

  const SwapPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.description),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/post-detail',
            arguments: post,
          );
        },
      ),
    );
  }
}
