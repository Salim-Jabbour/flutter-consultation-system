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
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../consultation/models/specialization.dart';
import '../../../../consultation/presentation/page/request_consultation_page.dart';
import '../../models/doctor_profile_model.dart';
import '../manager/doctor_profile/doctor_profile_bloc.dart';
import '../widgets/profile_image_widget.dart';

class DoctorPersonalInfo extends StatefulWidget {
  const DoctorPersonalInfo(
      {super.key, required this.model, required this.bloc});

  final DoctorProfileDetailsModel? model;

  final DoctorProfileBloc bloc;

  @override
  State<DoctorPersonalInfo> createState() => _DoctorPersonalInfoState();
}

class _DoctorPersonalInfoState extends State<DoctorPersonalInfo> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController openingTimesController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  List<Specialization> specializations = [];

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    openingTimesController.dispose();
    descriptionController.dispose();
    _specializationController.dispose();
    // widget.bloc.
    super.dispose();
  }

  @override
  void initState() {
    nameController.text = widget.model?.name ?? '';
    descriptionController.text = widget.model?.description ?? '';
    locationController.text = widget.model?.location ?? '';
    openingTimesController.text = widget.model?.openingTimes ?? '';

    widget.bloc.add(DoctorProfileGetSpecializationsEvent(
      context.read<AuthBloc>().token ?? ApiService.token ?? '',
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.c3,
        body: SingleChildScrollView(
          child: BlocProvider.value(
            value: widget.bloc,
            // create: (context) => widget.bloc,
            // create: (context) => context.read<DoctorProfileBloc>(),
            child: BlocConsumer<DoctorProfileBloc, DoctorProfileState>(
              listener: (context, state) {
                if (state is DoctorUpdateProfileSuccess) {
                  gShowSuccessSnackBar(
                    context: context,
                    message: state.msg,
                  );

                  context.pop();

                  context.read<DoctorProfileBloc>().add(
                        DoctorGetProfileEvent(
                          context.read<AuthBloc>().token ??
                              ApiService.token ??
                              '',
                          context.read<AuthBloc>().userId ??
                              ApiService.userId ??
                              '2',
                        ),
                      );
                }

                if (state is DoctorUpdateProfileFailure) {
                  gShowErrorSnackBar(
                    context: context,
                    message: state.failure.message,
                  );
                }

                if (state is DoctorProfileSpecializationSuccess) {
                  specializations = state.model.data;
                }

                // if (state is DoctorGetProfileSuccess) {
                //   _bloc.model = state.model.data;
                // }
              },
              builder: (context, state) {
                if (state is DoctorProfileInitial) {
                  widget.bloc.add(DoctorProfileGetSpecializationsEvent(
                    context.read<AuthBloc>().token ?? ApiService.token ?? '',
                  ));
                }
                return Stack(
                  children: [
                    SizedBox(
                      height: 90.h,
                      child: AppBar(
                        backgroundColor: ColorManager.c3,
                        title: Text(
                          StringManager.personalInfo.tr(),
                          style: const TextStyle(
                            color: ColorManager.c1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: IconButton(
                          onPressed: () {
                            context.pop();
                            // context.pushReplacementNamed(RouteManager.profile);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        centerTitle: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 100.h),
                            ProfileImageWidget(
                              profileImage: widget.model?.profileImage ??
                                  ConstManager.tempImage,
                            ),
                            // name
                            SizedBox(height: 60.h),
                            CustomTextField(
                              hintText: StringManager.userNameHintText.tr(),
                              icon: Icons.person,
                              textEditingController: nameController,
                            ),
                            // description
                            SizedBox(height: 30.h),
                            CustomTextField(
                              hintText: StringManager.description.tr(),
                              icon: Icons.description_rounded,
                              textEditingController: descriptionController,
                            ),
                            // location
                            SizedBox(height: 30.h),
                            CustomTextField(
                              hintText: StringManager.location.tr(),
                              icon: Icons.location_on_rounded,
                              textEditingController: locationController,
                            ),
                            //opening times
                            SizedBox(height: 30.h),
                            CustomTextField(
                              hintText: StringManager.openingTimes.tr(),
                              icon: Icons.timelapse_rounded,
                              textEditingController: openingTimesController,
                            ),

                            SizedBox(height: 30.h),

                            CustomDropdownButton(
                              controller: _specializationController,
                              values: specializations.sublist(0),
                              title: StringManager.specialization.tr(),
                            ),
                            SizedBox(height: 40.h),
                            Center(
                              child: CustomButton(
                                text: StringManager.update.tr(),
                                width: 200.0.w,
                                onPressed: () {
                                  DoctorProfileDetailsModel updatedModel =
                                      DoctorProfileDetailsModel(
                                    // sending the spicializtion Id in the variable
                                    id: _specializationController.text.isEmpty
                                        ? 0
                                        : int.parse(
                                            _specializationController.text),
                                    profileImage: null,
                                    name: nameController.text.isEmpty
                                        ? null
                                        : nameController.text,
                                    location: locationController.text.isEmpty
                                        ? null
                                        : locationController.text,
                                    openingTimes:
                                        openingTimesController.text.isEmpty
                                            ? null
                                            : openingTimesController.text,
                                    description:
                                        descriptionController.text.isEmpty
                                            ? null
                                            : descriptionController.text,
                                    specialization: null,
                                  );
                                  context
                                      .read<DoctorProfileBloc>()
                                      .add(DoctorUpdateProfileEvent(
                                        token: context.read<AuthBloc>().token ??
                                            ApiService.token ??
                                            '',
                                        data: updatedModel,
                                        profileImg: context
                                            .read<DoctorProfileBloc>()
                                            .profileImage,
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state is DoctorProfileLoading)
                      Padding(
                        padding: EdgeInsets.only(top: 0.0.h),
                        child: SizedBox(
                            height: 1.sh,
                            child: const LoadingWidget(fullScreen: false)),
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
