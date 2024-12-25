import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sigmatech/features/authentication/screens/login/login.dart';
import 'package:sigmatech/features/shop/models/user.dart';
import 'dart:convert';

import 'package:sigmatech/utils/popups/loaders.dart';


class UserProfileController extends GetxController {

  static UserProfileController get instance => Get.find();
  final Rx<User?> _user = Rx<User?>(null);
  final String baseUrl = 'https://6ma.zapto.org/api';
  final deviceStorage = GetStorage();

  User? get user => _user.value;

  String get userAddress {
    return _user.value?.address ?? 'Chưa cập nhật địa chỉ';
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

  Future<void> logoutUser() async {
    try {
      await deviceStorage.remove('authToken');
      await deviceStorage.write('isLoggedIn', false);

      _user.value = null;
      TLoaders.successSnackBar(
        title: 'Đăng xuất thành công.',
        message: 'Bạn đã đăng xuất khỏi thiết bị này.',
      );
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi xảy ra.',
        message: 'Không thể đăng xuất. Vui lòng thử lại sau.',
      );
    }
  }
  void isDarkMode(bool value) {
    deviceStorage.write('isDarkMode', value);
  }
}
