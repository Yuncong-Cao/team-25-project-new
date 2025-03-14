import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_service.dart';

void main() {
  test('Fetch posts API', () async {
    final response = await ApiService.post('/posts', data: {
      'category': 'math', // 确保是 String
    });

    expect(response?.statusCode, equals(200));
  });

  test('Create post API', () async {
    final response = await ApiService.post('/create-post', data: {
      'title': 'Swap Calculus Class', // 确保是 String
      'description': 'Looking to swap my calculus class for statistics.',
    });

    expect(response?.statusCode, equals(201));
  });
}
