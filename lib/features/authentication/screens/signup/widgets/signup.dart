import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sigmatech/utils/constants/colors.dart';
import 'package:sigmatech/utils/constants/sizes.dart';
import 'package:sigmatech/utils/constants/text_strings.dart';
import 'package:sigmatech/utils/helpers/helper_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //title
              Text(
                TTexts.signupTitle, 
                style: Theme.of(context).textTheme.headlineMedium
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              //Form
              Form(
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
                    TextFormField(
                      obscureText: true,
                      decoration:  const InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: Icon(Iconsax.password_check), 
                        suffixIcon: Icon(Iconsax.eye_slash),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    //Term and condition check
                    Row(
                      children: [
                        SizedBox(
                          width: 24, 
                          height:  24,
                          child: 
                          Checkbox(value: true, onChanged: (value) {}),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(text: '${TTexts.iAgreeTo} ', style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(text: '${TTexts.privacyPolicy} ', style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? TColors.white : TColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: dark ? TColors.white : TColors.primary,
                            )),
                            TextSpan(text: '${ TTexts.and} ', style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(text: '${TTexts.termsOfUse} ', style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? TColors.white : TColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: dark ? TColors.white : TColors.primary,
                            )),
                          ]),
                        ),
                      ],
                    ),
                    //Sign up button
                  ],
                )
              )
            ],
          ),
        )
      ),
    );
  }
}