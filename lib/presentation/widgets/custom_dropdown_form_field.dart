
import 'package:flutter/material.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/gen/assets.gen.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  final Color? fillColor;
  final double? borderWidth;
  final double? radius;

  const CustomDropdownFormField({
    super.key,
    this.value,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    required this.items,
    this.onChanged,
    this.validator,
    this.fillColor,
    this.borderWidth,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultRadius = radius ?? 18.0;
    final double defaultBorderWidth = borderWidth ?? 1.0;

    OutlineInputBorder buildBorder(Color color, [double? width]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        borderSide: BorderSide(
          color: color,
          width: width ?? defaultBorderWidth,
        ),
      );
    }

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,

      style: TextStyle(
        color: AppColors.black,
        fontFamily: Assets.fonts.fredokaMedium,
        fontSize: 15,
      ),

      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.grey1,
      ),

      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,

        filled: true,
        fillColor: fillColor ??
            const Color.fromARGB(255, 239, 237, 237),

        labelStyle: TextStyle(
          color: AppColors.grey1,
          fontSize: 16,
        ),

        hintStyle: TextStyle(
          color: AppColors.grey1,
          fontFamily: Assets.fonts.fredokaMedium,
          fontSize: 14,
        ),

        errorStyle: TextStyle(
          color: AppColors.neutralRed,
          fontFamily: Assets.fonts.fredokaMedium,
          fontSize: 12,
        ),

        enabledBorder: buildBorder(Colors.transparent),

        focusedBorder: buildBorder(
          AppColors.primaryGreen,
          1.5,
        ),

        errorBorder: buildBorder(
          AppColors.neutralRed,
        ),

        focusedErrorBorder: buildBorder(
          AppColors.neutralRed,
          1.5,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

