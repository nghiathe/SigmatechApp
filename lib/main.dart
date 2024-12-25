import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

Future<void> main() async {
  // Khởi tạo widget binding
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo local storage
  await GetStorage.init();

  // Khởi chạy ứng dụng
  runApp(const MyApp());
}
