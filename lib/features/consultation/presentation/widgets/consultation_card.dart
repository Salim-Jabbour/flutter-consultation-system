import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/core/resource/const_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/color_manager.dart';
import '../../models/Consultation.dart';

class ConsultationCard extends StatelessWidget {
  const ConsultationCard({
    this.width = 400,
    this.height = 150,
    this.cardColor = Colors.white,
    // this.textColor = const Color(0xFF333333),
    super.key,
    required this.consultationModel,
    this.isMyLog = false,
    this.canRate = false,
    this.canAnswered = false,
  });

  final Consultation consultationModel;

  final double? width;
  final double? height;
  final Color? cardColor;
  final Color textColor = ColorManager.c1;
  final bool isMyLog;
  final bool canRate;
  final bool canAnswered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 8.h),
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
          onTap: () {
            context.pushNamed(
              RouteManager.consultation,
              extra: {
                "consultation": consultationModel,
                "isMyLog": isMyLog,
                "canRate": canRate,
                "canAnswered": canAnswered,
              },
            );
          },
          child: Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: CachedNetworkImageProvider(
                              consultationModel.beneficiary?.profileImg ??
                                  ConstManager.tempImage),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          consultationModel.beneficiary?.name ??
                              ConstManager.userModel.name,
                          style: TextStyle(
                            color: ColorManager.c1,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consultationModel.specialization.name,
                          style: TextStyle(
                            color: ColorManager.c1,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   consultationModel.consultationStatus,
                        //   style: TextStyle(
                        //     color: ColorManager.c2,
                        //     fontSize: 16.sp,
                        //   ),
                        // ),
                        Text(
                          consultationModel.consultationText,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: ColorManager.c4,
                            fontSize: 14.sp,
                          ),
                        )
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
