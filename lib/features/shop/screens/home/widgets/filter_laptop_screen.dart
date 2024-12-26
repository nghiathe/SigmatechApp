import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sigmatech/features/shop/screens/store/detail_laptop_screen.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';

class FilterLaptopScreen extends StatelessWidget {
  final String keyword; // Từ khóa tìm kiếm
  final LaptopService laptopService = LaptopService.instance;

  FilterLaptopScreen({required this.keyword});

  @override
  Widget build(BuildContext context) {
    final filteredLaptops = laptopService.laptops
        .where((laptop) =>
        (laptop['name'] ?? '').toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm cho "$keyword"'),
      ),
      body: filteredLaptops.isEmpty
          ? const Center(child: Text('Không có sản phẩm cần tìm.'))
          : ListView.builder(
        itemCount: filteredLaptops.length,
        itemBuilder: (context, index) {
          final laptop = filteredLaptops[index];
          final price = int.tryParse(laptop['price'] ?? '0') ?? 0;
          return ListTile(
            leading: laptop['image1'] != null
                ? Image.network(
              'https://6ma.zapto.org${laptop['image1']}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 50);
              },
            )
                : const Icon(Icons.computer, size: 50),
            title: Text(laptop['name'] ?? 'Unknown'),
            subtitle: Text(
              '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(price)} VNĐ',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            onTap: () {
              Get.to(() => LaptopDetailScreen(), arguments: laptop['id']);
            },
          );
        },
      ),
    );
  }
}
