import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:together_travel/utils/constants/routes.dart';

class AuthOnboardingController extends GetxController {
  static AuthOnboardingController get instance => Get.find();

  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;

  void updatePageIndex(index) => currentPageIndex.value = index;

  Future<void> startRiding() async {
    if(currentPageIndex.value == 1) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('HAS_SEEN_ONBOARDING', true).then((value) {
        Get.offAllNamed(AppRoutesNames.signIn);
      });
    } else {
      currentPageIndex.value++;
      pageController.animateToPage(
        currentPageIndex.value, 
        duration: const Duration(milliseconds: 600), 
        curve: Curves.linear,
      );
    }
  }
}