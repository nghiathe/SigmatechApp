import 'package:flutter/material.dart';
import 'package:sigmatech/common/widgets/appbar/appbar.dart';
import 'package:sigmatech/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:sigmatech/utils/constants/colors.dart';
import 'package:sigmatech/utils/constants/sizes.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text('Tài khoản', style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                ],
              )
            )
            // Body
          ],
        ),
      ),
    );
  }
}