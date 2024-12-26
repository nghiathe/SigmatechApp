import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
    final CartController cartController = Get.put(CartController());
    final deviceStorage = GetStorage();
    String token = deviceStorage.read('authToken');

    // Cập nhật số lượng sản phẩm giỏ hàng mỗi khi màn hình được xây dựng
    cartController.updateCartCount(token);

    return Obx(() {
      int cartCount = cartController.cartCount.value;  // Lấy số lượng từ Rx<int>

      return Stack(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.shopping_bag_outlined, color: TColors.primary),
          ),
            // Hiển thị số lượng chỉ khi có sản phẩm trong giỏ hàng
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
