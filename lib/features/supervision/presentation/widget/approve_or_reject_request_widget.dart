import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';

class ApproveOrRejectRequestWidget extends StatelessWidget {
  const ApproveOrRejectRequestWidget({
    super.key,
    required this.approveFunction,
    required this.refuseFunction,
  });
  final Function() approveFunction;
  final Function() refuseFunction;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110.w,
      child: Row(
        children: [
          Tooltip(
            message: StringManager.approve.tr(),
            preferBelow: true,
            textStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: approveFunction,
              icon: Icon(
                Icons.check_box_rounded,
                color: ColorManager.c2,
                size: 25.sp,
              ),
            ),
          ),
          Tooltip(
               message: StringManager.refuse.tr(),
            preferBelow: true,
            textStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: refuseFunction,
              icon: Icon(
                Icons.close,
                color: ColorManager.red,
                size: 25.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
