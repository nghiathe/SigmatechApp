import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/features/authentication/screens/signup/widgets/signup.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/constants/text_strings.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: TTexts.email,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Password
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.password_check),
              labelText: TTexts.password,
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),
    
          //Remember Me & Forget password
          Row(
            children: [
              //remember me
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}),
                  const Text(TTexts.rememberMe),
                ],
              ),
              //forget password
              TextButton(onPressed: () {} , child: const Text(TTexts.forgetPassword)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          
          //Sign in button
          SizedBox(
            width: double.infinity,
            child:  ElevatedButton(onPressed: () {}, child: const Text(TTexts.signIn)),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
    
          //Create account button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const SignupScreen()), 
              child: const Text(TTexts.createAccount)),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      )
    );
  }
}
