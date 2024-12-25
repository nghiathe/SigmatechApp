import 'package:flutter/material.dart';
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
    final deviceStorage = GetStorage();
    String token = deviceStorage.read('authToken');
    return FutureBuilder<int>(
      future: CartController.getCartCount(token),  // Gọi API lấy số lượng sản phẩm
      builder: (context, snapshot) {
        // Kiểm tra trạng thái kết nối của FutureBuilder
        if (snapshot.connectionState == ConnectionState.waiting) {
          return IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.shopping_bag, color: TColors.black),
          );
        }

        // Kiểm tra lỗi
        if (snapshot.hasError) {
          return IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.shopping_bag, color: TColors.black),
          );
        }

        // Lấy số lượng sản phẩm từ kết quả API
        int cartCount = snapshot.data ?? 0;  // Nếu không có dữ liệu, mặc định là 0

        return Stack(
          children: [
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.shopping_bag, color: TColors.black),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: TColors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    cartCount.toString(),  // Hiển thị số lượng sản phẩm
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
      },
    );
  }
}



