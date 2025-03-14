import 'user.dart';

class SwapPost {
  final String id;
  final String title;
  final String description;
  final User owner; // 添加 owner 属性

  SwapPost({
    required this.id,
    required this.title,
    required this.description,
    required this.owner, // 确保 owner 存在
  });

  factory SwapPost.fromJson(Map<String, dynamic> json) {
    return SwapPost(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      owner: User.fromJson(json['owner'] ?? {}), // 确保 owner 不为空
    );
  }
}
