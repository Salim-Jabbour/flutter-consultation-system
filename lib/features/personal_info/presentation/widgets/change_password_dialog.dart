import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/core/widgets/custom_text_field.dart';
import 'package:akemha/core/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

void showChangePasswordDialog(BuildContext context) {
  OverlayPortalController controller = OverlayPortalController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final bloc = GetIt.I.get<AuthBloc>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider<AuthBloc>(
        create: (context) => bloc,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthChangePasswordSuccess) {
              controller.hide();
              gShowSuccessSnackBar(
                  context: context, message: StringManager.changePasswordSuccess.tr());

              // context.goNamed(RouteManager.profile);
              // context.pushReplacementNamed(RouteManager.splash);
              // context.goNamed(RouteManager.personalInfo);
              // context.pushReplacementNamed(RouteManager.login);
            }

            if (state is AuthChangePasswordFailed) {
              controller.hide();
              gShowErrorSnackBar(
                  context: context, message: StringManager.sthWrong.tr());

              // Navigator.of(context).pop();
              // context.goNamed(RouteManager.profile);
              // context.pop();
              // FIXME:
              // context.pushReplacementNamed(RouteManager.login);
            }
          },
          child: AlertDialog(
            backgroundColor: ColorManager.c3,
            title: Center(
              child: Text(
                StringManager.changePassword.tr(),
                style: TextStyle(
                    color: ColorManager.c1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp),
              ),
            ),
            content: SizedBox(
              height: 260.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextField(
                    textEditingController: oldPasswordController,
                    hintText: StringManager.oldPassword.tr(),
                    textFieldColor: ColorManager.c3,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextField(
                    textEditingController: newPasswordController,
                    hintText: StringManager.newPassword.tr(),
                    textFieldColor: ColorManager.c3,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextField(
                    textEditingController: confirmNewPasswordController,
                    hintText: StringManager.confirmNewPassword.tr(),
                    textFieldColor: ColorManager.c3,
                  ),
                ],
              ),
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
                  if (newPasswordController.text ==
                      confirmNewPasswordController.text) {
                    controller.show();
                    // context.pop();
                    bloc.add(AuthChangePasswordRequested(
                        oldPassword: oldPasswordController.text,
                        newPassword: newPasswordController.text));
                  } else {
                    gShowErrorSnackBar(
                        context: context, message: "password not the same");
                  }
                },
                child: Text(
                  StringManager.changePassword.tr(),
                  style: TextStyle(color: ColorManager.c2, fontSize: 14.sp),
                ),
              ),
              OverlayPortal(
                  controller: controller,
                  overlayChildBuilder: (context) {
                    return const LoadingWidget();
                  })
            ],
          ),
        ),
      );
    },
  );
}
