import 'package:flutter/material.dart';

import 'colors.dart';
import 'sizes.dart';

class AppStyles {
  AppStyles._();

  static TextStyle labelSmall = TextStyle(fontSize: AppSizes.fontLabelSM, color: AppColors.lightTextColor, fontWeight: FontWeight.w300);
  static TextStyle labelMedium = TextStyle(fontSize: AppSizes.fontLabelMD, color: AppColors.lightTextColor, fontWeight: FontWeight.w300);
  static TextStyle labelLarge = TextStyle(fontSize: AppSizes.fontLabelLG, color: AppColors.lightTextColor, fontWeight: FontWeight.w400);

  static TextStyle bodySmall = TextStyle(fontSize: AppSizes.fontBodySM, color: AppColors.lightTextColor, fontWeight: FontWeight.w400);
  static TextStyle bodyMedium =  TextStyle(fontSize: AppSizes.fontBodyMD, color: AppColors.lightTextColor, fontWeight: FontWeight.w400);
  static TextStyle bodyLarge = TextStyle(fontSize: AppSizes.fontBodyLG, color: AppColors.lightTextColor, fontWeight: FontWeight.w500);

  static TextStyle titleSmall = TextStyle(fontSize: AppSizes.fontTitleSM, color: AppColors.lightTextColor, fontWeight: FontWeight.w500);
  static TextStyle titleMedium = TextStyle(fontSize: AppSizes.fontTitleMD, color: AppColors.lightTextColor, fontWeight: FontWeight.w500);
  static TextStyle titleLarge = TextStyle(fontSize: AppSizes.fontTitleLG, color: AppColors.lightTextColor, fontWeight: FontWeight.w600);

  static TextStyle headlineSmall = TextStyle(fontSize: AppSizes.fontHeadlineSM, color: AppColors.lightTextColor, fontWeight: FontWeight.w600);
  static TextStyle headlineMedium = TextStyle(fontSize: AppSizes.fontHeadlineMD, color: AppColors.lightTextColor, fontWeight: FontWeight.w600);
  static TextStyle headlineLarge = TextStyle(fontSize: AppSizes.fontHeadlineLG, color: AppColors.lightTextColor, fontWeight: FontWeight.w700);
}