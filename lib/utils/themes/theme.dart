import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'elevated_button_theme.dart';
import 'text_theme.dart';

class AppThemes {
  AppThemes._();

  //     L I G H T     T H E M E

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Quicksand',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    textTheme: AppTextThemes.lightTextTheme,
    dividerColor: AppColors.lightBorderColor,
    elevatedButtonTheme: AppElevatedButtonThemes.elevatedButtonTheme,
  );

  //     D A R K     T H E M E
  
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Quicksand',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    textTheme: AppTextThemes.lightTextTheme,
    dividerColor: AppColors.lightBorderColor,
    elevatedButtonTheme: AppElevatedButtonThemes.elevatedButtonTheme,
  );
}