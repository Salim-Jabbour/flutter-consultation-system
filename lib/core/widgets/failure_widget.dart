import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/color_manager.dart';
import '../resource/asset_manager.dart';
import 'package:lottie/lottie.dart';

import '../resource/string_manager.dart';
import 'custom_button.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    required this.errorMessage,
    required this.onPressed,
  });
  final String errorMessage;
  final dynamic Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh - 0.25.sh,
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            AssetJsonManager.error,
            height: 300.h,
          ),
          Text(
            errorMessage,
            style: TextStyle(
                color: ColorManager.c1,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 40,
          ),
          CustomButton(
            onPressed: onPressed,
            text: StringManager.tryAgain.tr(),
          )
        ],
      ),
    );
  }
}
