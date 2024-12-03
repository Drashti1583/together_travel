import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../utils/constants/exceptions.dart';
import '../../utils/constants/firebase.dart';
import '../../utils/constants/routes.dart';
import '../../utils/constants/strings.dart';
import '../../widgets/snackbar_widget.dart';

class AuthController extends GetxController{

  static AuthController get instance => Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordObscured = true.obs;
  var isConfirmPasswordObscured = true.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  Future<void> signIn() async {
    if (emailController.text.isEmpty) {
      SnackBarWidget.show(message: AppStrings.emailEmpty.tr, title: AppStrings.error.tr);
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      SnackBarWidget.show(message: AppStrings.validEmail.tr, title: AppStrings.error.tr);
      return;
    }

    if (passwordController.text.isEmpty) {
      SnackBarWidget.show(message: AppStrings.passwordEmpty.tr, title: AppStrings.error.tr);
      return;
    }

    if (passwordController.text.length < 6) {
      SnackBarWidget.show(message: AppStrings.validPassword.tr, title: AppStrings.error.tr);
      return;
    }

    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) => Get.offAllNamed((AppRoutesNames.chooseRide)));

      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      SnackBarWidget.show(
          message: CFirebaseExceptions(e.code).message, title: AppStrings.error.tr);
    } on PlatformException catch (e) {
      SnackBarWidget.show(
          message: CPlatformExceptions(e.code).message, title: AppStrings.error.tr);
    } catch (e) {
      SnackBarWidget.show(
          message: AppStrings.somethingWrong.tr,
          title: AppStrings.error.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (usernameController.text.isEmpty) {
      SnackBarWidget.show(message: AppStrings.nameEmpty.tr, title: AppStrings.error.tr);
      return;
    }

    if (usernameController.text.length < 5) {
      SnackBarWidget.show(message: AppStrings.validName.tr, title: AppStrings.error.tr);
      return;
    }

    if (emailController.text.isEmpty) {
      SnackBarWidget.show(message: AppStrings.emailEmpty.tr, title: AppStrings.error.tr);
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      SnackBarWidget.show(message: AppStrings.validEmail.tr, title: AppStrings.error.tr);
      return;
    }

    if (passwordController.text.isEmpty) {
      SnackBarWidget.show(message: AppStrings.passwordEmpty.tr, title: AppStrings.error.tr);
      return;
    }

    if (passwordController.text.length < 6) {
      SnackBarWidget.show(message: AppStrings.validPassword.tr, title: AppStrings.error.tr);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      SnackBarWidget.show(message: AppStrings.passwordMatch.tr, title: AppStrings.error.tr);
      return;
    }

    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      UserModel userModel = UserModel(
        name: usernameController.text.trim(),
        email: emailController.text.trim(),
        uid: _auth.currentUser?.uid ?? '',
      );

      Map<String, dynamic> data = {
        CFirebase.name: userModel.name,
        CFirebase.email: userModel.email,
        CFirebase.uid: userModel.uid,
      };

      FirebaseFirestore.instance.collection(CFirebase.users).doc(_auth.currentUser?.uid).set(data).then((value) => Get.offAllNamed(AppRoutesNames.chooseRide));

      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      SnackBarWidget.show(
          message: CFirebaseExceptions(e.code).message, title: AppStrings.error.tr);
    } on PlatformException catch (e) {
      SnackBarWidget.show(
          message: CPlatformExceptions(e.code).message, title: AppStrings.error.tr);
    } catch (e) {
      SnackBarWidget.show(
          message: AppStrings.somethingWrong.tr,
          title: AppStrings.error.tr);
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',);
    return emailRegExp.hasMatch(email);
  }

  Future<void> resetPassword() async {
    Get.offAllNamed(AppRoutesNames.forgotPassword);
  }

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
  }
}