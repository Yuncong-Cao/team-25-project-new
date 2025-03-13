// 封装网络请求工具（如 GET/POST 请求），与后端 API 交互

import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.apiBaseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  static Future<Response> get(String path) => _dio.get(path);
  static Future<Response> post(String path, dynamic data) => _dio.post(path, data: data);
  static Future<Response> put(String path, dynamic data) => _dio.put(path, data: data);
  static Future<Response> delete(String path) => _dio.delete(path);
}