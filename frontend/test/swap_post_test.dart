// 单元测试课程交换帖子逻辑（如加载帖子、更新帖子状态）

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import '../lib/providers/swap_post_provider.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('SwapPostProvider', () {
    late SwapPostProvider swapPostProvider;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      swapPostProvider = SwapPostProvider();
    });

    test('fetchPosts success', () async {
      when(mockDio.get('/posts')).thenAnswer((_) async => Response(data: [
            {
              'id': '1',
              'title': 'Test Post',
              'description': 'This is a test post.',
              'authorId': '1',
              'createdAt': '2023-10-01T00:00:00Z',
              'rating': 4.0
            }
          ], statusCode: 200, requestOptions: RequestOptions(path: '/posts')));

      await swapPostProvider.fetchPosts();
      expect(swapPostProvider.posts.length, 1);
      expect(swapPostProvider.posts[0].title, 'Test Post');
    });

    test('fetchPosts failure', () async {
      when(mockDio.get('/posts')).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/posts')));

      expect(() async => await swapPostProvider.fetchPosts(), throwsException);
    });
  });
}
