import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/const_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/global_snackbar.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/image_viewer.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../review_beneficiary_profile/models/beneficiary_consultation_model.dart';
import '../manager/doctor_consultation/doctor_consultations_bloc.dart';

class DoctorConsultationDetailsPage extends StatefulWidget {
  const DoctorConsultationDetailsPage(
      {super.key, required this.consultationModel, required this.bloc});

  final BeneficiaryConsultationDetails consultationModel;

  final DoctorConsultationsBloc bloc;

  @override
  State<DoctorConsultationDetailsPage> createState() =>
      _DoctorConsultationDetailsPageState();
}

class _DoctorConsultationDetailsPageState
    extends State<DoctorConsultationDetailsPage> {
  late bool isChatOpen;
  @override
  void initState() {
    isChatOpen = widget.consultationModel.isChatOpen!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: StringManager.consultation.tr(),
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
                  leading: CircleAvatar(
                    // radius: 40.r,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.consultationModel.beneficiary?.profileImg ??
                          ConstManager.tempImage,
                    ),
                  ),
                  title: Text(
                    widget.consultationModel.beneficiary?.name ??
                        ConstManager.userModel.name,
                    style: TextStyle(
                      color: ColorManager.c2,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.consultationModel.specialization?.name ??
                                'أُخرى',
                            style: TextStyle(
                              color: ColorManager.c1,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.consultationModel.consultationText ?? '',
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
                child: SizedBox(
                  height: 200,
                  width: 400.w,
                  child: widget.consultationModel.images != null &&
                          widget.consultationModel.images!.isEmpty
                      ? Center(
                          child: Text(
                            StringManager.noImagesAttached.tr(),
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.c1),
                          ),
                        )
                      : CarouselSlider.builder(
                          // disableGesture: true,
                          itemCount:
                              widget.consultationModel.images?.length ?? 0,
                          itemBuilder: (context, index, realIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_left_rounded,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                ImageViewer(
                                  child: SizedBox(
                                    width: 300.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.network(
                                        widget.consultationModel
                                                .images?[index] ??
                                            '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_right_rounded,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          },
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            disableCenter: true,
                          ),
                        ),
                ),
              ),
              //ToDo: fix appearance of this
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    // radius: 40.r,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.consultationModel.doctor?.profileImg ??
                          ConstManager.tempImage,
                    ),
                  ),
                  title: Text(
                    widget.consultationModel.doctor?.name ??
                        ConstManager.userModel.name,
                    style: TextStyle(
                      color: ColorManager.c2,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.consultationModel.consultationAnswer ?? "no answer",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: ColorManager.c4,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              // chat btton
              Center(
                child: CustomButton(
                    disabledColor: Colors.grey.shade400,
                    text: StringManager.chat.tr(),
                    onPressed: isChatOpen == true
                        ? () {
                            final doctorModel = UserLessResponse(
                                id: widget.consultationModel.doctor!.id,
                                name: widget.consultationModel.doctor?.name ??
                                    "name",
                                email: "email",
                                profileImg: widget
                                        .consultationModel.doctor?.profileImg ??
                                    ConstManager.tempImage);
                            final beneficiaryModel = UserLessResponse(
                                id: widget.consultationModel.beneficiary!.id,
                                name: widget
                                        .consultationModel.beneficiary?.name ??
                                    "name",
                                email: "email",
                                profileImg: widget.consultationModel.beneficiary
                                        ?.profileImg ??
                                    ConstManager.tempImage);
                            context.push(
                                '/chat/${widget.consultationModel.id}/${widget.consultationModel.title}',
                                extra: {
                                  'doctorModel': doctorModel,
                                  'beneficiaryModel': beneficiaryModel,
                                });
                          }
                        : null),
              ),
              const SizedBox(height: 30.0),

              BlocListener<DoctorConsultationsBloc, DoctorConsultationsState>(
                listener: (context, state) {
                  if (state is DoctorChangeStatusSuccess) {
                    setState(() {
                      isChatOpen = !isChatOpen;
                    });

                    gShowSuccessSnackBar(
                      context: context,
                      message: StringManager.updatedSuccessfully.tr(),
                    );
                  }
                  if (state is DoctorChangeStatusFailure) {
                    gShowErrorSnackBar(
                      context: context,
                      message: state.failure.message,
                    );
                  }
                },
                child: Center(
                  child: Switch(
                    activeColor: ColorManager.c2,
                    inactiveThumbColor: ColorManager.red,
                    inactiveTrackColor: ColorManager.red.withOpacity(0.2),
                    value: isChatOpen,
                    onChanged: (bool newValue) {
                      widget.bloc.add(DoctorChangeStatusEvent(
                        context.read<AuthBloc>().token ??
                            ApiService.token ??
                            "",
                        widget.consultationModel.id.toString(),
                        !isChatOpen,
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
