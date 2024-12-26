import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';

import 'app.dart';
import 'features/shop/controllers/cart/cart_controller.dart';

Future<void> main() async {
  // Khởi tạo widget binding
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo local storage
  await GetStorage.init();

  Get.put(LaptopService());
  Get.put(CartController());
  // Khởi chạy ứng dụng
  runApp(const MyApp());
}
