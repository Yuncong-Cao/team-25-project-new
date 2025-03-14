import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_service.dart';

void main() {
  test('User login API', () async {
    final response = await ApiService.post('/login', data: {
      'email': 'test@example.com', // 确保是 String
      'password': 'password123',
    });

    expect(response?.statusCode, equals(200));
  });

  test('User registration API', () async {
    final response = await ApiService.post('/register', data: {
      'email': 'newuser@example.com', // 确保是 String
      'password': 'securepassword',
    });

    expect(response?.statusCode, equals(201));
  });
}

