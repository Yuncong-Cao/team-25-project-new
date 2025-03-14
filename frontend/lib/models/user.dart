class User {
  final String id;
  final String name;
  final String email;
  final double rating;

  User({required this.id, required this.name, required this.email, required this.rating});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  /// 添加 `empty()` 方法，防止 `null` 访问错误
  static User empty() => User(id: '', name: 'Unknown', email: '', rating: 0.0);
}
