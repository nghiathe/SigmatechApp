import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/features/authentication/controllers/signup/signup_controller.dart';
import 'package:sigmatech/features/authentication/screens/signup/widgets/terms_and_condition_checkbox.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/constants/text_strings.dart';
import 'package:sigmatech/utils/validators/validation.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
      children: [
        //name
        TextFormField(
          controller: controller.name,
          validator: (value) => TValidator.validateEmptyText('Họ và tên', value),
          expands: false,
          decoration: const InputDecoration(
            labelText: TTexts.fullName,
            prefixIcon: Icon(Iconsax.user),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        //email
        TextFormField(
          validator: (value) => TValidator.validateEmail(value),
          controller: controller.email,
          expands: false,
          decoration: const InputDecoration(
            labelText: TTexts.email,
            prefixIcon: Icon(Iconsax.direct),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        //Phone
        TextFormField(
          validator: (value) => TValidator.validatePhoneNumber(value),
          controller: controller.phone,
          expands: false,
          decoration: const InputDecoration(
            labelText: TTexts.phoneNo,
            prefixIcon: Icon(Iconsax.direct),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        //Password
        Obx(
          () => TextFormField(
            validator: (value) => TValidator.validatePassword(value),
            controller: controller.password,
            obscureText: controller.hidePasswordConfirm.value,
            decoration: InputDecoration(
              labelText: TTexts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                onPressed: () => controller.hidePasswordConfirm.value = !controller.hidePasswordConfirm.value, 
                icon: Icon(controller.hidePasswordConfirm.value ? Iconsax.eye_slash : Iconsax.eye),
              ),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        //Password comfirm
        Obx(
          () => TextFormField(
            validator: (value) => TValidator.validatePasswordConfirm(controller.password.text, value),
            controller: controller.passwordConfirm,
            obscureText: controller.hidePassword.value,
            decoration: InputDecoration(
              labelText: TTexts.passwordConfirm,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                onPressed: () => controller.hidePassword.value = !controller.hidePassword.value, 
                icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
              ),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        //Term and condition check
        const TTermsAndConditionCheckbox(),

        const SizedBox(height: TSizes.spaceBtwSections),
        //Sign up button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.signup(), 
            child: const Text(TTexts.createAccount)
          )
        ),
      ],
    ));
  }
}
