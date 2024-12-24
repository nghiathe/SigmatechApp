import 'package:get/get.dart';
import 'package:sigmatech/data/repositories/authentication_repository.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(AuthenticationRepository());
  }
}
