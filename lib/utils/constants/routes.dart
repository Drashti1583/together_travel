import 'package:get/get.dart';
import 'package:together_travel/screens/auth/auth_forgot_password_screen.dart';
import 'package:together_travel/screens/auth/auth_onboarding_screen.dart';
import 'package:together_travel/screens/auth/auth_sign_in_screen.dart';
import 'package:together_travel/screens/auth/auth_sign_up_screen.dart';
import 'package:together_travel/screens/shared/active_requests_screen.dart';
import 'package:together_travel/screens/shared/choose_destination_screen.dart';
import 'package:together_travel/screens/shared/request_ride_screen.dart';
import 'package:together_travel/screens/shared/schedule_ride_screen.dart';
import '../../screens/shared/choose_ride_screen.dart';

class AppRoutes {
  AppRoutes._();

  static List<GetPage> pages = [
    GetPage(name: AppRoutesNames.onBoarding, page: () => const AuthOnboardingScreen()),
    GetPage(name: AppRoutesNames.signIn, page: () => const AuthSignInScreen()),
    GetPage(name: AppRoutesNames.signUp, page: () => const AuthSignUpScreen()),
    GetPage(name: AppRoutesNames.forgotPassword, page: () => const AuthForgotPasswordScreen()),
    GetPage(name: AppRoutesNames.chooseRide, page: () => const ChooseRideScreen()),
    GetPage(name: AppRoutesNames.chooseDestination, page: () => const ChooseDestinationScreen()),
    GetPage(name: AppRoutesNames.scheduleRide, page: () => const ScheduleRideScreen()),
    GetPage(name: AppRoutesNames.activeRequests, page: () => const ActiveRequestsScreen()),
    GetPage(name: AppRoutesNames.requestRide, page: () => const RequestRideScreen()),
  ];
}

class AppRoutesNames {
  AppRoutesNames._();

  static const String onBoarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String chooseRide = '/choose-ride';
  static const String chooseDestination = '/choose-destination';
  static const String scheduleRide = '/schedule-ride';
  static const String activeRequests = '/active-requests';
  static const String requestRide = '/request-ride';
}