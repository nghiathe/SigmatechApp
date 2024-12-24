import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/data/repositories/authentication_repository.dart';
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
          'Hệ thống đang xử lý thông tin...', Timages.lightAppLogo);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      //form validation
      if (signupFormKey.currentState!.validate()) {
        final name = this.name.text.trim();
        final email = this.email.text.trim();
        final phone = this.phone.text.trim();
        final password = this.password.text.trim();
        final passwordConfirm = this.passwordConfirm.text.trim();
        await AuthenticationRepository.instance.registerUser(name, email, phone, password, passwordConfirm);
      }

      //Privacy policy check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Hãy xác nhận điều khoản',
          message: 'Vui lòng xác nhận các điều khoản để tạo tài khoản.',
        );
        return;
      }

      //Đăng ký người dùng ở backend Laravel và lưu dữ liệu người dùng
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
}
