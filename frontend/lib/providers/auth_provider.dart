import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  User? get currentUser => _currentUser;

  /// 用户登录
  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response != null && response.statusCode == 200) {
        _token = response.data['token'];
        _isAuthenticated = true;
        _currentUser = User.fromJson(response.data['user']);
        notifyListeners();
      } else {
        throw Exception('登录失败: ${response?.statusMessage}');
      }
    } catch (error) {
      _isAuthenticated = false;
      notifyListeners();
      throw Exception('发生错误: $error');
    }
  }

  /// 用户注册
  Future<void> register(String email, String password) async {
    try {
      final response = await ApiService.post('/register', data: {
        'email': email,
        'password': password,
      });

      if (response != null && response.statusCode == 200) {
        _token = response.data['token'];
        _isAuthenticated = true;
        _currentUser = User.fromJson(response.data['user']);
        notifyListeners();
      } else {
        throw Exception('注册失败: ${response?.statusMessage}');
      }
    } catch (error) {
      _isAuthenticated = false;
      notifyListeners();
      throw Exception('发生错误: $error');
    }
  }

  /// 用户登出
  void logout() {
    _token = null;
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
