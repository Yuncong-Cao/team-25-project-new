// 管理用户认证状态（如登录、注册、Token 存储等）

import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  User? _currentUser;
  List<User> _users = [];

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  User? get currentUser => _currentUser;

  User? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.post('/login', data: {
        'email': email,
        'password': password,
      });
      _token = response.data['token'];
      print('Login success, _token value: $_token');
      _isAuthenticated = true;
      _currentUser = User.fromJson(response.data['user']);
      _users.add(_currentUser!);
      notifyListeners();
    } catch (error) {
      _isAuthenticated = false;
      throw Exception('Login failed');
    }
  }

  Future<void> register(String email, String password) async {
    try {
      print('Sending registration request with email: $email and password: $password');
      final response = await ApiService.post('/register', data: {
        'email': email,
        'password': password,
      });
      print('Registration response: ${response.data}');
      _token = response.data['token'];
      print('Register success, _token value: $_token');
      _isAuthenticated = true;
      _currentUser = User.fromJson(response.data['user']);
      _users.add(_currentUser!);
      notifyListeners();
    } catch (error) {
      print('Registration error: $error');
      _isAuthenticated = false;
      throw Exception('Registration failed');
    }
  }
}
