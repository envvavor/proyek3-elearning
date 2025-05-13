import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Ganti dengan URL Laravel API Anda
  static const String baseUrl = 'http://10.0.172.157:8000/api';

  // Fungsi untuk mendapatkan token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Fungsi untuk login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Tangkap pesan kesalahan dari respons API
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Login Gagal');
    }
  }

  // Fungsi untuk mengambil data pengguna
  static Future<Map<String, dynamic>> fetchUserData() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  }

  static Future<void> logout() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Cek status code dan body response
      print('Logout Response: ${response.statusCode}');
      print('Logout Body: ${response.body}');

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        print('Token removed from SharedPreferences'); // Log penghapusan token
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to logout');
      }
    } catch (e) {
      print('Error during logout: $e'); // Log error
      throw Exception('Failed to logout: $e');
    }
  }
}