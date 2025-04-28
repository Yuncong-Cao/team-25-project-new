// 用户个人资料页，显示用户信息和评分，并允许修改用户名和密码

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/swap_post.dart';
import '../providers/swap_post_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/rating_bar.dart';
import '../widgets/swap_post_card.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  Future<void> _showEditDialog(BuildContext context, User user) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final nameController = TextEditingController(text: user.name);
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? errorMsg;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Edit Profile'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Username cannot be empty' : null,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                    ),
                    if (errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(errorMsg!, style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setStateDialog(() => isLoading = true);
                          try {
                            final response = await ApiService.updateUserProfile(
                              user.id,
                              name: nameController.text,
                              password: passwordController.text.isNotEmpty
                                  ? passwordController.text
                                  : null,
                              token: authProvider.token!,
                            );
                            final updatedUser = User.fromJson(response.data);
                            if (authProvider.currentUser?.id == updatedUser.id) {
                              await authProvider.saveUserToPrefs(
                                  authProvider.token!, updatedUser);
                            }
                            setState(() {});
                            Navigator.of(context).pop();
                          } catch (e) {
                            setStateDialog(() {
                              errorMsg = 'Update failed: ${e.toString()}';
                            });
                          } finally {
                            setStateDialog(() => isLoading = false);
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final swapPostProvider = Provider.of<SwapPostProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isSelf = authProvider.currentUser?.id == widget.user.id;
    final user = isSelf ? authProvider.currentUser! : widget.user;
    final userPosts =
        swapPostProvider.posts.where((post) => post.authorId == user.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoSection(context, isSelf, user),
            SizedBox(height: 24),
            _buildUserPostsSection(context, userPosts, user),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(
      BuildContext context, bool isSelf, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                user.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (isSelf)
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Edit Profile',
                onPressed: () => _showEditDialog(context, user),
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Rating: ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            RatingBar(initialRating: user.rating, isReadOnly: true),
          ],
        ),
        Divider(height: 32),
      ],
    );
  }

  Widget _buildUserPostsSection(
      BuildContext context, List<SwapPost> posts, User user) {
    final sortedPosts =
        [...posts]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Posts by ${user.name} (${sortedPosts.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        if (sortedPosts.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No posts yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
          )
        else
          ...sortedPosts.map((post) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SwapPostCard(post: post),
              )),
      ],
    );
  }
}
