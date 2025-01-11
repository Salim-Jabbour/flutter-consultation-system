import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/router/route_manager.dart';
import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/const_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/widgets/image_viewer.dart';
import '../../../../consultation/models/doctor.dart';
import '../../../../home/models/post_model.dart';
import '../../../../supervision/presentation/widget/removing_supervisor_icon_widget.dart';
import '../../models/doctor_post_model.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget(
      {super.key, required this.details, required this.deleteFunction});

  final DoctorPostDetailsModel details;

  final void Function() deleteFunction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        color: ColorManager.white,
        width: 100.sw,
        // height: 362.h,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                //doctor
                Doctor doctor = Doctor(
                  id: details.doctor!.id,
                  name: details.doctor?.name ?? ConstManager.userModel.name,
                  email: details.doctor?.email ?? ConstManager.userModel.email,
                  profileImg:
                      details.doctor?.profileImage ?? ConstManager.tempImage,
                );

                // post
                PostModel post = PostModel(
                  id: details.id,
                  doctor: doctor,
                  imageUrl: details.imageUrl!,
                  description: details.description!,
                  commentsCount: details.commentsCount!,
                  likesCount: details.likesCount!,
                  isLiked: false,
                );

                context.pushNamed(
                  RouteManager.post,
                  extra: post,
                );
              },
              child: Column(
                children: [
                  ListTile(
                    leading:
                     CircleAvatar(
                      backgroundColor: ColorManager.c3,
                      radius: 20.r,
                      backgroundImage: CachedNetworkImageProvider(
                          details.doctor?.profileImage ??
                              ConstManager.tempImage),
                    ),
                    title: Text(
                      details.doctor?.name ?? 'doctor',
                      style: TextStyle(
                        color: ColorManager.c2,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Tooltip(
                      message: StringManager.deleteConfirmation.tr(),
                      preferBelow: true,
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: ColorManager.c3,
                      ),
                      child: RemovingSupervisorIconButton(
                        headline: StringManager.deleteConfirmation.tr(),
                        headlineDetails:
                            StringManager.deleteConfirmationDetails.tr(),
                        onTapFunction: deleteFunction,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      details.description ?? '...',
                      maxLines: 100,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorManager.c1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ImageViewer(
              child: CachedNetworkImage(
                imageUrl: details.imageUrl ?? ConstManager.tempImage,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              height: 44.h,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: ColorManager.c3,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.thumb_up_outlined,
                          color: ColorManager.c2,
                          size: 16,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          "${details.likesCount ?? 0}",
                          style: TextStyle(
                              color: ColorManager.c2, fontSize: 18.sp),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    color: ColorManager.c3,
                    thickness: 1,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${details.commentsCount ?? 0}",
                          style: TextStyle(
                              color: ColorManager.c2, fontSize: 18.sp),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.mode_comment_outlined,
                          color: ColorManager.c2,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
