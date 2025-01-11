import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/core/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/dbg_print.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

void showRateConsultationDialog(BuildContext context, int id) {
  OverlayPortalController controller = OverlayPortalController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final bloc = GetIt.I.get<AuthBloc>();
      return BlocProvider(
        create: (context) => bloc,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLogoutSuccess) {
              gShowSuccessSnackBar(
                  context: context, message: StringManager.logoutSuccess.tr());
              // TODO: changed from splash to login

              controller.hide();
              // context.pushReplacementNamed(RouteManager.splash);
              context.pop();
              // context.pushReplacementNamed(RouteManager.login);
            }

            if (state is AuthLogoutFailed) {
              gShowErrorSnackBar(
                  context: context, message: StringManager.sthWrong.tr());
              controller.hide();
              context.pop();
              // FIXME:
              // context.pushReplacementNamed(RouteManager.login);
            }
          },
          child: AlertDialog(
            backgroundColor: ColorManager.c3,
            title: Center(
              child: Text(
                StringManager.rate.tr(),
                style: TextStyle(
                  color: ColorManager.c1,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
            content: SizedBox(
              height: 80.h,
              child: Column(
                children: [
                  Text("do you like this?"),
                  SizedBox(
                    height: 10.h,
                  ),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    unratedColor: Colors.amber.shade50,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    glow: true,
                    glowColor: Colors.amber.shade100,
                    onRatingUpdate: (rating) {
                      dbg(rating);
                    },
                  )
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
                onPressed: () {},
                child: Text(
                  StringManager.rate.tr(),
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
