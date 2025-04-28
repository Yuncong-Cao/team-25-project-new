 // Encapsulates network request utilities (such as GET/POST requests) and interacts with the backend API

import 'package:dio/dio.dart' show Dio, Response, Options, BaseOptions;
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

  // Private method: Build request options
  static Options _buildOptions(String? token) {
    return Options(headers: {
      if (token != null) 'Authorization': 'Bearer $token',
    });
  }

  static Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);
// Get user information (public)
  static Future<Response> getUserById(String userId) async {
    return get('/users/$userId');
  }
  static Future<Response> delete(String path) => _dio.delete(path);

  // Submit rating
  static Future<Response> postRating(String postId, int rating, String token) async {
    return post('/posts/$postId/rating', data: { 'rating': rating }, token: token);
  }
// PATCH method

 static Future<Response> login(String email, String password) async {
   return post('/login', data: {'email': email, 'password': password});
 }

 static Future<Response> register(String email, String password) async {
   return post('/register', data: {'email': email, 'password': password});
 }
  static Future<Response> patch(
    String path, {
    dynamic data,
    String? token,
  }) async {
    return _dio.patch(
      path,
      data: data,
      options: _buildOptions(token),
    );
  }

  // Update user information
  static Future<Response> updateUserProfile(
    String userId, {
    String? name,
    String? password,
    required String token,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (password != null) data['password'] = password;
    return patch('/users/$userId', data: data, token: token);
  }
}
