import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';

class AddSupervisionRequestButton extends StatelessWidget {
  const AddSupervisionRequestButton({super.key, required this.onTapFunction});
  final Function() onTapFunction;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: StringManager.addSupervisionRequest.tr(),
      preferBelow: true,
      textStyle: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
      ),
      child: InkWell(
        onTap: onTapFunction,
        child: Container(
          width: 35.w,
          height: 35.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorManager.c1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          child: Icon(
            Icons.add_rounded,
            size: 25.sp,
            color: ColorManager.c1,
          ),
        ),
      ),
    );
  }
}
