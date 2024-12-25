import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Để format giá tiền
import 'package:sigmatech/common/widgets/appbar/appbar.dart';
import 'package:sigmatech/common/widgets/products.cart/cart_menu_icon.dart';
import 'package:sigmatech/features/shop/screens/cart/cart.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';
import 'package:sigmatech/features/shop/screens/wishlist/widget/WishlistService.dart';

import '../../../../utils/constants/colors.dart';

class StoreScreen extends StatelessWidget {
  final LaptopService laptopService = LaptopService.instance;
  final WishlistService wishlistService = Get.put(WishlistService());

  StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh mục sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        actions: [
          TCartCounterIcon(onPressed: (){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );}),
        ],
      ),
      body: Obx(() {
        if (laptopService.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (laptopService.laptops.isEmpty) {
          return const Center(child: Text('Không có sản phẩm nào.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Số cột
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75, // Tỷ lệ khung hình của từng ô
          ),
          itemCount: laptopService.laptops.length,
          itemBuilder: (context, index) {
            final laptop = laptopService.laptops[index];

            final name = laptop['name'] ?? 'Không rõ tên';
            final brand = laptop['brand'] ?? 'Không rõ thương hiệu';
            final price = int.tryParse(laptop['price'] ?? '0') ?? 0;
            final imageUrl = 'https://6ma.zapto.org' + laptop['image1'] ?? 'https://via.placeholder.com/150';

            return GestureDetector(
              onTap: () {
                // Điều hướng đến màn hình chi tiết
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
                           // Màu nền của nút
                        ),
                        onPressed: () {
                          // Thêm vào giỏ hàng
                          Get.snackbar('Giỏ hàng', 'Đã thêm vào giỏ hàng!');
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
        );
      }),
    );
  }
}
