import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Tự động chọn đúng URL theo nền tảng:
  // - Android Emulator: 10.0.2.2
  // - Windows/Desktop/Web: localhost
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:5263/api';
    }
    return 'http://localhost:5263/api';
  }

  static const Duration _timeout = Duration(seconds: 10);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool authenticated = false,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (authenticated) {
      String? token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return await http
        .post(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers,
          body: jsonEncode(data),
        )
        .timeout(_timeout);
  }

  Future<http.Response> get(String endpoint) async {
    String? token = await getToken();
    return await http
        .get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token ?? ''}',
          },
        )
        .timeout(_timeout);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    return await http
        .put(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token ?? ''}',
          },
          body: jsonEncode(data),
        )
        .timeout(_timeout);
  }

  Future<http.Response> delete(String endpoint) async {
    String? token = await getToken();
    return await http
        .delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token ?? ''}',
          },
        )
        .timeout(_timeout);
  }
}
