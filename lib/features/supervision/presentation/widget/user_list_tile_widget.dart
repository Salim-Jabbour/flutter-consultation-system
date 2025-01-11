import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../model/supervision_model.dart';

class UserListTileWidget extends StatelessWidget {
  const UserListTileWidget({
    super.key,
    required this.model,
    this.widget,
  });
  final UserLessResponseModel model;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 35.r,
        backgroundColor: ColorManager.white,
        backgroundImage: NetworkImage(model.profileImg ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMDUP9O9BQAw8-2WxkfCUZ_2iBoAc4xvmQDMFab_hi-Q&s'),
      ),
      title: Text(
        model.name,
        style: TextStyle(
          color: ColorManager.c1,
          fontSize: 18.sp,
        ),
      ),
      subtitle: Text(
        model.email,
        style: TextStyle(
          color: ColorManager.grey,
          fontSize: 14.sp,
        ),
      ),
      trailing: widget,
    );
  }
}
