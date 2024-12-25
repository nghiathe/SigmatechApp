import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {

  final _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthToken();
  }

  void _checkAuthToken() {
    final token = GetStorage().read('authToken');
    _isLoggedIn.value = token != null;
  }
}
