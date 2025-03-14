import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/swap_post.dart';

class SwapPostProvider with ChangeNotifier {
  List<SwapPost> _posts = [];

  List<SwapPost> get posts => _posts;

  Future<void> fetchPosts() async {
    final response = await ApiService.post('/posts', data: {});

    if (response != null && response.statusCode == 200) {
      final responseData = response.data ?? {};
      _posts = (responseData['posts'] as List?)
          ?.map((json) => SwapPost.fromJson(json))
          .toList() ?? [];
      notifyListeners();
    }
  }

  Future<void> createPost(String title, String description, String userId) async {
    final response = await ApiService.post('/create-post', data: {
      'title': title,
      'description': description,
      'user_id': userId,
    });

    if (response != null && response.statusCode == 201) {
      final newPost = SwapPost.fromJson(response.data);
      _posts.add(newPost);
      notifyListeners();
    } else {
      throw Exception('Failed to create post');
    }
  }
}
