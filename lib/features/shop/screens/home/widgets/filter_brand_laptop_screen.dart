import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sigmatech/features/shop/controllers/cart/cart_controller.dart';
import 'package:sigmatech/features/shop/screens/store/detail_laptop_screen.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';
import 'package:sigmatech/features/shop/screens/wishlist/widget/WishlistService.dart';
import 'package:sigmatech/utils/constants/colors.dart';
class BrandLaptopScreen extends StatelessWidget {
  final String brand;
  final LaptopService laptopService = LaptopService.instance;
  final WishlistService wishlistService = Get.put(WishlistService());
  BrandLaptopScreen({required this.brand});

  @override
  Widget build(BuildContext context) {
    final filteredLaptops = laptopService.laptops
        .where((laptop) => (laptop['brand'] ?? '').toLowerCase() == brand.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Laptops $brand'),
      ),
      body: filteredLaptops.isEmpty
          ? const Center(child: Text('Không có sản phẩm cần tìm.'))
          : GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số cột
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75, // Tỷ lệ khung hình của từng ô
        ),
        itemCount: filteredLaptops.length,
        itemBuilder: (context, index) {
          final laptop = filteredLaptops[index];
          final name = laptop['name'] ?? 'Không rõ tên';
          final brand = laptop['brand'] ?? 'Không rõ thương hiệu';
          final price = int.tryParse(laptop['price'] ?? '0') ?? 0;
          final imageUrl = 'https://6ma.zapto.org' + laptop['image1'] ?? 'https://via.placeholder.com/150';
          return GestureDetector(
            onTap: () {
              Get.to(() => LaptopDetailScreen(), arguments: laptop['id']);
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hình ảnh sản phẩm
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12.0)),
                        child: Image.network(
                          imageUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 50);
                          },
                        ),
                      ),
                      // Thông tin sản phẩm
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              brand,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(price)} VNĐ',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Icon trái tim ở góc trên phải
                  Positioned(
                    top: 1.0,
                    right: 1.0,
                    child: Obx(() {
                      final isFavorite = wishlistService.isInWishlist(laptop['id']);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            wishlistService.removeFromWishlist(laptop['id']);
                          } else {
                            wishlistService.addToWishlist(laptop['id']);
                          }
                        },
                      );
                    }),
                  ),
                  // Icon dấu cộng ở góc dưới phải
                  Positioned(
                    bottom: 1.0,
                    right: 1.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF408591),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12), // Góc trên bên trái
                            bottomRight: Radius.circular(12), // Góc dưới bên phải
                            topRight: Radius.zero, // Các góc khác vuông
                            bottomLeft: Radius.zero,
                          ),
                        ),
                        padding: EdgeInsets.zero, // Loại bỏ padding mặc định
                        minimumSize: const Size(40, 40), // Kích thước nhỏ hơn
                      ),
                      onPressed: () async {
                        await CartController.addToCartLocal(
                          laptop['id'],      // productId
                          'laptops',         // productType
                          1,                 // quantity
                          laptop['name'],    // name
                          price,             // price
                          imageUrl,          // imageUrl
                        );

                        // Hiển thị thông báo snack bar
                        Get.snackbar(
                          'Giỏ hàng',
                          '${laptop['name']} đã được thêm vào giỏ hàng!',
                        );

                        // Cập nhật lại số lượng giỏ hàng sau khi thêm
                      },

                      child: const Icon(
                        Iconsax.add,
                        color: TColors.white,
                        size: 20, // Kích thước icon nhỏ hơn
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),

    );
  }
}