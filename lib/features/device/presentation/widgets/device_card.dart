import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/features/device/models/device_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    this.width = 400,
    this.height = 150,
    this.cardColor = Colors.white,
    // this.textColor = const Color(0xFF333333),
    super.key,
    required this.deviceModel,
    this.onTap,
  });

  final DeviceModel deviceModel;

  final double width;
  final double height;
  final Color cardColor;
  final Color textColor = ColorManager.c1;
  final  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 4.h,end: 8,start: 8),
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
          // width: width.w,
          // height: height.h,
          child: Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0.r),
              // child: ListTile(
              //   leading: Container(
              //     height: 200,
              //     width: height.h * .8,
              //     decoration: BoxDecoration(
              //       color: ColorManager.green,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(8),
              //       child: CachedNetworkImage(
              //         imageUrl: deviceModel.deviceImage,
              //         fit: BoxFit.fill,
              //       ),
              //     ),
              //   ),
              //   title: Text(deviceModel.deviceName),
              //   subtitle: Text(deviceModel.deviceQuantity.toString()),
              // ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Container(
                      height: height.h * .8,
                      width: height.h * .8,
                      decoration: BoxDecoration(
                        color: ColorManager.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: deviceModel?.imageUrl ?? ConstManager.tempImage,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deviceModel.name,
                          style: TextStyle(
                            color: ColorManager.c1,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${StringManager.quantity.tr()}: ${deviceModel.count}",
                          style: TextStyle(
                            color: ColorManager.c2,
                            fontSize: 16.sp,
                          ),
                        ),
                        // Text(
                        //   consultationModel.consultationDescription,
                        //   overflow: TextOverflow.clip,
                        //   style: TextStyle(
                        //     color: ColorManager.c4,
                        //     fontSize: 14.sp,
                        //   ),
                        // )
                      ],
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