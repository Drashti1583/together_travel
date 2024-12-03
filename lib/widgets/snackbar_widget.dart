import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:together_travel/utils/constants/sizes.dart';

class SnackBarWidget {
  SnackBarWidget._();
  static void show({required String message, required String title}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Theme.of(Get.context!).textTheme.bodySmall?.color,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(AppSizes.lg),
      borderRadius: AppSizes.borderRadiusSM,
      borderWidth: 0.5,
      borderColor: Theme.of(Get.context!).textTheme.bodySmall?.color,
    );
  }
}