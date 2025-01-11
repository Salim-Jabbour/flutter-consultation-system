import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showLogoutDialog(BuildContext context, Function() onTapFunction) {
  OverlayPortalController controller = OverlayPortalController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // final bloc = GetIt.I.get<ProfileBloc>();
      return AlertDialog(
        backgroundColor: ColorManager.c3,
        title: Text(
          StringManager.logout.tr(),
          style: TextStyle(
            color: ColorManager.c1,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          StringManager.logoutMessage.tr(),
          style: TextStyle(color: ColorManager.c1, fontSize: 14.sp),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              StringManager.cancel.tr(),
              style: TextStyle(
                color: ColorManager.red,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Perform logout operation here
              controller.show();
              onTapFunction();
              // context.read<AuthBloc>().add(AuthLogoutRequested(
              //     context.read<AuthBloc>().token ?? ApiService.token ?? ""));
              context.pop();
            },
            child: Text(
              StringManager.logout.tr(),
              style: TextStyle(color: ColorManager.c2, fontSize: 14.sp),
            ),
          ),
          OverlayPortal(
              controller: controller,
              overlayChildBuilder: (context) {
                return const LoadingWidget();
              })
        ],
      );
    },
  );
}
