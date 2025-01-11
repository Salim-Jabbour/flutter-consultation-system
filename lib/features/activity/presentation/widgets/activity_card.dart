import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
  });

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    activity.title,
                    style: TextStyle(
                      color: ColorManager.c1,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  activity.description,
                  style: TextStyle(
                    color: ColorManager.c1,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          activity.imageUrl != null
              ? Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  height: 200,
                  width: double.maxFinite,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: activity.imageUrl ?? ConstManager.tempImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          // const SizedBox(height: 16)
        ],
      ),
    );
  }
}
