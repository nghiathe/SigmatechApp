import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';
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
        title: Text('Search Results for "$keyword"'),
      ),
      body: filteredLaptops.isEmpty
          ? const Center(child: Text('No laptops found matching your search.'))
          : ListView.builder(
        itemCount: filteredLaptops.length,
        itemBuilder: (context, index) {
          final laptop = filteredLaptops[index];
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
              '${laptop['price'] ?? '0'} VNĐ',
              style: const TextStyle(color: Colors.red),
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
