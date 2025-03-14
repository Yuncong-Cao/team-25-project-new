import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/swap_post_provider.dart';
import '../widgets/swap_post_card.dart';
import '../models/swap_post.dart';

class HomeScreen extends StatelessWidget {
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
      body: Consumer<SwapPostProvider>(
        builder: (context, provider, child) {
          if (provider.posts.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            return ListView.builder(
              itemCount: provider.posts.length,
              itemBuilder: (context, index) {
                final post = provider.posts[index];
                return SwapPostCard(post: post);
              },
            );
          }
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

// 搜索委托类
class PostSearchDelegate extends SearchDelegate<SwapPost?> {
  final SwapPostProvider swapPostProvider;

  PostSearchDelegate(this.swapPostProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = swapPostProvider.posts
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = swapPostProvider.posts
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildSearchResults(results);
  }

  Widget _buildSearchResults(List<SwapPost> results) {
    if (results.isEmpty) {
      return Center(child: Text('No matching posts found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        return SwapPostCard(post: post);
      },
    );
  }
}
