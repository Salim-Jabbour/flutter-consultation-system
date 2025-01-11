import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../doctor/model/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
  });

  final DoctorDataModel doctor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // context.pushNamed(
        //   RouteManager.doctor,
        //   extra: doctor,
        // );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0.h),
        child: Column(
          children: [
            Container(
              height: 130.h,
              width: 118.w,
              decoration: BoxDecoration(
                color: ColorManager.c2,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: CachedNetworkImage(
                  imageUrl: doctor.profileImage ??
                      'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              height: 60.h,
              width: 96.w,
              decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  )),
              child: Column(
                children: [
                  Text(
                    doctor.name ?? ConstManager.userModel.name,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorManager.c1,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    doctor.specialization?.name ?? "no specilazation",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
