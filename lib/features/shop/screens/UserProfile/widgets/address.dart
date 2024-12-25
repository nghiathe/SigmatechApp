import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/features/shop/controllers/userprofile/user_profile_controller.dart';
import 'package:sigmatech/utils/constants/colors.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/helpers/helper_functions.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(UserProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ nhận hàng'),
        backgroundColor: dark ? TColors.black : Colors.white,
        foregroundColor: dark ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị địa chỉ người dùng
            const Text(
              'Địa chỉ giao hàng hiện tại:',
              style: TextStyle(fontSize: TSizes.fontSizeLg, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Obx(() {
              return Text(
                controller.userAddress,
                style: const TextStyle(fontSize: TSizes.fontSizeMd, color: Colors.grey),
              );
            }),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Nút để chỉnh sửa địa chỉ
            ElevatedButton.icon(
              onPressed: () {
                _showEditAddressDialog(context, controller);
              },
              icon: const Icon(Iconsax.edit, size: TSizes.iconMd),
              label: const Text('Chỉnh sửa địa chỉ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị Dialog để chỉnh sửa địa chỉ
  void _showEditAddressDialog(BuildContext context, UserProfileController controller) {
    final TextEditingController addressController = TextEditingController();

    // Hiển thị dialog để người dùng chỉnh sửa địa chỉ
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa địa chỉ nhận hàng'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(hintText: 'Nhập địa chỉ mới'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Cập nhật địa chỉ của người dùng
                if (addressController.text.isNotEmpty) {
                  //controller.updateUserAddress(addressController.text);
                  Get.back();
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
