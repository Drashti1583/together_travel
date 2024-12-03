import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/routes.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/strings.dart';
import '../../widgets/text_field_widget.dart';

class AuthForgotPasswordScreen extends StatelessWidget {
  const AuthForgotPasswordScreen({super.key});

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

                //   F O R G O T   P A S S W O R D   T E X T   &   I N F O

                Text(
                  AppStrings.forgot.tr,
                  style: textTheme.headlineLarge?.copyWith(color: AppColors.primary),
                ),

                Text(
                  '${AppStrings.password.tr}?',
                  style: textTheme.headlineLarge,
                ),

                SizedBox(
                  height: AppSizes.spacingSM,
                ),

                Text(
                    AppStrings.forgotPasswordInfo.tr,
                    style: textTheme.bodySmall
                ),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                //     E M A I L     C 0 N T R O L L E R S

                TextFieldWidget(
                  controller: authController.emailController,
                  prefixIcon: Icons.email_outlined,
                  labelText: AppStrings.enterEmail.tr,
                ),
                SizedBox(height: AppSizes.spacingMD),

                //   R E S E T   P A S S W O R D   B U T T O N

                SizedBox(
                  height: AppSizes.buttonMD,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? () {}
                        : authController.resetPassword,
                    child: authController.isLoading.value
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      AppStrings.resetPassword.tr.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(
                  height: AppSizes.spacingMD,
                ),

                //   S I G N   I N   O P T I O N

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
                    onTap: () => Get.offAllNamed(AppRoutesNames.signIn),
                    child: Text.rich(
                        TextSpan(
                          text: AppStrings.rememberPassword.tr,
                          style: textTheme.labelLarge,
                          children: [
                            TextSpan(
                                text: ' ${AppStrings.signInHere.tr}',
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
