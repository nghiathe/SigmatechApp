import 'package:flutter/material.dart';
import 'package:sigmatech/utils/theme/custom_themes/elevated_botton_theme.dart';
import 'package:sigmatech/utils/theme/custom_themes/text_theme.dart';
import 'package:sigmatech/utils/theme/custom_themes/appbar_theme.dart';
import 'package:sigmatech/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:sigmatech/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:sigmatech/utils/theme/custom_themes/chip_theme.dart';
import 'package:sigmatech/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:sigmatech/utils/theme/custom_themes/text_field_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    chipTheme: TChipTheme.lightChipTheme,
    outlinedButtonTheme: TOutlinedBottom.lightOutlinedButtomTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    chipTheme: TChipTheme.darkChipTheme,
    outlinedButtonTheme: TOutlinedBottom.darkOutlinedButtomTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme
  );
}
