import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../config/theme/color_manager.dart';
import '../resource/string_manager.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    this.fullScreen = false,
    super.key,
  });

  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh - 0.15.sh,
      width: 1.sw,
      color:
          fullScreen == true ? ColorManager.c3 : Colors.black.withOpacity(0.22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.inkDrop(
              color: ColorManager.c2,
              size: 55.r,
            ),
          ),
          Padding(
            padding:const EdgeInsets.all(15),
            child: Text(
              StringManager.loading.tr(),
              style: TextStyle(
                color: ColorManager.c1,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
