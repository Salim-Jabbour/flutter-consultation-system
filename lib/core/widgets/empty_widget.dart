import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../config/theme/color_manager.dart';
import '../resource/asset_manager.dart';
import '../resource/string_manager.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            AssetJsonManager.empty,
            height: 300.h,
          ),
          Text(
            StringManager.noData.tr(),
            style: TextStyle(
              color: ColorManager.c1,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
