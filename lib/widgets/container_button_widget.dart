import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

class ContainerButtonWidget extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  const ContainerButtonWidget({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.iconLG * 1.5,
        width: AppSizes.iconLG * 1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSM),
          border: Border.all(color: AppColors.primary),
        ),
        child: Icon(icon, color: AppColors.primary,),
      ),
    );
  }
}
