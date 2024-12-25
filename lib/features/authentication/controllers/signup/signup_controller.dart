import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/data/repositories/authentication_repository.dart';
import 'package:sigmatech/features/authentication/screens/login/login.dart';
import 'package:sigmatech/utils/constants/image_strings.dart';
import 'package:sigmatech/utils/helpers/network_manager.dart';
import 'package:sigmatech/utils/popups/full_screen_loader.dart';
import 'package:sigmatech/utils/popups/loaders.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final hidePassword = true.obs;
  final hidePasswordConfirm = true.obs;
  final privacyPolicy = false.obs;
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

  GlobalKey<FormState> signupFormKey = GlobalKey();

  Future<void> signup() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
        'Hệ thống đang xử lý thông tin...', Timages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Lỗi kết nối', message: 'Không có kết nối mạng.');
      }
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Hãy xác nhận điều khoản',
          message: 'Vui lòng xác nhận các điều khoản để tạo tài khoản.',
        );
        return;
      }
      //form validation
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Đăng ký không thành công.',
          message: 'Vui lòng kiểm tra lại thông tin đăng ký.');
        return;
      }

      final registerResponse = await AuthenticationRepository.instance
        .registerUser(
          name.text.trim(),
          email.text.trim(),
          phone.text.trim(),
          password.text.trim(),
          passwordConfirm.text.trim());
      //Privacy policy check
      if (registerResponse == null) {
        TFullScreenLoader.stopLoading();
        return;
      }

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Đăng ký thành công',
        message: 'Tài khoản đã được tạo. Vui lòng đăng nhập!',
      );

      // Chuyển người dùng sang trang Login
      Get.offAll(const LoginScreen());

      //Đăng ký người dùng ở backend Laravel và lưu dữ liệu người dùng
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }
}
