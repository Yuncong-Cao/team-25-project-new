// 管理课程交换帖子的数据（如加载帖子列表、更新帖子状态等）

import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/swap_post.dart';

class SwapPostProvider with ChangeNotifier {
  List<SwapPost> _posts = [];
  List<SwapPost> _filteredPosts = []; // 用于存储筛选后的帖子

  List<SwapPost> get posts => _filteredPosts.isEmpty ? _posts : _filteredPosts;

  Future<void> fetchPosts() async {
    try {
      final response = await ApiService.get('/posts');
      _posts = (response.data as List)
          .map((post) => SwapPost.fromJson(post))
          .toList();
      _filteredPosts = []; // 初始化筛选列表
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> createPost(String title, String description) async {
    try {
      final response = await ApiService.post('/posts', data: {
        'title': title,
        'description': description,
      });
      final newPost = SwapPost.fromJson(response.data);
      _posts.add(newPost);
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to create post');
    }
  }

  void searchPosts(String query) {
    if (query.isEmpty) {
      _filteredPosts = []; // 如果查询为空，显示所有帖子
    } else {
      _filteredPosts = _posts.where((post) {
        return post.title.toLowerCase().contains(query.toLowerCase()) ||
            post.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
