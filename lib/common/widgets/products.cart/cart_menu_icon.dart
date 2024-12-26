import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

import '../../../features/shop/controllers/cart/cart_controller.dart';
import '../../../utils/constants/colors.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    this.iconColor,
    required this.onPressed,
  });

  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Lấy instance của CartController
    final CartController cartController = Get.put(CartController());

    return Obx(() {
      // Sử dụng biến cartCount từ CartController
      int cartCount = cartController.cartCount.value;

      return Stack(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.shopping_bag_outlined, color: TColors.primary),
          ),

            Positioned(
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: TColors.darkGrey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    cartCount.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(color: TColors.white, fontSizeFactor: 0.8),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
