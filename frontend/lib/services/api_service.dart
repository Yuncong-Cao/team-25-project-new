// 封装网络请求工具（如 GET/POST 请求），与后端 API 交互

import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.apiBaseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  static Future<Response> get(String path, {String? token}) async {
    return _dio.get(
      path,
      options: _buildOptions(token),
    );
  }

  static Future<Response> post(
    String path, {
    dynamic data,
    String? token,
  }) async {
    return _dio.post(
      path,
      data: data,
      options: _buildOptions(token),
    );
  }

  // 私有方法：构建请求配置
  static Options _buildOptions(String? token) {
    return Options(headers: {
      if (token != null) 'Authorization': 'Bearer $token',
    });
  }

  static Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);
  static Future<Response> delete(String path) => _dio.delete(path);
}
