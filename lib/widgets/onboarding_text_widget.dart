import 'package:flutter/material.dart';

import '../utils/constants/sizes.dart';

class OnboardingTextWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const OnboardingTextWidget({required this.image, required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      height: MediaQuery.of(context).size.height,
      child:Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.35,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 0.9, 1.0],
                colors: [
                  Colors.black54,
                  Colors.black26,
                  Colors.transparent,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.xl),
              child: Column(
                children: [
                  Text(
                    title, 
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.sm,),
                  Text(
                    subtitle, 
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}