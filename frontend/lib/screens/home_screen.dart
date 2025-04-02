// 首页，展示 AI 推荐的课程交换帖子列表

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/swap_post_provider.dart';
import '../widgets/swap_post_card.dart';

class HomeScreen extends StatelessWidget {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final swapPostProvider = Provider.of<SwapPostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('CourseSwap'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(swapPostProvider),
              );
            },
          ),
        ],
      ),
      body: swapPostProvider.posts.isEmpty
          ? Center(child: Text('No posts available'))
          : ListView.builder(
              itemCount: swapPostProvider.posts.length,
              itemBuilder: (context, index) {
                final post = swapPostProvider.posts[index];
                return SwapPostCard(post: post);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-post');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// 实现搜索委托
class PostSearchDelegate extends SearchDelegate<String> {
  final SwapPostProvider swapPostProvider;

  PostSearchDelegate(this.swapPostProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    swapPostProvider.searchPosts(query);
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    swapPostProvider.searchPosts(query);
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: swapPostProvider.posts.length,
      itemBuilder: (context, index) {
        final post = swapPostProvider.posts[index];
        return SwapPostCard(post: post);
      },
    );
  }
}
