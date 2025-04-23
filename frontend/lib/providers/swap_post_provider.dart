// 管理课程交换帖子的数据（如加载帖子列表、更新帖子状态等）

import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/swap_post.dart';

class SwapPostProvider with ChangeNotifier {
  List<SwapPost> _posts = [];
  List<SwapPost> _filteredPosts = [];
  bool _isLoading = false;

  List<SwapPost> get posts => _filteredPosts.isEmpty ? _posts : _filteredPosts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts(String token) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/posts', token: token);
      _posts = (response.data as List)
          .map((post) => SwapPost.fromJson(post))
          .toList();
      _filteredPosts = [];
    } catch (error) {
      _posts = [];
      _filteredPosts = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(
    String title,
    String description,
    String token,
  ) async {
    try {
      final response = await ApiService.post(
        '/posts',
        data: {
          'title': title,
          'description': description,
        },
        token: token,
      );
      _posts.add(SwapPost.fromJson(response.data));
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to create posts');
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
