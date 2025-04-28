import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (token != null && userJson != null) {
      _token = token;
      _currentUser = User.fromJson(jsonDecode(userJson));
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> saveUserToPrefs(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user.toJson()));
    _token = token;
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _token = null;
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await ApiService.login(email, password);
      final data = response.data;
      if (data != null && data['token'] != null) {
        await saveUserToPrefs(data['token'], User.fromJson(data['user']));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await ApiService.register(email, password);
      final data = response.data;
      if (data != null && data['token'] != null) {
        await saveUserToPrefs(data['token'], User.fromJson(data['user']));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
