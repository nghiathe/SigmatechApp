import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/order.dart';
import '../userprofile/user_order_controller.dart';


class OrderController {
  var orders = <Order>[].obs;
  var isLoading = true.obs;

  Future<void> fetchOrders(String token) async {
    try {
      isLoading(true);
      final response = await UserOrderController.fetchOrders(token);

      if (response != null && response['orders'] != null) {
        final List<dynamic> ordersData = response['orders'];
        orders.assignAll(ordersData.map((json) => Order.fromJson(json)).toList());
      } else {
        throw Exception('Invalid response structure');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      isLoading(false);
    }
  }
  static Future<void> fetchProductDetails(String token,List<Map<String, dynamic>> selectedProducts) async {

    // Xây dựng các tham số query từ selectedProducts
    String queryParams = selectedProducts
        .map((item) => 'productType=${item['productType']}&productId=${item['productId']}')
        .join('&');

    // Thêm totalAmount vào query params
    String url = 'https://6ma.zapto.org/api/cart/order?$queryParams';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Dữ liệu trả về: $data');
      } else {
        print('Lỗi khi tải dữ liệu: ${response.statusCode}');
        print('Nội dung lỗi: ${response.body}');
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
    }
  }
}