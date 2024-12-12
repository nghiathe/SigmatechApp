import 'package:flutter/material.dart';
import 'package:sigmatech/utils/constants/image_strings.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/constants/text_strings.dart';
import 'package:sigmatech/utils/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image: AssetImage(dark ? Timages.darkAppLogo : Timages.lightAppLogo),
        ),
        Text(TTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: TSizes.sm),
        Text(TTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}
