import 'dart:ui'; // For using the BlurEffect
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:together_travel/utils/constants/images.dart';
import 'package:together_travel/utils/constants/routes.dart';
import 'package:together_travel/utils/constants/sizes.dart';
import 'package:together_travel/widgets/choose_ride_widget.dart';

class ChooseRideScreen extends StatelessWidget {
  const ChooseRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChooseRideWidget(
              imagePath: AppImages.continueAsDriver,
              title: 'Take The Wheel',
              tag: 'Driver',
              subtitle:
              'Drive with us and enjoy the ride as a driver, providing safe rides to passengers.',
            ),
          ),
          Divider(height: 2, color: Colors.white70,),
          Expanded(
            child: ChooseRideWidget(
              imagePath: AppImages.continueAsPassenger,
              title: 'Grab The Seat',
              tag: 'Passenger',
              subtitle:
              'Join the ride as a passenger and travel comfortably with others while saving on travel costs.',
            ),
          ),
        ],
      ),
    );
  }
}
