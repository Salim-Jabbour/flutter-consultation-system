import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> gShowErrorSnackBar(
    {required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.white,
            size: 50.r,
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: .6.sw,
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade700,
      duration: const Duration(seconds: 3),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> gShowSuccessSnackBar(
    {required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.done,
            color: Colors.white,
            size: 50.r,
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: .6.sw,
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.lightGreenAccent.shade700,
      duration: const Duration(seconds: 3),
    ),
  );
}
