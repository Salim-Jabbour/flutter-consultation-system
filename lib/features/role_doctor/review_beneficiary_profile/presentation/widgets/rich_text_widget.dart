import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/theme/color_manager.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({super.key, required this.first, required this.second});

  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      child: RichText(
        text: TextSpan(
            text: first,
            style: TextStyle(
              color: ColorManager.c1,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: second,
                style: TextStyle(
                  color: ColorManager.c2,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      ),
    );
  }
}
