import 'dart:convert';
import 'package:http/http.dart' as http;

class CartRepository {
  static const String baseUrl = "https://your-laravel-backend.com/api";

  // Lấy token từ local storage
  static Future<String?> getToken() async {
    // Dùng flutter_secure_storage hoặc shared_preferences
    return "YOUR_TOKEN"; // Thay bằng logic lấy token
  }

  // Gửi yêu cầu GET
  static Future<http.Response> get(String endpoint) async {
    String? token = await getToken();
    return http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
  }

  // Gửi yêu cầu POST
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    return http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: json.encode(data),
    );
  }

  // Gửi yêu cầu PATCH
  static Future<http.Response> patch(String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    return http.patch(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: json.encode(data),
    );
  }

  // Gửi yêu cầu DELETE
  static Future<http.Response> delete(String endpoint) async {
    String? token = await getToken();
    return http.delete(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
  }
}
