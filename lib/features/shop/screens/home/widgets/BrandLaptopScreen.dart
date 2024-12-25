import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';

class BrandLaptopScreen extends StatelessWidget {
  final String brand;
  final LaptopService laptopService = LaptopService.instance;

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
          : ListView.builder(
        itemCount: filteredLaptops.length,
        itemBuilder: (context, index) {
          final laptop = filteredLaptops[index];
          return ListTile(
            title: Text(laptop['name'] ?? 'Unknown'),
            subtitle: Text('${laptop['price'] ?? '0'} VNĐ'),
            onTap: () {
              Get.to(() => LaptopDetailScreen(), arguments: laptop['id']);
            },
          );
        },
      ),
    );
  }
}