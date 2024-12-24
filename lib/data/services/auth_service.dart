import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://6ma.zapto.org/api';

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
}
