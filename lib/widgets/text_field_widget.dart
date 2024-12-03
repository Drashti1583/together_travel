import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? helperText;
  final IconData prefixIcon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final bool? autoFocus;
  final void Function(String)? onChanged;
  const TextFieldWidget({required this.prefixIcon, this.autoFocus, this.onChanged, this.suffixIcon, this.obscureText, this.helperText, required this.labelText, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autofocus: autoFocus ?? false,
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: onChanged,
      cursorColor: Theme.of(context).textTheme.bodyLarge!.color,
      decoration: InputDecoration(
        helperText: helperText,
        helperStyle: Theme.of(context).textTheme.labelSmall,
        helperMaxLines: 3,
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.lightBorderColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLG),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLG),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: AppSizes.re, right: AppSizes.sm),
          child: Icon(prefixIcon),
        ),
        suffixIcon: suffixIcon != null ? Padding(
          padding: EdgeInsets.only(left: AppSizes.sm, right: AppSizes.re),
          child: suffixIcon,
        ) : null,
      ),
    );
  }
}