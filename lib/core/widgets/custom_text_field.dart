import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/color_manager.dart';

class CustomTextField extends StatelessWidget {
  // final double? width;
  final double? height;
  final String? hintText;
  final IconData? icon;
  final TextEditingController? textEditingController;
  final Widget? suffixIconWidget;
  final bool? visibility;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? Function(String?)? onFieldSubmittedFunc;
  final Color? textFieldColor;
  final String? initialValue;
  final bool? enabled;

  const CustomTextField(
      {super.key,
      this.keyboardType,
      // required this.width,
      this.height,
      this.hintText,
      this.icon,
      this.textEditingController,
      this.suffixIconWidget,
      this.visibility,
      this.validator,
      this.onFieldSubmittedFunc,
      this.textFieldColor,
      this.initialValue,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width.w,
      height: height?.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: textFieldColor ??
            ColorManager.textFieldFill, // Adjust the color to your preference
      ),
      child: TextFormField(
        maxLines: height != null ? ((height ?? 20) / 20).ceil() : 1,
        cursorColor: Colors.black,
        cursorWidth: 0.5,
        style: TextStyle(fontSize: 14.sp),
        enabled: enabled,
        initialValue: initialValue,
        controller: textEditingController,
        keyboardType: keyboardType,
        obscureText: visibility ?? false,
        decoration: InputDecoration(
          // contentPadding: ,
          hintStyle: TextStyle(
            color: ColorManager.grey,
            fontSize: 14.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: ColorManager.c1),
          ),
          // contentPadding:
          //     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: ColorManager.c1),
          ),
          prefixIcon: icon == null
              ? null
              : Icon(
                  icon,
                  color: ColorManager.c1,
                  size: 30.r,
                ),
          suffixIcon: suffixIconWidget ?? suffixIconWidget,
        ),
        validator: validator,
        onFieldSubmitted: onFieldSubmittedFunc,
      ),
    );
  }
}
