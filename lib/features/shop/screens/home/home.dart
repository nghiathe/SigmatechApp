import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sigmatech/common/widgets/appbar/appbar.dart';
import 'package:sigmatech/common/widgets/products.cart/cart_menu_icon.dart';
import 'package:sigmatech/features/shop/controllers/cart/cart_controller.dart';
import 'package:sigmatech/features/shop/screens/cart/cart.dart';
import 'package:sigmatech/features/shop/screens/home/widgets/filter_brand_laptop_screen.dart';
import 'package:sigmatech/features/shop/screens/home/widgets/filter_laptop_screen.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';
import 'package:sigmatech/features/shop/screens/wishlist/widget/WishlistService.dart';
import 'package:sigmatech/features/shop/screens/chat/chat_screen.dart'; // Import file chatbot

class HomeScreen extends StatelessWidget {
  final LaptopService laptopService = LaptopService.instance;
  final TextEditingController searchController = TextEditingController(); // Thêm controller
  final WishlistService wishlistService = Get.put(WishlistService());
  final List<String> sliderImages = [
    'https://6ma.zapto.org/assets/img/banner/Slider/Slide1.jpg',
    'https://6ma.zapto.org/assets/img/banner/Slider/Slide2.jpg',
    'https://6ma.zapto.org/assets/img/banner/Slider/Slide3.jpg',
  ];
  HomeScreen({super.key});
  void _onSearch(BuildContext context) {
    final keyword = searchController.text.trim();
    if (keyword.isNotEmpty) {
      Get.to(() => FilterLaptopScreen(keyword: keyword)); // Điều hướng đến trang lọc
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceStorage = GetStorage();
    return Scaffold(
      appBar: TAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'SIGMATECH',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Xin chào!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TCartCounterIcon(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          }),
          IconButton(
            icon: const Icon(Iconsax.message),
            onPressed: () {
              // Mở cửa sổ chat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (laptopService.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final laptops = laptopService.laptops;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12), // Giữ bo tròn nếu cần
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm trong cửa hàng',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none, // Xóa đường viền mặc định
                          enabledBorder: InputBorder.none, // Xóa viền khi ô tìm kiếm không được focus
                          focusedBorder: InputBorder.none, // Xóa viền khi ô tìm kiếm được focus
                        ),
                        onSubmitted: (_) => _onSearch(context), // Xử lý khi nhấn Enter
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onSearch(context), // Xử lý khi nhấn vào icon tìm kiếm
                      child: const Icon(Icons.search, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
                items: sliderImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: screenWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 50);
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // Laptop of the Week
              const Text(
                'Laptop bán chạy nhất tháng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số cột
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75, // Tỷ lệ khung hình của từng ô
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final laptop = laptopService.laptops[index];
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
                                        fontSize: 13.0,
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
                                shape: RoundedRectangleBorder(
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
            ],
          ),
        );
      }),
    );
  }

}
