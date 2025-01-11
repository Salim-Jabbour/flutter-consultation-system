import 'package:akemha/config/router/route_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../model/doctor_model.dart';

class DoctorDetailsCard extends StatelessWidget {
  const DoctorDetailsCard({
    required this.doctorDataModel,
    super.key,
  });

  final DoctorDataModel doctorDataModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouteManager.doctor,
          extra: doctorDataModel,
        );
      },
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x338A959E),
              blurRadius: 40,
              offset: Offset(0, 8),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Container(
                height: 180.h,
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                  color: ColorManager.lightGrey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(
                        RouteManager.doctor,
                        extra: doctorDataModel,
                      );
                    },
                    child: Hero(
                      tag: doctorDataModel.profileImage == null
                          ? ConstManager.tempImage +
                              doctorDataModel.id.toString()
                          : doctorDataModel.profileImage! +
                              doctorDataModel.id.toString(),
                      child: Image.network(
                        doctorDataModel.profileImage ?? ConstManager.tempImage,
                        fit: BoxFit.fill,
                        // color: ColorManager.lightGrey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150.w,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorDataModel.name ?? "doctor",
                      // textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.c4,
                      ),
                    ),
                    Text(
                      doctorDataModel.specialization?.name ??
                          "أُخرى",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorManager.c2,
                      ),
                    ),
                    Text(
                      doctorDataModel.answeredConsultation == null
                          ? "0"
                          : "${doctorDataModel.answeredConsultation} ${StringManager.answeredConsultation.tr()}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w200,
                        color: ColorManager.c3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 10.w, bottom: 20.h),
              child: CustomButton(
                text: StringManager.view.tr(),
                width: 100.w,
                height: 50.h,
                fontSize: 12.sp,
                onPressed: () {
                  context.pushNamed(
                    RouteManager.doctor,
                    extra: doctorDataModel,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
