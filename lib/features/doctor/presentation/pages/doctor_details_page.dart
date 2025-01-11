// import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/header_page.dart';
import '../../model/doctor_model.dart';

class DoctorDetailsPage extends StatelessWidget {
  const DoctorDetailsPage({super.key, required this.doctorDataModel});

  final DoctorDataModel doctorDataModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.c2,
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HeaderPage(
                  title: "",
                  left: true,
                  leftIconColor: Colors.white,
                ),
                // SizedBox(height: 10.h),
                SizedBox(
                  height: 0.28.sh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorDataModel.name ?? "doctor",
                              // textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.c4,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Text(
                                doctorDataModel
                                        .specialization?.name ??
                                    "other",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(43.w, 10.w, 10.w, 0),
                        child: SizedBox(
                          height: 300.h,
                          width: 140.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              topRight: Radius.circular(10.r),
                            ),
                            child: Hero(
                              tag: doctorDataModel.profileImage == null
                                  ? ConstManager.tempImage +
                                      doctorDataModel.id.toString()
                                  : doctorDataModel.profileImage! +
                                      doctorDataModel.id.toString(),
                              child: Image.network(
                                doctorDataModel.profileImage ??
                                    ConstManager.tempImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.6.sh,
                  width: 1.sw,
                  decoration: ShapeDecoration(
                    color: const Color.fromARGB(255, 229, 229, 229),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60.r),
                        topRight: Radius.circular(60.r),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                        child: Text(
                          doctorDataModel.description ?? "description",
                          style: TextStyle(
                            color: ColorManager.c2,
                            fontSize: 14.sp,
                            wordSpacing: 2.w,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: CustomButton(
                          text: doctorDataModel.answeredConsultation == null
                              ? "0"
                              : "${doctorDataModel.answeredConsultation} ${StringManager.answeredConsultation.tr()}",
                          width: 180.w,
                          height: 50.h,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w200,
                          onPressed: null,
                          disabledColor: ColorManager.c2,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
