import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:sigmatech/common/widgets/appbar/appbar.dart';
import 'package:sigmatech/common/widgets/products.cart/cart_menu_icon.dart';
import 'package:sigmatech/features/shop/screens/cart/cart.dart';
import 'package:sigmatech/features/shop/screens/home/widgets/BrandLaptopScreen.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';

class HomeScreen extends StatelessWidget {
  final LaptopService laptopService = LaptopService.instance;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final deviceStorage = GetStorage();

    return Scaffold(
      appBar: TAppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Day!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'SKIBIDI',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        actions: [

          TCartCounterIcon(onPressed: (){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );}),

          TCartCounterIcon(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          }),

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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Search in Store',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Brand Laptop
              const Text(
                'Brand Laptop',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 95, // Điều chỉnh chiều cao
                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: [
                    _buildBrandItem('Dell', 'https://example.com/dell.png', context),
                    _buildBrandItem('Asus', 'https://example.com/asus.png', context),
                    _buildBrandItem('Lenovo', 'https://example.com/lenovo.png', context),
                    _buildBrandItem('Acer', 'https://example.com/Acer.png', context),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Laptop of the Week
              const Text(
                'Laptop of the Week',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: laptops.length > 10 ? 10 : laptops.length, // Hiển thị tối đa 10 laptop
                itemBuilder: (context, index) {
                  final laptop = laptops[index];

                  final name = laptop['name'] ?? 'Unknown';
                  final brand = laptop['brand'] ?? 'Unknown';
                  final price = int.tryParse(laptop['price'] ?? '0') ?? 0;
                  final imageUrl = 'https://6ma.zapto.org' + laptop['image1'] ?? 'https://via.placeholder.com/150';

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => LaptopDetailScreen(), arguments: laptop['id']);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  brand,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(price)} VNĐ',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
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

  Widget _buildBrandItem(String brand, String imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến trang chứa danh sách laptop theo thương hiệu
        Get.to(() => BrandLaptopScreen(brand: brand));
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 35, // Điều chỉnh kích thước
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 6),
          Text(
            brand,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}