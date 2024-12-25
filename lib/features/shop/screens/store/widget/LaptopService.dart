import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sigmatech/utils/popups/loaders.dart';

class LaptopService extends GetxController {
  static LaptopService get instance => Get.find();

  final String baseUrl = 'https://6ma.zapto.org/api'; // Thay bằng domain của bạn
  final deviceStorage = GetStorage();

  final RxList<dynamic> _laptops = <dynamic>[].obs; // Lưu danh sách laptops
  RxBool isLoading = false.obs;

  List<dynamic> get laptops => _laptops;

  @override
  void onInit() {
    super.onInit();
    fetchLaptops();
  }

  /// Lấy danh sách tất cả laptops
  Future<void> fetchLaptops() async {
    final String? token = deviceStorage.read('authToken'); // Lấy token từ storage

    if (token == null) {
      TLoaders.errorSnackBar(
        title: 'Lỗi xảy ra.',
        message: 'Bạn chưa đăng nhập. Vui lòng đăng nhập trước.',
      );
      return;
    }

    isLoading.value = true; // Bật trạng thái loading

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/laptops'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _laptops.value = data['data']; // Cập nhật danh sách laptops
      } else {
        TLoaders.errorSnackBar(
          title: 'Lỗi xảy ra.',
          message: 'Không thể lấy danh sách laptops.',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi xảy ra.',
        message: 'Không thể kết nối tới server. Vui lòng thử lại.',
      );
    } finally {
      isLoading.value = false; // Tắt trạng thái loading
    }
  }

  /// Lấy chi tiết một laptop
  Future<Map<String, dynamic>?> fetchLaptopDetail(int id) async {
    final String? token = deviceStorage.read('authToken');

    if (token == null) {
      TLoaders.errorSnackBar(
        title: 'Lỗi xảy ra.',
        message: 'Bạn chưa đăng nhập. Vui lòng đăng nhập trước.',
      );
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/laptops/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        TLoaders.errorSnackBar(
          title: 'Lỗi xảy ra.',
          message: 'Không thể lấy thông tin laptop.',
        );
        return null;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi xảy ra.',
        message: 'Không thể kết nối tới server. Vui lòng thử lại.',
      );
      return null;
    }
  }
}
