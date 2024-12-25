import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/cart_item.dart';


class CartController {
  static const String baseUrl = 'https://6ma.zapto.org/api';

  // Hàm lấy danh sách giỏ hàng
  static Future<List<CartItem>> getCartItems(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Giả sử API trả về đối tượng chứa trường "cart" là danh sách sản phẩm
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> cartItemsData = data['cart'];  // Truy cập trường "cart"
      return cartItemsData.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải giỏ hàng');
    }
  }
  static Future<void> updateCartItemQuantity(
      String token, String productType, int productId, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/$productType/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể cập nhật số lượng sản phẩm');
    }
  }
  // Hàm thêm sản phẩm vào giỏ hàng
  static Future<void> addToCart(
      String token, String productType, int productId, int quantity, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'product_type': productType,
        'product_id': productId,
        'quantity': quantity,
        'name': name,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Nếu API trả về thành công, không cần ném Exception
      print('Thêm vào giỏ hàng thành công: ${response.body}');
      return;
    } else {
      // Chỉ ném Exception nếu xảy ra lỗi thực sự
      print('Thêm vào giỏ hàng thất bại: ${response.body}');
      throw Exception('Không thể thêm sản phẩm vào giỏ hàng');
    }
  }

  // Hàm xóa sản phẩm khỏi giỏ hàng
  static Future<void> removeFromCart(
      String token, String productType, int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$productType/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 ) {
      throw Exception('Không thể xóa sản phẩm khỏi giỏ hàng');
    }
  }
}
