import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/features/authentication/screens/signup/widgets/terms_and_condition_checkbox.dart';
import 'package:sigmatech/utils/constants/colors.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/constants/text_strings.dart';
import 'package:sigmatech/utils/helpers/helper_functions.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          //full name
          TextFormField(
            expands:false,
            decoration: const InputDecoration(
              labelText: TTexts.fullName, 
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //mail
          TextFormField(
            expands: false,
            decoration:  const InputDecoration(
              labelText: TTexts.email, 
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Phone
          TextFormField(
            expands: false,
            decoration:  const InputDecoration(
              labelText: TTexts.phoneNo, 
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Password
          TextFormField(
            obscureText: true,
            decoration:  const InputDecoration(
              labelText: TTexts.password,
              prefixIcon: Icon(Iconsax.password_check), 
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Password comfirm
          TextFormField(
            obscureText: true,
            decoration:  const InputDecoration(
              labelText: TTexts.passwordConfirm,
              prefixIcon: Icon(Iconsax.password_check), 
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          //Term and condition check
          const TTermsAndConditionCheckbox(),
    
          const SizedBox(height: TSizes.spaceBtwSections),
          //Sign up button
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text(TTexts.createAccount))),
        ],
      )
    );
  }
}
