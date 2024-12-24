import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu  extends StatelessWidget {
  const NavigationMenu ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return  Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
          elevation: 0,
          selectedIndex: 0,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Trang chủ'),
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'Sản phẩm'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'Sản phẩm đã lưu'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Tài khoản'),
        ]
      ),
      body: Container(),
    );
  }
}
class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [Container(color: Colors.green), Container(color: Colors.purple), Container(color: Colors.blue)];
}