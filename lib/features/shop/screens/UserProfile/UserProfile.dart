import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/common/widgets/appbar/appbar.dart';
import 'package:sigmatech/features/shop/controllers/userprofile/user_profile_controller.dart';
import 'package:sigmatech/features/shop/screens/UserProfile/OrderList.dart';
import 'package:sigmatech/features/shop/screens/userprofile/widgets/address.dart';
import 'package:sigmatech/utils/constants/colors.dart';
import 'package:sigmatech/utils/constants/image_strings.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/helpers/helper_functions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(UserProfileController());

    return Scaffold(
      appBar: const TAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tài khoản',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final user = controller.user;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: dark ? TColors.black : TColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          Timages.user), // Change to your avatar image
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Account Settings Section
            const Text('Cài đặt tài khoản',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._buildAccountSettings(controller),

            const SizedBox(height: 24),

            // App Settings Section
            const Text('Cài đặt ứng dụng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._buildAppSettings(dark),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildAccountSettings(UserProfileController controller) {
    final deviceStorage = GetStorage();
    String token = deviceStorage.read('authToken');
    return [
      _buildListTile(
        Iconsax.home, 'Địa chỉ của tôi', 'Thiết lập địa chỉ giao hàng', 
        () {
          Get.to(() => AddressScreen());
        }),
      _buildListTile(Iconsax.shopping_cart, 'Giỏ hàng',
          'Thêm, xóa sản phẩm và thanh toán', null),
      _buildListTile(Iconsax.box, 'Đơn hàng của tôi',
          'Đơn hàng đang xử lý và đã hoàn tất', () {
            Get.to(() => OrderListScreen(token: token));  // Điều hướng đến màn hình đơn hàng
          }),
      _buildListTile(Iconsax.lock, 'Quyền riêng tư',
          'Quản lý quyền riêng tư và kết nối tài khoản', null),
      _buildListTile(
        Iconsax.logout, 
        'Đăng xuất', 
        'Đăng xuất tài khoản khỏi thiết bị này', 
        () {
          _showLogoutConfirmationDialog(controller);
        }
      ),
    ];
  }

  List<Widget> _buildAppSettings(bool darkMode) {
    return [
      ListTile(
        leading: const Icon(Iconsax.moon, color: TColors.primary,),
        title: const Text('Dark Mode'),
        subtitle: const Text('Đã có chế độ tối cho bạn!'),
        trailing: Switch(
          value: darkMode,
          onChanged: (value) {
            // Thêm logic để thay đổi dark mode
          },
          activeColor: TColors.primary,
        ),
      ),
    ];
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, size: 28, color: const Color(0xFF408591)),
      title: Text(title,
          style: const TextStyle(fontSize: TSizes.fontSizeMd, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: TSizes.fontSizeSm, color: Colors.grey)),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmationDialog(UserProfileController controller) {
  Get.defaultDialog(
    title: 'Xác nhận đăng xuất',
    middleText: 'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này không?',
    textCancel: 'Hủy',
    textConfirm: 'Đăng xuất',
    confirmTextColor: Colors.white,
    onConfirm: () {
      controller.logoutUser();
      Get.back(); // Đóng dialog sau khi đăng xuất
    },
    onCancel: () {
      Get.back(); // Đóng dialog nếu hủy
    },
  );
}

}
