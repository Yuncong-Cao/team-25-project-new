import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8000',
    connectTimeout: const Duration(seconds: 10), // 修正
    receiveTimeout: const Duration(seconds: 10), // 修正
  ));

  static Future<Response?> post(String path, {required Map<String, dynamic> data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (error) {
      print('API 请求错误: $error');
      return null;
    }
  }
}
