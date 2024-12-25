import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sigmatech/features/authentication/controllers/auth_controller.dart';
import 'package:sigmatech/features/authentication/screens/login/login.dart';
import 'package:sigmatech/features/authentication/screens/onboarding/onboarding.dart';
import 'package:sigmatech/navigation_menu.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = Get.find<AuthController>();
      if (authController.isLoggedIn) {
        return const NavigationMenu(); // Điều hướng đến màn hình chính
      } else {
        final isFirstTime = GetStorage().read('IsFirstTime') ?? true;
        return isFirstTime ? const OnboardingScreen() : const LoginScreen();
      }
    });
  }
}
