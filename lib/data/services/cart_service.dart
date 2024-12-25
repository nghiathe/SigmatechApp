import 'dart:convert';

import '../repositories/cart_repository.dart';


class CartService {
  // Lấy giỏ hàng
  static Future<List<dynamic>> getCart() async {
    final response = await CartRepository.get("cart");
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception("Failed to fetch cart");
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  static Future<void> addToCart(String productType, int productId, int quantity) async {
    final response = await CartRepository.post("cart/add", {
      "product_type": productType,
      "product_id": productId,
      "quantity": quantity,
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to add to cart");
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  static Future<void> removeFromCart(String productType, int productId) async {
    final response = await CartRepository.delete("cart/$productType/$productId");
    if (response.statusCode != 200) {
      throw Exception("Failed to remove from cart");
    }
  }

  // Cập nhật số lượng sản phẩm
  static Future<void> updateQuantity(String productType, int productId, int quantity) async {
    final response = await CartRepository.patch("cart/$productType/$productId", {
      "quantity": quantity,
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to update quantity");
    }
  }
}

