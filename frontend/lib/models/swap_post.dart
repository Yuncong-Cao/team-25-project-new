// 定义课程交换帖子模型（如帖子 ID、标题、描述、作者 ID 等）

class SwapPost {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final DateTime createdAt;
  final double rating;

  SwapPost({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.createdAt,
    required this.rating,
  });

  factory SwapPost.fromJson(Map<String, dynamic> json) {
    return SwapPost(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      authorId: json['authorId'],
      createdAt: DateTime.parse(json['createdAt']),
      rating: json['rating'].toDouble(),
    );
  }
}
