import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

class TextContainerWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final BorderRadiusGeometry? borderRadius;
  final IconData icon;
  final Color? color;
  const TextContainerWidget({super.key, this.color, required this.icon, required this.text, required this.onTap, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.buttonSM,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          border: color != null ? Border.all(color: AppColors.primary) : null,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.borderRadiusLG),
        ),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.sm * 2),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                text,
                style: color != null ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary) : Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
