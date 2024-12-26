import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/common/widgets/appbar/appbar.dart';
import 'package:sigmatech/features/shop/controllers/userprofile/user_profile_controller.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/popups/loaders.dart';

class AddressScreen extends StatelessWidget {
  final TextEditingController addressController = TextEditingController();
  AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileController = Get.put(UserProfileController());

    return Scaffold(
      appBar: const TAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Địa chỉ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị địa chỉ hiện tại
                Obx(() {
                  final currentAddress = userProfileController.userAddress;
                  return Text(
                    'Địa chỉ hiện tại: $currentAddress',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: currentAddress == 'Chưa cập nhật địa chỉ'
                          ? Colors.grey
                          : Colors.black,
                    ),
                  );
                }),

                const SizedBox(height: 20), // Khoảng cách giữa các widget

                // Nhập địa chỉ mới
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ mới',
                    hintText: 'Nhập địa chỉ nhận hàng mới',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Tạo khoảng cách 2 bên
                child: SizedBox(
                  width: double.infinity, // Kéo dài chiều ngang hết màn hình
                  child: ElevatedButton(
                    onPressed: () {
                      final newAddress = addressController.text.trim();
                      if (newAddress.isNotEmpty) {
                        userProfileController.updateUserAddress(newAddress);
                        Get.back(); // Quay lại màn hình trước sau khi cập nhật
                      } else {
                        TLoaders.errorSnackBar(
                            title: 'Lỗi', message: 'Địa chỉ không hợp lệ');
                      }
                    },
                    child: const Text('Cập nhật địa chỉ'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
