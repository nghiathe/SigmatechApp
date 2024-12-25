import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sigmatech/utils/popups/loaders.dart';

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
        Uri.parse('$baseUrl/user'),
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
      return null;
    }
  }

  /// Gửi yêu cầu đăng ký đến API
  Future<Map<String, dynamic>?> register(String name, String email,
      String phone, String password, String passwordConfirm) async {
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
        TLoaders.errorSnackBar(
          title: 'Lỗi đăng ký',
          message: 'Xảy ra lỗi trong quá trình đăng ký.',
        );
        return null;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi đăng nhập',
        message: 'Xảy ra lỗi trong quá trình đăng ký.',
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final Map<String, dynamic> payload = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Nếu đăng nhập thành công (status code 200 hoặc 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        // Hiển thị thông báo lỗi nếu đăng nhập không thành công
        TLoaders.errorSnackBar(
          title: 'Lỗi đăng nhập',
          message: 'Email hoặc mật khẩu không đúng.',
        );
        return null; // Trả về null để thông báo lỗi
      }
    } catch (e) {
      // Hiển thị thông báo lỗi nếu có lỗi không mong muốn xảy ra
      TLoaders.errorSnackBar(
        title: 'Lỗi đăng nhập',
        message: 'Đã xảy ra lỗi trong quá trình đăng nhập.',
      );
      return null; // Trả về null trong trường hợp lỗi
    }
  }
}
