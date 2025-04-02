// 定义用户数据模型（如用户 ID、邮箱、评分等）

class User {
  final String id;
  final String email;
  final String name;
  final double rating;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.rating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      rating: json['rating'].toDouble(),
    );
  }
}
