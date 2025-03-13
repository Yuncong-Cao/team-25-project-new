// 单元测试用户认证逻辑（如登录、注册功能）

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import '../lib/providers/auth_provider.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('AuthProvider', () {
    late AuthProvider authProvider;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      authProvider = AuthProvider();
    });

    test('login success', () async {
      when(mockDio.post(any, data: anyNamed('data')))
        .thenAnswer((_) async => Response(data: {'token': 'test-token'}, statusCode: 200));

      await authProvider.login('test@example.com', 'password');
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.token, 'test-token');
    });

    test('login failure', () async {
      when(mockDio.post(any, data: anyNamed('data')))
        .thenThrow(DioError(requestOptions: RequestOptions(path: '')));

      expect(() async => await authProvider.login('test@example.com', 'password'), throwsException);
    });
  });
}