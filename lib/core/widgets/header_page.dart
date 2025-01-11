import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/color_manager.dart';

class HeaderPage extends StatelessWidget {
  final String title;
  final bool left;
  final IconButton? right;
  final Color? color;
  final Color? leftIconColor;
  const HeaderPage(
      {
      // modified
      super.key,
      required this.title,
      required this.left,
      this.right,
      this.color,
      this.leftIconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 50.h, 20.w, 0),
      child: SizedBox(
        width: 430.w,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            left
                ? SizedBox(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      iconSize: 30.r,
                      color: leftIconColor ?? ColorManager.c1,
                    ),
                  )
                : SizedBox.fromSize(
                    size: Size.fromRadius(60.r),
                  ),
            const Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color ?? ColorManager.c1,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            right ??
                SizedBox.fromSize(
                  size: Size.fromRadius(30.r),
                ),
          ],
        ),
      ),
    );
  }
}
