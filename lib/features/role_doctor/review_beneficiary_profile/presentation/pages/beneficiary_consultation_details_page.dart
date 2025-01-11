import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/const_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/widgets/image_viewer.dart';
import '../../models/beneficiary_consultation_model.dart';

class BeneficiaryConsultationDetailsPage extends StatelessWidget {
  const BeneficiaryConsultationDetailsPage(
      {super.key, required this.consultationModel});

  final BeneficiaryConsultationDetails consultationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StringManager.details.tr(),
        left: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                // radius: 40.r,
                backgroundImage: CachedNetworkImageProvider(
                  consultationModel.beneficiary?.profileImg ??
                      ConstManager.tempImage,
                ),
              ),
              title: Text(
                consultationModel.beneficiary?.name ??
                    ConstManager.userModel.name,
                style: TextStyle(
                  color: ColorManager.c2,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultationModel.specialization?.name ??
                            'أُخرى',
                        style: TextStyle(
                          color: ColorManager.c1,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        consultationModel.consultationText ?? '',
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
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.r,
            ),
            child: SizedBox(
              height: 200,
              width: 400.w,
              child: consultationModel.images != null &&
                      consultationModel.images!.isEmpty
                  ? Center(
                      child: Text(
                        StringManager.noImagesAttached.tr(),
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.c1),
                      ),
                    )
                  : CarouselSlider.builder(
                      // disableGesture: true,
                      itemCount: consultationModel.images?.length ?? 0,
                      itemBuilder: (context, index, realIndex) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.arrow_left_rounded,
                              size: 40,
                              color: Colors.grey,
                            ),
                            ImageViewer(
                              child: SizedBox(
                                width: 300.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    consultationModel.images?[index] ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_right_rounded,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        enlargeCenterPage: true,
                        disableCenter: true,
                      ),
                    ),
            ),
          ),
          //ToDo: fix appearance of this
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                // radius: 40.r,
                backgroundImage: CachedNetworkImageProvider(
                  consultationModel.doctor?.profileImg ??
                      ConstManager.tempImage,
                ),
              ),
              title: Text(
                consultationModel.doctor?.name ?? ConstManager.userModel.name,
                style: TextStyle(
                  color: ColorManager.c2,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              consultationModel.consultationAnswer ?? "no answer",
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: ColorManager.c4,
                fontSize: 14.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
