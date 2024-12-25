import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> filteredLaptops = <Map<String, dynamic>>[].obs;

  void searchLaptops(List<Map<String, dynamic>> laptops, String query) {
    if (query.isEmpty) {
      filteredLaptops.value = laptops;
    } else {
      filteredLaptops.value = laptops
          .where((laptop) =>
          (laptop['name'] ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void clearSearch(List<Map<String, dynamic>> laptops) {
    searchController.clear();
    filteredLaptops.value = laptops;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
