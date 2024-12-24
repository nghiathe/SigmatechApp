import 'package:flutter/material.dart';
import 'package:sigmatech/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(onPressed: () => OnboardingController.instance.skipPage(), child: const Text('Skip')),
    );
  }
}