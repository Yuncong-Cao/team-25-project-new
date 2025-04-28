// Defines the user data model (such as user ID, email, rating, etc.)

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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'rating': rating,
    };
  }
}
