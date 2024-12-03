import 'package:flutter/material.dart';
import 'package:together_travel/utils/constants/sizes.dart';
import 'package:together_travel/utils/constants/styles.dart';
import '../constants/colors.dart';

class AppElevatedButtonThemes {
  AppElevatedButtonThemes._();

  static final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: AppSizes.elevation,
      textStyle: AppStyles.bodySmall.copyWith(color: Colors.white),
    ),
  );
}