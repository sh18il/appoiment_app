import 'dart:convert';

import 'package:appoiment_app/service/core.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  static Dio dio = Dio();

  static Future<String> login(String username, String password) async {
    final response = await dio.post(
      ApiConfig.baseUrl + '/api/Login',
      data: {'username': username, 'password': password},
      options: Options(
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
    );
    if (response.statusCode == 200) {
      final data = response.data is String
          ? json.decode(response.data)
          : response.data;
      if (data['status'] == true) {
        final token = data['token'];
        if (token != null && token is String && token.isNotEmpty) {
          return token;
        } else {
          throw Exception('Login successful, but token not found in response.');
        }
      } else {
        throw Exception(data['message'] ?? 'Invalid username or password.');
      }
    } else {
      throw Exception('Server error: HTTP ${response.statusCode}');
    }
  }
}

class TokenManager {
  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
