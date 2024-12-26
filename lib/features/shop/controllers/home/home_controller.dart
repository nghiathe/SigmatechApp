import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sigmatech/features/shop/models/user.dart';
import 'dart:convert';

import 'package:sigmatech/utils/popups/loaders.dart';


class HomeController extends GetxController {

  static HomeController get instance => Get.find();
  final Rx<User?> _user = Rx<User?>(null);
  final String baseUrl = 'https://6ma.zapto.org/api';
  final deviceStorage = GetStorage();

  User? get user => _user.value;

  String get userName {
    return _user.value?.name ?? 'Chưa cập nhật địa chỉ';
  }
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {

    final String? token = deviceStorage.read('authToken');

    if (token == null) {
      return;
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
        final data = jsonDecode(response.body);
        _user.value = User.fromJson(data);
      } else {
        TLoaders.errorSnackBar(
          title: 'Lỗi xảy ra.', message: 'Không lấy được dữ liệu người dùng.');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi xảy ra.', message: 'Không lấy được dữ liệu người dùng.');
    }
  }
}
