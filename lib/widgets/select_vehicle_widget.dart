import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:together_travel/controllers/shared/schedule_ride_controller.dart';
import 'package:together_travel/utils/constants/colors.dart';
import 'package:together_travel/utils/constants/sizes.dart';

import '../utils/constants/images.dart';

class SelectVehicleWidget extends StatelessWidget {
  final int index;
  final String image;
  final String text;

  const SelectVehicleWidget({
    super.key,
    required this.index,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleRideController>();
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.selectedVehicle.value = index;
          controller.calculateFares();
        },
        child: Obx(() => Column(
          children: [
            Container(
              height: AppSizes.imageLG,
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusSM),
                border: Border.all(
                  color: controller.selectedVehicle.value == index ? AppColors.primary : AppColors.lightTextColor,
                  width: controller.selectedVehicle.value == index ? 2 : 1,
                ),
              ),
              child: SvgPicture.asset(
                image,
                color: controller.selectedVehicle.value == index ? AppColors.primary : AppColors.lightTextColor,
              ),
            ),
            SizedBox(height: AppSizes.sm,),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: controller.selectedVehicle.value == index ? AppColors.primary : null,
                fontWeight: controller.selectedVehicle.value == index ? FontWeight.w600 : null,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
