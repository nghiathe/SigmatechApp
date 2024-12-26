import 'package:get/get.dart';

class WishlistService extends GetxController {
  // Danh sách yêu thích (dùng Set để tránh trùng lặp)
  final RxSet<int> wishlist = <int>{}.obs;

  // Thêm sản phẩm vào danh sách yêu thích
  void addToWishlist(int productId) {
    wishlist.add(productId);
    Get.snackbar('Yêu thích', 'Sản phẩm đã được thêm vào yêu thích!');
  }

  // Xóa sản phẩm khỏi danh sách yêu thích
  void removeFromWishlist(int productId) {
    wishlist.remove(productId);
    Get.snackbar('Yêu thích', 'Sản phẩm đã được xóa khỏi yêu thích!');
  }

  // Kiểm tra xem sản phẩm đã có trong danh sách yêu thích chưa
  bool isInWishlist(int productId) {
    return wishlist.contains(productId);
  }
}
