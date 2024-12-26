import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/features/shop/screens/userprofile/userprofile.dart';
import 'package:sigmatech/features/shop/screens/home/home.dart';
import 'package:sigmatech/features/shop/screens/store/store.dart';
import 'package:sigmatech/features/shop/screens/wishlist/wishlist.dart';
import 'package:sigmatech/utils/constants/colors.dart';
import 'package:sigmatech/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
            () => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: NavigationBar(
              height: 80,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) {
                controller.selectedIndex.value = index;
              },
              backgroundColor: darkMode
                  ? TColors.black.withOpacity(0.8)
                  : Colors.white.withOpacity(0.8),
              indicatorColor: darkMode
                  ? TColors.white.withOpacity(0.2)
                  : TColors.black.withOpacity(0.1),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: AnimatedScale(
                    scale: controller.selectedIndex.value == 0 ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Iconsax.home,
                      color: controller.selectedIndex.value == 0
                          ? TColors.primary
                          : Colors.grey,
                    ),
                  ),
                  label: 'Trang chủ',
                ),
                NavigationDestination(
                  icon: AnimatedScale(
                    scale: controller.selectedIndex.value == 1 ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Iconsax.shop,
                      color: controller.selectedIndex.value == 1
                          ? TColors.primary
                          : Colors.grey,
                    ),
                  ),
                  label: 'Sản phẩm',
                ),
                NavigationDestination(
                  icon: AnimatedScale(
                    scale: controller.selectedIndex.value == 2 ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Iconsax.heart,
                      color: controller.selectedIndex.value == 2
                          ? TColors.primary
                          : Colors.grey,
                    ),
                  ),
                  label: 'Yêu thích',
                ),
                NavigationDestination(
                  icon: AnimatedScale(
                    scale: controller.selectedIndex.value == 3 ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Iconsax.user,
                      color: controller.selectedIndex.value == 3
                          ? TColors.primary
                          : Colors.grey,
                    ),
                  ),
                  label: 'Tài khoản',
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: controller.screens[controller.selectedIndex.value],
      )),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    StoreScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];
}
