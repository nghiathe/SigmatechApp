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

}