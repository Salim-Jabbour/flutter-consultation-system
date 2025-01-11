import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/color_manager.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.color,
    this.disabledColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  final String text;
  final Function()? onPressed;
  final Color? color;
  final Color? disabledColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? ColorManager.c2,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0.r), // Adjust the radius as needed
          ),
          disabledBackgroundColor: disabledColor ?? ColorManager.c2,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: fontWeight ?? FontWeight.normal,
            
          ),
          textAlign:textAlign?? TextAlign.center,
        ),
      ),
    );
  }
}
