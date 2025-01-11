import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/core/widgets/custom_text_field.dart';
import 'package:akemha/core/widgets/loading_widget.dart';
import 'package:akemha/features/consultation/presentation/bloc/answer_consultation_cubit.dart';
import 'package:akemha/features/consultation/presentation/bloc/doctor_consultation_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_manager.dart';

void showAnswerDialog(BuildContext context, int id) {
  OverlayPortalController controller = OverlayPortalController();
  TextEditingController answerController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final bloc = GetIt.I.get<AnswerConsultationCubit>();
      return BlocProvider(
        create: (context) => bloc,
        child: BlocListener<AnswerConsultationCubit, AnswerConsultationState>(
          listener: (context, state) {
            if (state is AnswerConsultationSuccess) {
              print("ENTERED HERE:");
              gShowSuccessSnackBar(
                context: context,
                // message: StringManager.logoutSuccess.tr(),
                message: StringManager.answerSuccess.tr(),
              );
              context
                  .read<DoctorConsultationBloc>()
                  .add(GetDoctorConsultationsPage());
              context.pop();
              context.pop();
              // context.goNamed(RouteManager.consultations);
            }

            if (state is AnswerConsultationFailure) {
              print("ENTERED THERE:");

              gShowErrorSnackBar(
                  context: context, message: StringManager.sthWrong.tr());
              context.pop();
              context.pop();
            }
          },
          child: AlertDialog(
            backgroundColor: ColorManager.c3,
            title: Text(
              StringManager.answer.tr(),
              style: TextStyle(
                  color: ColorManager.c1,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp),
            ),
            content: SizedBox(
              height: 200.h,
              width: 400.w,
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: answerController,
                    textFieldColor: ColorManager.c3,
                    height: 200.h,
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
                onPressed: () {
                  controller.show();
                  context.pop();
                  context.pop();
                  bloc.answerConsultation(answerController.text, id);
                },
                child: Text(
                  StringManager.answer.tr(),
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
