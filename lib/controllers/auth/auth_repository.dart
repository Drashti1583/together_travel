import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/routes.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  @override
  void onReady() {
    super.onReady();
    checkHasSeenOnBoarding();
  }

  Future<void> checkHasSeenOnBoarding() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool hasSeen = preferences.getBool('HAS_SEEN_ONBOARDING') ?? false;
    FlutterNativeSplash.remove();
    if (!hasSeen) {
      Get.offAllNamed(AppRoutesNames.onBoarding);
    } else {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offAllNamed(AppRoutesNames.chooseRide);
      } else {
        Get.offAllNamed(AppRoutesNames.signIn);
      }
    }
  }
}