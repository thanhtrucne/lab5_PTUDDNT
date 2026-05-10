import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userName;
  String? _userEmail;
  final ApiService _apiService = ApiService();

  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    _userName = prefs.getString('user_name');
    _userEmail = prefs.getString('user_email');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.post('/Auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userName = data['fullName'];
        _userEmail = data['email'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
        await prefs.setString('user_name', _userName!);
        await prefs.setString('user_email', _userEmail!);

        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> register(String email, String password, String fullName) async {
    try {
      final response = await _apiService.post('/Auth/register', {
        'email': email,
        'password': password,
        'fullName': fullName,
      });
      return response.statusCode == 200;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _userName = null;
    _userEmail = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
