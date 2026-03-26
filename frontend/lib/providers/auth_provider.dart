import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../core/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String _error = '';

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await http
          .post(
            Uri.parse('${AppConstants.baseUrl}/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 45));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _user = User.fromJson(data);
        await _saveUserToPrefs(_user!);
        _error = '';
      } else {
        _error = data['message'] ?? 'Login failed';
      }
    } catch (e) {
      _error =
          'Network error occurred. Verify backend and network connection. Details: $e';
    }
    _setLoading(false);
  }

  Future<void> register(
    String name,
    String email,
    String password, {
    String role = 'User',
  }) async {
    _setLoading(true);
    try {
      final response = await http
          .post(
            Uri.parse('${AppConstants.baseUrl}/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'role': role,
            }),
          )
          .timeout(const Duration(seconds: 45));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _user = User.fromJson(data);
        await _saveUserToPrefs(_user!);
        _error = '';
      } else {
        _error = data['message'] ?? 'Registration failed';
      }
    } catch (e) {
      _error =
          'Network error occurred. Verify backend and network connection. Details: $e';
    }
    _setLoading(false);
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(AppConstants.userKey)) {
      return;
    }
    final userData = jsonDecode(prefs.getString(AppConstants.userKey)!);
    _user = User.fromJson(userData);
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userKey);
    notifyListeners();
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(user.toJson());
    await prefs.setString(AppConstants.userKey, userData);
    await prefs.setString(AppConstants.tokenKey, user.token);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
