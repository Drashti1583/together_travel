import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/routes.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/strings.dart';
import '../../widgets/text_field_widget.dart';

class AuthSignInScreen extends StatelessWidget {
  const AuthSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.instance;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.re),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                //   W E L C O M E   B A C K   T E X T   &   I N F O

                Text(
                  AppStrings.welcome.tr,
                  style: textTheme.headlineLarge?.copyWith(color: AppColors.primary),
                ),

                Text(
                  '${AppStrings.back.tr}!',
                  style: textTheme.headlineLarge,
                ),

                SizedBox(
                  height: AppSizes.spacingSM,
                ),

                Text(
                    AppStrings.signInInfo.tr,
                    style: textTheme.bodySmall
                ),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                //   E M A I L   T E X T   F I E L D

                TextFieldWidget(
                  prefixIcon: Icons.email_outlined,
                  labelText: AppStrings.enterEmail.tr,
                  controller: authController.emailController,
                ),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                //   P A S S W O R D   T E X T   F I E L D

                Obx(() => TextFieldWidget(
                  obscureText: authController.isPasswordObscured.value,
                  prefixIcon: Icons.password_outlined,
                  suffixIcon: InkWell(
                    canRequestFocus: false,
                    onTap: authController.togglePasswordVisibility,
                    child: Icon( authController.isPasswordObscured.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                  labelText: AppStrings.enterPassword.tr,
                  controller: authController.passwordController,
                )),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                //   F O R G O T   P A S S W O R D

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: AppSizes.sm),
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutesNames.forgotPassword),
                      child: Text(
                        AppStrings.forgotPassword.tr,
                        style: textTheme.labelLarge,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                //   S I G N   I N   B U T T O N

                Obx(() => SizedBox(
                  height: AppSizes.buttonMD,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? () {}
                        : authController.signIn,
                    child: authController.isLoading.value
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      AppStrings.signIn.tr.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                )),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                //   S I G N   U P   O P T I O N

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.re),
                  child: Row(
                    children: <Widget>[
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.re),
                        child: Text(AppStrings.or.tr, style: textTheme.labelMedium,),
                      ),
                      const Expanded(child: Divider())
                    ],
                  ),
                ),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                Center(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutesNames.signUp),
                    child: Text.rich(
                        TextSpan(
                          text: AppStrings.dontHaveAccount.tr,
                          style: textTheme.labelLarge,
                          children: [
                            TextSpan(
                                text: ' ${AppStrings.createAccount.tr}',
                                style: textTheme.labelLarge!.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)
                            )
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
