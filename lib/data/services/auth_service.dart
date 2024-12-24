import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://6ma.zapto.org/api';

  Future<Map<String, dynamic>?> get currentUser async {

    final deviceStorage = GetStorage();
    final String? token = deviceStorage.read('authToken');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('https://6ma.zapto.org/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Nếu yêu cầu thành công, trả về thông tin người dùng
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
        print('Error fetching user info: $e');
      return null;
    }
  }

  /// Gửi yêu cầu đăng ký đến API
  Future<Map<String, dynamic>> register(String name, String email, String phone, String password, String passwordConfirm) async {
    try {
      final Map<String, dynamic> payload = {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirm,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Kiểm tra nếu đăng ký thành công
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Đăng ký thất bại, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi đăng ký: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final Map<String, dynamic> payload = {
        'email': email,
        'password': password
      };

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Kiểm tra nếu đăng ký thành công
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Đăng ký thất bại, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi đăng ký: $e');
    }
  }
}
