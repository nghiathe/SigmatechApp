import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sigmatech/data/repositories/authentication_repository.dart';
import 'package:sigmatech/utils/constants/image_strings.dart';
import 'package:sigmatech/utils/helpers/network_manager.dart';
import 'package:sigmatech/utils/popups/full_screen_loader.dart';
import 'package:sigmatech/utils/popups/loaders.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<void> signin() async {
    try {
      // Mở loading dialog
      TFullScreenLoader.openLoadingDialog(
          'Đang đăng nhập...', Timages.docerAnimation);

      // Kiểm tra kết nối mạng
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Lỗi kết nối', message: 'Không có kết nối mạng.');
        return;
      }

      // Kiểm tra tính hợp lệ của form
      if (loginFormKey.currentState == null || !loginFormKey.currentState!.validate()) {
        await AuthenticationRepository.instance.loginUser(email.text.trim(), password.text.trim());
      }

      // Gọi phương thức loginUser từ AuthenticationRepository
      
  
      // Dừng loading dialog và hiển thị thông báo thành công
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Đăng nhập thành công',
        message: 'Chào mừng bạn đến với Sigmatech!',
      );

      // Điều hướng màn hình sau khi đăng nhập thành công
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {
      // Dừng loading dialog nếu có lỗi
      TFullScreenLoader.stopLoading();

      // Hiển thị thông báo lỗi
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

}
