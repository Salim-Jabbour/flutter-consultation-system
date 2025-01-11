import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/features/home/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key, required this.comment,
  });
final CommentModel comment;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.r,
        backgroundImage: CachedNetworkImageProvider(
          comment.doctor.profileImg??"https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200"
        ),
      ),
      title: Text(
        comment.doctor.name,
        style: TextStyle(
          color: ColorManager.c2,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        comment.description,
        style: TextStyle(
          color: ColorManager.c1,
          fontSize: 14.sp,
          // fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(
        Icons.more_horiz,
        color: ColorManager.c2,
      ),
    );
  }
}