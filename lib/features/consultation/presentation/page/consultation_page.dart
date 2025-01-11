import 'dart:async';

import 'package:akemha/core/resource/const_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/core/widgets/image_viewer.dart';
import 'package:akemha/features/consultation/presentation/bloc/consultation_bloc.dart';
import 'package:akemha/features/consultation/presentation/widgets/answer_dialog.dart';
import 'package:akemha/features/role_doctor/doctor_profile/presentation/manager/doctor_consultation/doctor_consultations_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_manager.dart';
import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/dbg_print.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../chat/model/message_consultation_model.dart';
import '../../models/Consultation.dart';

class ConsultationPage extends StatelessWidget {
  const ConsultationPage({
    super.key,
    required this.consultationModel,
    required this.isMyLog,
    required this.canAnswered,
    required this.canRate,
  });

  final Consultation consultationModel;
  final bool isMyLog;
  final bool canAnswered;
  final bool canRate;

  @override
  Widget build(BuildContext context) {
    num rate = consultationModel.rating ?? 0.0;
    return Scaffold(
      appBar: const CustomAppBar(
        left: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                // TODO: add can answered if yes take him to the user profile
                leading: GestureDetector(
                  onTap: !canAnswered
                      ? null
                      : () {
                          context.pushNamed(
                            RouteManager.reviewBeneficiaryProfile,
                            extra:
                                consultationModel.beneficiary?.id.toString() ??
                                    "2",
                          );
                        },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40.r,
                    backgroundImage: CachedNetworkImageProvider(
                      consultationModel.beneficiary?.profileImg ??
                          ConstManager.tempImage,
                    ),
                  ),
                ),
                title: Text(
                  consultationModel.beneficiary?.name ??
                      ConstManager.userModel.name,
                  style: TextStyle(
                    color: ColorManager.c2,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(
                  Icons.more_vert,
                  color: ColorManager.c2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consultationModel.specialization.name,
                          style: TextStyle(
                            color: ColorManager.c1,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   consultationModel.consultationStatus,
                        //   style: TextStyle(
                        //     color: ColorManager.c2,
                        //     fontSize: 16.sp,
                        //   ),
                        // ),
                        Text(
                          consultationModel.consultationText,
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
              child: CarouselSlider.builder(
                itemCount: consultationModel.images.length,
                itemBuilder: (context, index, realIndex) {
                  return ImageViewer(
                    child: CachedNetworkImage(
                        imageUrl: consultationModel.images[index]),
                  );
                  // return RoundedImage(
                  //   imageUrl: images[index],
                  // );
                },
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  // onPageChanged: (index, reason) {
                  //   setState(() {
                  //     this.index = index;
                  //   });
                  //   // _pageController.jumpToPage(index);
                  // },
                ),
              ),
            ),
            Center(
              child: Container(
                height: .4.sh,
                width: .95.sw,
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
                child: Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            StringManager.theAnswer.tr(),
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: ColorManager.c2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: 100.h,
                            child: Text(
                              consultationModel.consultationAnswer ??
                                  "no answer",
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: ColorManager.c4,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        canRate
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 25.0.h,
                                  ),
                                  child: BlocProvider(
                                    create: (context) =>
                                        GetIt.I.get<ConsultationBloc>(),
                                    child: BlocConsumer<ConsultationBloc,
                                        ConsultationState>(
                                      listener: (context, state) {
                                        if (state is ConsultationRateFailure) {
                                          gShowErrorSnackBar(
                                              context: context,
                                              message: state.errMessage);
                                        }
                                        if (state is ConsultationRateSuccess) {
                                          gShowSuccessSnackBar(
                                              context: context,
                                              message: StringManager
                                                  .addedSuccessfully
                                                  .tr());
                                        }

                                        if (state
                                            is DoctorGetConsultationsSuccess) {
                                          consultationModel.rating = rate;
                                        }
                                      },
                                      builder: (context, state) {
                                        return RatingBar.builder(
                                          initialRating: consultationModel
                                                  .rating
                                                  ?.toDouble() ??
                                              0.0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ignoreGestures:
                                              state is ConsultationRateLoading,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          unratedColor: Colors.grey.shade300,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          glow: true,
                                          glowColor: Colors.amber.shade100,
                                          onRatingUpdate: (rating) {
                                            Timer(
                                                const Duration(
                                                  milliseconds: 500,
                                                ), () {
                                              context
                                                  .read<ConsultationBloc>()
                                                  .add(RateConsultation(
                                                    rate: rate,
                                                    id: consultationModel.id,
                                                  ));
                                            });
                                            dbg(rating);
                                            rate = rating;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        !isMyLog
                            ? const SizedBox.shrink()
                            : Center(
                                child: CustomButton(
                                text: StringManager.chat.tr(),
                                onPressed: () {
                                  dbg(int.tryParse(
                                          "${consultationModel.doctor?.id}") ??
                                      0);
                                  dbg(int.tryParse(
                                          "${consultationModel.beneficiary?.id}") ??
                                      0);
                                  final doctorModel = UserLessResponse(
                                      id: int.tryParse(
                                              "${consultationModel.doctor?.id}") ??
                                          0,
                                      name: consultationModel.doctor?.name ??
                                          "name",
                                      email: "email",
                                      profileImg: consultationModel
                                              .doctor?.profileImg ??
                                          "https://neweralive.na/storage/images/2023/may/lloyd-sikeba.jpg");
                                  final beneficiaryModel = UserLessResponse(
                                      id: int.tryParse(
                                              "${consultationModel.beneficiary?.id}") ??
                                          0,
                                      name:
                                          consultationModel.beneficiary?.name ??
                                              "name",
                                      email: "email",
                                      profileImg: consultationModel
                                              .beneficiary?.profileImg ??
                                          "https://neweralive.na/storage/images/2023/may/lloyd-sikeba.jpg");
                                  context.push(
                                      '/chat/${consultationModel.id}/${consultationModel.title}',
                                      extra: {
                                        'doctorModel': doctorModel,
                                        'beneficiaryModel': beneficiaryModel,
                                      });
                                },
                              )),
                        !canAnswered
                            ? const SizedBox.shrink()
                            : Center(
                                child: CustomButton(
                                  text: StringManager.answer.tr(),
                                  onPressed: () {
                                    showAnswerDialog(
                                        context, consultationModel.id);
                                  },
                                ),
                              )
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
