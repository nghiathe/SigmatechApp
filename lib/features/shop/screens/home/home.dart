import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:sigmatech/utils/constants/colors.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/device/device_utility.dart';


import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../common/widgets/products.cart/cart_menu_icon.dart';
import '../../../../utils/constants/text_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              children: [
                TPrimaryHeaderContainer(
                  child: Column(
                    children: [
                      const THomeAppBar(),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Padding
                        (padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                          child: Container(
                              width: TDeviceUtils.getScreenWidth(context),
                              padding: const EdgeInsets.all(TSizes.md),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                                  border: Border.all(color: TColors.grey)
                              ),
                              child: Row(
                                children: [
                                  const Icon(Iconsax.search_normal, color: TColors.grey),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  Text('Tìm kiếm sản phẩm', style: Theme.of(context).textTheme.bodySmall)
                                ],
                              )
                          )
                      )

                    ],
                  ),)
              ]

          )

      ),
    );
  }
}







