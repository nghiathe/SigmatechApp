import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/common/styles/spacing_styles.dart';
import 'package:sigmatech/common/widgets/login_signup/social_buttons.dart';
import 'package:sigmatech/common/widgets/login_signup/form_divider.dart';
import 'package:sigmatech/features/authentication/screens/login/widgets/login_form.dart';
import 'package:sigmatech/features/authentication/screens/login/widgets/login_header.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/constants/text_strings.dart';
import '../../../shop/screens/home/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: TSpacingStyle.paddingWithAppBarHeight,
      child: Column(
        children: [
          const TLoginHeader(),

          //Form
          const TLoginForm(),

          //Devider
          TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),

          const SizedBox(height: TSizes.spaceBtwSections),
          //footer
          const TSocialButtons(),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      ),
    )));
  }
}
