import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:together_travel/controllers/auth/auth_onboarding_controller.dart';
import 'package:together_travel/utils/constants/colors.dart';
import 'package:together_travel/utils/constants/images.dart';
import 'package:together_travel/utils/constants/sizes.dart';
import 'package:together_travel/widgets/onboarding_text_widget.dart';

class AuthOnboardingScreen extends StatelessWidget {
  const AuthOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AuthOnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          //     O N B O A R D I N G     P A G E S
      
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndex,
            children: const [

              //     P A G E     O N E

              OnboardingTextWidget(
                image: AppImages.onboarding1, 
                title: 'Join the Ride\nShare the Journey', 
                subtitle: 'Save money, reduce traffic, and make new connections by carpooling. Together, we can create a more sustainable and community focused future.',
              ),

              OnboardingTextWidget(
                image: AppImages.onboarding2, 
                title: 'Drive Green\nLive More Clean', 
                subtitle: 'Carpooling reduces emissions, cuts down on traffic, and helps protect our planet. Every shared ride makes a difference in building a more sustainable future.',
              ),
            ],
          ),

          //     B L A C K     C O N T A I N E R

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.7, 0.9, 1.0],
                  colors: [
                    Colors.black54,
                    Colors.black26,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          //     B U T T O N      &     I N D I C A T O R

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    //     I N D I C A T O R

                    SmoothPageIndicator(
                      controller: controller.pageController,
                      effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.primary,
                        dotHeight: AppSizes.sm
                      ),
                      count: 2,
                    ),
                    SizedBox(height: AppSizes.spacingSM,),

                    //     B U T T O N

                    SizedBox(
                      width: double.infinity, 
                      height: AppSizes.buttonSM,
                      child: ElevatedButton(
                        onPressed: controller.startRiding,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSM)
                          ),
                        ), 
                        child: Text('Start Riding'.toUpperCase(),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}