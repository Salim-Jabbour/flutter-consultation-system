import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget(
      {required this.title,
      required this.navigatorFunc,
      this.width = 400,
      this.height = 120,
      this.cardColor = Colors.white,
      this.paddingValue,
      // this.textColor = const Color(0xFF333333),
      super.key});

  final String title;
  final void Function()? navigatorFunc;
  final double? width;
  final double? height;
  final double? paddingValue;
  final Color? cardColor;
  final Color textColor = ColorManager.c1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          top: paddingValue == null ? 30.h : paddingValue!),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: width?.w,
        height: height?.h,
        child: InkWell(
          onTap: navigatorFunc,
          child: Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: navigatorFunc,
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textColor,
                      size: 15.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
