import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextIconButton extends StatelessWidget {
  const CustomTextIconButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.width = 360,
    this.height = 50,
    this.icon,
  });
  final String text;
  final Function() onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width?.w,
        height: height?.h,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon == null
                ? const SizedBox.shrink()
                : Icon(
                    icon,
                    color: Colors.white,
                    size: 15.sp,
                  ),
            SizedBox(width: 5.w),
            Text(
              text,
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
