import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sigmatech/features/shop/controllers/cart/cart_controller.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';
import 'package:sigmatech/features/shop/screens/wishlist/widget/WishlistService.dart';

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
        title: Text('Laptops from $brand'),
      ),
      body: filteredLaptops.isEmpty
          ? const Center(child: Text('No laptops found for this brand.'))
          : GridView.builder(
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
          final imageUrl = 'https://6ma.zapto.org' + (laptop['image1'] ?? '/placeholder.png');
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
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () async {
                        String token = GetStorage().read('authToken'); // Lấy token từ bộ nhớ
                        await CartController.addToCart(
                          token,
                          'laptops',
                          laptop['id'],
                          1,
                          laptop['name'],
                        );
                        Get.snackbar(
                          'Giỏ hàng',
                          '${laptop['name']} đã được thêm vào giỏ hàng!',
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
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