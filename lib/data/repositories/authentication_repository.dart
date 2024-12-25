import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sigmatech/features/authentication/screens/login/login.dart';
import 'package:sigmatech/features/authentication/screens/onboarding/onboarding.dart';
import 'package:sigmatech/data/services/auth_service.dart';
import 'package:sigmatech/navigation_menu.dart';
import 'package:sigmatech/utils/popups/loaders.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final AuthService _authService = AuthService(); // Khởi tạo AuthService
  final deviceStorage = GetStorage();

  @override
  void onReady() {
    super.onReady();
    screenRedirect();
  }

  /// Điều hướng người dùng khi khởi động ứng dụng
  screenRedirect() async {
    final user = await _authService.currentUser;
    if (user != null) {
      Get.offAll(() => const NavigationMenu());
    } else {
      deviceStorage.writeIfNull('IsFirstTime', true);
      if (deviceStorage.read('IsFirstTime') != true) {
        Get.offAll(() => const LoginScreen());
      } else {
        Get.offAll(() => const OnboardingScreen());
      }
    }
  }

  /// Xử lý logic đăng ký người dùng
  Future<Map<String, dynamic>?> registerUser(String name, String email, String phone, String password, String passwordConfirm) async {
    final response = await _authService.register(
        name, email, phone, password, passwordConfirm);

    if (response == null) return null;
    // Lưu token vào local storage
    if (response.containsKey('token')) {
      deviceStorage.write('authToken', response['token']);
    }
    return response;
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final response = await _authService.login(email, password);

    if (response == null) return null;

    if (response.containsKey('token')) {
      // Lưu token vào local storage nếu có
      deviceStorage.write('authToken', response['token']);
    } 
    // Trả về response
    return response;
  }
}
