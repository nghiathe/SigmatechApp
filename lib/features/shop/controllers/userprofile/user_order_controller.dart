import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/order.dart';



class UserOrderController extends GetxController {

  static const String baseUrl = "https://6ma.zapto.org/api";

  static Future<Map<String, dynamic>> fetchOrders(String token) async {
    final url = Uri.parse('$baseUrl/account');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load orders');
    }
  }
  static Future<Map<String, dynamic>> fetchOrderDetails(String token, int orderId) async {
    final url = Uri.parse('$baseUrl/account/order/$orderId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order details');
    }
  }

}
