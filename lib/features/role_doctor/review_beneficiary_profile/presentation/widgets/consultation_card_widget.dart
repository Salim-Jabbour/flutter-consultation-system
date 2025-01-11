import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/const_manager.dart';
import '../../models/beneficiary_consultation_model.dart';

class ConsultationCardWidget extends StatelessWidget {
  const ConsultationCardWidget({
    super.key,
    required this.details,
    this.width = 400,
    this.height = 150,
    this.cardColor = Colors.white,
    required this.onTap,
  });
  final BeneficiaryConsultationDetails details;

  final double? width;
  final double? height;
  final Color? cardColor;
  final Function() onTap;
  final Color textColor = ColorManager.c1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8),
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
          onTap: onTap,
          child: Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: CachedNetworkImageProvider(
                            details.beneficiary?.profileImg ??
                                ConstManager.tempImage,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          details.beneficiary?.name ??
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
                          details.specialization?.name ?? 'أُخرى',
                          style: TextStyle(
                            color: ColorManager.c1,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          details.consultationText != null &&
                                  details.consultationText!.length > 40
                              ? '${details.consultationText!.substring(0, 37)}...'
                              : details.consultationText ?? '',
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
