import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/cart_item.dart';


class CartController extends GetxController {
  static final deviceStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    updateCartCountFromLocalStorage();  // Gọi hàm cập nhật số lượng giỏ hàng khi controller khởi tạo
  }
  static Future<void> addToCartLocal(
      int productId,
      String productType,
      int quantity,
      String name,
      int price,
      String imageUrl) async {
    try {
      // Đọc dữ liệu giỏ hàng hiện tại từ GetStorage
      final String? cartData = deviceStorage.read('cart');
      List<CartItem> cartItems = [];
      if (cartData != null) {
        final List<dynamic> jsonList = json.decode(cartData);
        cartItems = jsonList.map((item) => CartItem.fromJson(item)).toList();
      }
      bool isProductExist = false;
      for (var item in cartItems) {
        if (item.productId == productId && item.productType == productType) {
          // Nếu sản phẩm đã tồn tại, tăng số lượng
          item.quantity += quantity;
          isProductExist = true;
          break;
        }
      }
      if (!isProductExist) {
        cartItems.add(CartItem(
          productId: productId,
          productType: productType,
          quantity: quantity,
          name: name,
          price: price,
          imageUrl: imageUrl,
        ));
      }
      await saveCartItemsToStorage(cartItems);
    } catch (e) {
      print('Lỗi khi thêm vào giỏ hàng: $e');
    }
  }

  // Lưu giỏ hàng vào GetStorage
  static Future<void> saveCartItemsToStorage(List<CartItem> cartItems) async {
    try {
      // Chuyển List<CartItem> thành List<Map<String, dynamic>> rồi mã hóa thành JSON
      final List<Map<String, dynamic>> cartItemsJson = cartItems.map((item) => item.toJson()).toList();
      await deviceStorage.write('cart', json.encode(cartItemsJson));
    } catch (e) {
      print('Lỗi khi lưu giỏ hàng vào storage: $e');
    }
  }
  RxInt cartCount = 0.obs;

  // Cập nhật số lượng sản phẩm từ localStorage
  void updateCartCountFromLocalStorage() {
    try {
      final String? cartData = deviceStorage.read('cart');
      if (cartData != null) {
        final List<dynamic> cartItems = json.decode(cartData);
        cartCount.value = cartItems.length;
      } else {
        cartCount.value = 0;
      }
    } catch (e) {
      print('Lỗi khi cập nhật số lượng từ localStorage: $e');
      cartCount.value = 0;
    }
  }

}
